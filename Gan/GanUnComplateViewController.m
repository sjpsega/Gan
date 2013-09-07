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
static const CGFloat CELL_HEIGHT=44.0f;

@interface GanUnComplateViewController ()<GanTableViewDelegate>{
    NSMutableArray *dataSource;
    UIButton *maskLayer;
    CGPoint savedContentOffset;
    GanDataManager *dataManager;
}

@end

@implementation GanUnComplateViewController

- (void)viewDidLoad
{
    DLog(@"GanUnComplateViewController viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self addAddBtnEvent];
    [self addMaskLayer];
    [self setBgColor];
    dataManager = [GanDataManager getInstance];
    
    //创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    navBar.tintColor = [UIColor colorWithHEX:TITLE_TINY alpha:1.0f];
    
    //创建一个导航栏集合
    UINavigationItem *navBarItem = [[UINavigationItem alloc] initWithTitle:@"想要做"];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                   target:self
                                                                   action:@selector(addOne:)];
    [navBarItem setRightBarButtonItem:rightButton];
    
    [navBar pushNavigationItem:navBarItem animated:NO];
    [self.view addSubview:navBar];
    
    //调整底部TabBar高度
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.size.height-=14;
    self.tabBarController.tabBar.frame = frame;
    
    //调整TabBarItem中图片的位置
    NSArray *items = self.tabBarController.tabBar.items;
    UIEdgeInsets imageInset = UIEdgeInsetsMake(5, 0, -5, 0);
    for (UITabBarItem *item in items) {
        item.imageInsets = imageInset;
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
    self.addBtn = nil;
    maskLayer = nil;
    dataSource = nil;
    dataManager = nil;
}

- (void)viewDidUnload {
    DLog(@"GanUnComplateViewController viewDidUnload");
    self.tableView = nil;
    self.addBtn = nil;
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

-(void)addAddBtnEvent{
    [self.addBtn setTarget:self];
    [self.addBtn setAction:@selector(addOne:)];
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
    savedContentOffset = CGPointZero;
    DLog(@"add");
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
    DLog(@"cellForRowAtIndexPath %@",tableView.indexPathForSelectedRow);
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
    
    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    return cell;
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
    DLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        GanDataModel *data = ((GanUnComplateTableViewCell *)cell).data;
        //完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            [data setIsCompelete:YES];
            dataSource = [dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
        }
        //删除
        else if(state == MCSwipeTableViewCellState4){
            [dataManager removeData:data];
            dataSource = [dataManager getUnCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
        }
    }
}

-(void)deleteCell:(GanDataModel*)data{
    NSInteger index = [dataSource indexOfObject:data];
    DLog(@"delete %i",index);
    [dataManager removeData:data];
    dataSource = [dataManager getUnCompletedData];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
