//
//  GanViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanUnComplateVC.h"
#import "GanUnComplateTableViewCell.h"
#import "GanDataManager.h"
#import "UIColor+HEXColor.h"
#import "MobClick.h"

@interface GanUnComplateVC ()<GanTableViewProtocol,UIPickerViewDelegate,UIPickerViewDataSource>{
    UIButton *_maskLayer;
    CGPoint _savedContentOffset;
    NSArray *_data;
    UIPickerView *_pickerView;
}

@end

@implementation GanUnComplateVC
-(id)init {
    self = [super init];
    if(self){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"clock.png"] tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    DLog(@"GanUnComplateVC viewDidLoad");
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self setBgColor];

    //创建一个导航栏集合
    UINavigationItem *navBarItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"todoTitle", @"")];

    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addOne:)];
    [navBarItem setRightBarButtonItem:rightButton];

    [self.navBar pushNavigationItem:navBarItem animated:NO];

    [self fitForiOS7];
    [self addMaskLayer];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataSource];
    [self.tableView reloadData];
    
    _data = @[@1,@2,@3,@4,@5,@6,@7,@8];
    _pickerView = [ [ UIPickerView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT_4INCH - 200, UI_SCREEN_WIDTH, 200)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.alpha = 0.85f;
    _pickerView.delegate = self;
    _pickerView.dataSource =  self;
    [self.view addSubview:_pickerView];
    _pickerView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    DLog(@"GanUnComplateVC didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self isViewLoaded] && self.view.window == nil){
        DLog(@"GanUnComplateVC unload view");
        self.view = nil;
    }
    self.tableView = nil;
    _maskLayer = nil;
    self.dataSource = nil;
    self.dataManager = nil;
}

- (void)viewDidUnload {
    DLog(@"GanUnComplateVC viewDidUnload");
    self.tableView = nil;
    [super viewDidUnload];
}

-(void)initDataSource{
    self.dataSource = [self.dataManager getUnCompletedData];
    DLog(@"dataSouce unComplate count:%i",[self.dataSource count]);
}

-(void)setBgColor{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithHEX:TABLE_BG alpha:1.0f]];
    [self.tableView setBackgroundView:backgroundView];
}

-(void)addMaskLayer{
    _maskLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = self.tableView.frame;
    frame.origin.y +=CELL_HEIGHT;
    [_maskLayer setFrame:frame];
    [_maskLayer setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [self.view insertSubview:_maskLayer aboveSubview:self.tableView];
    [_maskLayer addTarget:self action:@selector(blurCell:) forControlEvents:UIControlEventTouchUpInside];
    [self hideMaskLayer];
}

-(void)showMaskLayer{
    [_maskLayer setHidden:NO];
}

-(void)hideMaskLayer{
    [_maskLayer setHidden:YES];
}

-(void)blurCell:(id)sender{
    DLog(@"blurCell~~~~~~");
    [self blurCell];
}

-(IBAction)addOne:(id)sender{
    //使得目前选中的，或者在编辑的Cell失去焦点，保存数据
    NSIndexPath *currentSelectedIndex = [self.tableView indexPathForSelectedRow];
    if(currentSelectedIndex){
        GanUnComplateTableViewCell *currentCell = (GanUnComplateTableViewCell *)[self.tableView cellForRowAtIndexPath:currentSelectedIndex];
        //若当前选中的为第一行数据，且数据为空，则不添加新行，并返回
        if(currentSelectedIndex.row == 0 && currentCell.isEditing && [currentCell.contentEditTxt.text isEqualToString:@""]){
            return;
        }

        [self.tableView deselectRowAtIndexPath:currentSelectedIndex animated:NO];
    }
    //添加时需要先移动到第一行,否则可能产生第一行没有数据的问题(可能的原因:第一行在屏幕外，系统性能优化，未对屏幕外的Cell进行渲染)
    [self.tableView setContentOffset:CGPointZero animated:NO];

    _savedContentOffset = CGPointZero;
    DLog(@"add");
    [MobClick event:@"add"];

    [self.dataManager insertData:[[GanDataModel alloc]initWithContent:@""]];
    self.dataSource = [self.dataManager getUnCompletedData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];

    [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"cellForRowAtIndexPath %@",indexPath);
    NSString *cellName = [GanUnComplateTableViewCell reuseIdentifier];
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数
    //storyboard情况下，cell init使用的是awakeFromNib方法
    //PS:现使用纯代码方式生成cell
    GanUnComplateTableViewCell *cell = (GanUnComplateTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[GanUnComplateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    // For the delegate callback
    [cell setDelegate:self];

    // We need to provide the icon names and the desired colors
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithHEX:COMPLATE_COLOR alpha:1.0f]
            secondStateIconName:@"check.png"
                    secondColor:NULL
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithHEX:DEL_COLOR alpha:0.5f]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor colorWithHEX:DEL_COLOR alpha:1.0f]];

    // We need to set a background to the content view of the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithHEX:CELL_BG alpha:1.0f]];

    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];

    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)[self.dataSource objectAtIndex:indexPath.row]);
    //给cell的显示元素设值，防止因为元素重用，导致显示错误
    [cell setDataValToTxt];
    return cell;
}

#pragma mark - GanTableViewProtocol

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode{
    DLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);

    if (mode == MCSwipeTableViewCellModeExit) {
        GanDataModel *data = ((GanUnComplateTableViewCell *)cell).data;
        //完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            [data setIsCompelete:YES];
            self.dataSource = [self.dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataManager saveData];

            [MobClick event:@"complate"];
        }
        //删除
        else if(state == MCSwipeTableViewCellState4){
            [self.dataManager removeData:data];
            self.dataSource = [self.dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataManager saveData];

            [MobClick event:@"remove"];
        }
    }

}

-(void)deleteCell:(GanDataModel*)data{
    NSInteger index = [self.dataSource indexOfObject:data];
    DLog(@"delete %i",index);
    [self.dataManager removeData:data];
    self.dataSource = [self.dataManager getUnCompletedData];

    NSIndexPath *delIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[delIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)focusCell:(MCSwipeTableViewCell *)cell{
    _savedContentOffset = [self.tableView contentOffset];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView setContentOffset:CGPointMake(0,CELL_HEIGHT * indexPath.row) animated:YES];
    [self showMaskLayer];
}

-(void)blurCell{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self hideMaskLayer];
    [self.tableView setContentOffset:_savedContentOffset animated:YES];
    [self.dataManager saveData];
}


-(void)showPickerView{
    _pickerView.hidden = NO;
}

#pragma mark UIPickerView delegate & dataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_data[row] stringValue];
}
@end
