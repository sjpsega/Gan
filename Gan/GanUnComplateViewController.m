//
//  GanViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanUnComplateViewController.h"
#import "GanDataModel.h"
#import "GanUnComplateTableViewCell.h"
#import "GanTableViewDelegate.h"
#import "GanDataManager.h"
#import "DLog.h"
#import "UIColor+HEXColor.h"
#import "MobClick.h"

static const CGFloat CELL_HEIGHT=44.0f;

@interface GanUnComplateViewController ()<GanTableViewDelegate>{
    NSMutableArray *dataSource;
    UIButton *maskLayer;
    CGPoint savedContentOffset;
    GanDataManager *dataManager;
    UINavigationBar *navBar;
}

@end

@implementation GanUnComplateViewController

- (void)viewDidLoad
{
    DLog(@"GanUnComplateViewController viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setBgColor];
    
    dataManager = [GanDataManager getInstance];
    
    //创建一个导航栏
    navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    navBar.tintColor = [UIColor colorWithHEX:TITLE_TINY alpha:1.0f];
    
    //创建一个导航栏集合
    UINavigationItem *navBarItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"todoTitle", @"")];

    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                   target:self
                                                                   action:@selector(addOne:)];
    [navBarItem setRightBarButtonItem:rightButton];
    
    [navBar pushNavigationItem:navBarItem animated:NO];
    [self.view addSubview:navBar];
    
    CGFloat adjustDis = 14.0;
    //调整底部TabBar高度
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.size.height -= adjustDis;
    frame.origin.y += adjustDis;
    self.tabBarController.tabBar.frame = frame;
    
    //重设设置内容区域高度
    UIView *transitionView = [[self.tabBarController.view subviews] objectAtIndex:0];
    frame = transitionView.frame;
    frame.size.height += adjustDis;
    transitionView.frame = frame;
    
    //调整TabBarItem中图片的位置
    NSArray *items = self.tabBarController.tabBar.items;
    UIEdgeInsets imageInset = UIEdgeInsetsMake(5, 0, -5, 0);
    for (UITabBarItem *item in items) {
        item.imageInsets = imageInset;
    }

    [self fitForiOS7];
    [self addMaskLayer];
    
}

-(void)fitForiOS7{
    if(SystemVersion_floatValue>=7.0f){
        //iOS7 给 UITableView 新增的一个属性 separatorInset，去除
        self.tableView.separatorInset = UIEdgeInsetsZero;

        CGFloat statusHeight = 20.0f;
        
        //ios7的nav默认y为0，为了不挡住statusBar，拉低y的高度，并减少tableView的高度
        CGRect frame = navBar.frame;
        frame.size.height += statusHeight;
        navBar.frame = frame;

        frame = self.tableView.frame;
        frame.origin.y+=statusHeight;
        frame.size.height-=statusHeight;
        self.tableView.frame = frame;
        
        //底部的tabBar也会遮挡tableView，减少对应高度
        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
        frame = self.tableView.frame;
        frame.size.height -= tabBarFrame.size.height;
        self.tableView.frame = frame;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataSource];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    DLog(@"GanUnComplateViewController didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self isViewLoaded] && self.view.window == nil){
        DLog(@"GanUnComplateViewController unload view");
        self.view = nil;
    }
    self.tableView = nil;
    maskLayer = nil;
    dataSource = nil;
    dataManager = nil;
}

- (void)viewDidUnload {
    DLog(@"GanUnComplateViewController viewDidUnload");
    self.tableView = nil;
    [super viewDidUnload];
}

-(void)initDataSource{
    dataSource = [dataManager getUnCompletedData];
    DLog(@"dataSouce unComplate count:%i",[dataSource count]);
}

-(void)setBgColor{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithHEX:TABLE_BG alpha:1.0f]];
    [self.tableView setBackgroundView:backgroundView];
}

-(void)addMaskLayer{
    maskLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = self.tableView.frame;
    frame.origin.y +=CELL_HEIGHT;
    [maskLayer setFrame:frame];
    [maskLayer setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [self.view insertSubview:maskLayer aboveSubview:self.tableView];
    [maskLayer addTarget:self action:@selector(blurCell:) forControlEvents:UIControlEventTouchUpInside];
    [self hideMaskLayer];
}

-(void)showMaskLayer{
    [maskLayer setHidden:NO];
}

-(void)hideMaskLayer{
    [maskLayer setHidden:YES];
}

-(IBAction)blurCell:(id)sender{
    DLog(@"blurCell~~~~~~");
    [self blurCell];
}

-(IBAction)addOne:(id)sender{
    //使得目前选中的，或者在编辑的Cell失去焦点，保存数据
    NSIndexPath *currentSelectedIndex = [self.tableView indexPathForSelectedRow];
    if(currentSelectedIndex){
        [self.tableView deselectRowAtIndexPath:currentSelectedIndex animated:NO];
    }
    //添加时需要先移动到第一行,否则可能产生第一行没有数据的问题(可能的原因:第一行在屏幕外，系统性能优化，未对屏幕外的Cell进行渲染)
    [self.tableView setContentOffset:CGPointZero animated:NO];
    //若第一行数据内容为空，则不添加新行
    NSIndexPath *firstIdx = [NSIndexPath indexPathForRow:0 inSection:0];
    GanUnComplateTableViewCell *firstCell = (GanUnComplateTableViewCell *)([self.tableView cellForRowAtIndexPath:firstIdx]);
    if(firstCell.isEditing && [firstCell.contentEditTxt.text isEqual:@""]){
        return;
    }
    
    savedContentOffset = CGPointZero;
    DLog(@"add");
    [MobClick event:@"add"];
    
    [dataManager insertData:[[GanDataModel alloc]initWithContent:@""]];
    dataSource = [dataManager getUnCompletedData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"didSelectRowAtIndexPath %@ %@",[tableView indexPathForSelectedRow],indexPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"cellForRowAtIndexPath %@",indexPath);
    NSString *cellName = [GanUnComplateTableViewCell getReuseIdentifier];
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
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    //给cell的显示元素设值，防止因为元素重用，导致显示错误
    [cell setDataValToTxt];
    return cell;
}

#pragma mark - GanTableViewDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode{
    DLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        GanDataModel *data = ((GanUnComplateTableViewCell *)cell).data;
        //完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            [data setIsCompelete:YES];
            dataSource = [dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
            
            [MobClick event:@"complate"];
        }
        //删除
        else if(state == MCSwipeTableViewCellState4){
            [dataManager removeData:data];
            dataSource = [dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
            
            [MobClick event:@"remove"];
        }
    }

}

-(void)deleteCell:(GanDataModel*)data{
    NSInteger index = [dataSource indexOfObject:data];
    DLog(@"delete %i",index);
    [dataManager removeData:data];
    dataSource = [dataManager getUnCompletedData];
    
    NSIndexPath *delIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[delIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)focusCell:(MCSwipeTableViewCell *)cell{
    savedContentOffset = [self.tableView contentOffset];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView setContentOffset:CGPointMake(0,CELL_HEIGHT * indexPath.row) animated:YES];
    [self showMaskLayer];
}

-(void)blurCell{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self hideMaskLayer];
    [self.tableView setContentOffset:savedContentOffset animated:YES];
    [dataManager saveData];
}
@end
