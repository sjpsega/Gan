//
//  GanDownViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanComplateVC.h"
#import "GanDataModel.h"
#import "GanComplateTableViewCell.h"
#import "GanDataManager.h"
#import "MobClick.h"

@interface GanComplateVC ()<GanTableViewProtocol,UIAlertViewDelegate>{
}

@end

@implementation GanComplateVC

-(id)init {
    self = [super init];
    if(self){
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"check.png"] tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setBgColor];

    //创建一个导航栏集合
    UINavigationItem *navBarItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"doneTitle", @"Done")];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                 target:self
                                                                                 action:@selector(delAllComplate:)];
    [navBarItem setRightBarButtonItem:rightButton];
    
    [self.navBar pushNavigationItem:navBarItem animated:NO];
    
    [self fitForiOS7];
}

- (void)didReceiveMemoryWarning
{
    DLog(@"GanComplateVC didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self isViewLoaded] && self.view.window == nil){
        DLog(@"GanComplateVC unload view");
        self.view = nil;
    }
    self.tableView = nil;
    self.dataSource = nil;
    self.dataManager = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    DLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super viewWillAppear:animated];
    [self initDataSource];
    [self.tableView reloadData];
    
    [self resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(void)initDataSource{
    self.dataSource = [[GanDataManager sharedInstance] completedData];
}

-(void)setBgColor{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor Gan_ColorWithHEX:TABLE_BG alpha:1.0f]];
    [self.tableView setBackgroundView:backgroundView];
}

-(void)delAllComplate:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alertTitle", @"Alert")
                    message:NSLocalizedString(@"delAllComplateAlertMessage", @"Do you want to delete all completed tasks?")
                    delegate:self
                    cancelButtonTitle:NSLocalizedString(@"delAllComplateAlertCancelBtn", @"Cancel")
                    otherButtonTitles:NSLocalizedString(@"delAllComplateAlertOkBtn", @"OK"), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else if (buttonIndex == 1){
        //ok clicked
        for (GanDataModel *data in self.dataSource) {
            [self.dataManager removeData:data];
        }
        self.dataSource = [self.dataManager completedData];
        [self.dataManager saveData];
        [self.tableView reloadData];
        
        [MobClick event:@"removeAll"];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"cellForRowAtIndexPath %@",indexPath);
    NSString *cellName = [GanComplateTableViewCell reuseIdentifier];
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数
    //storyboard情况下，cell init使用的是awakeFromNib方法
    //PS:现使用纯代码方式生成cell
    GanComplateTableViewCell *cell = (GanComplateTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[GanComplateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    // For the delegate callback
    [cell setDelegate:self];
    
    // We need to provide the icon names and the desired colors
    [cell setFirstStateIconName:@"clock.png"
                     firstColor:[UIColor Gan_ColorWithHEX:UNCOMPLATE_COLOR alpha:1.0]
            secondStateIconName:@"clock.png"
                    secondColor:[UIColor Gan_ColorWithHEX:UNCOMPLATE_COLOR alpha:1.0]
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor Gan_ColorWithHEX:DEL_COLOR alpha:1.0]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor Gan_ColorWithHEX:DEL_COLOR alpha:1.0]];
    
    // We need to set a background to the content view of the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)self.dataSource[indexPath.row]);
    //给cell的显示元素设值，防止因为元素重用，导致显示错误
    [cell setDataValToTxt];
    return cell;
}

#pragma mark - GanTableViewProtocol

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %lu - MCSwipeTableViewCellMode : %lu", indexPath, state, mode);
    if(!indexPath){
        DLog(@"error!!!");
        return;
    }
    GanComplateTableViewCell *currentCell = ((GanComplateTableViewCell *)cell);
    if (mode == MCSwipeTableViewCellModeExit) {
        GanDataModel *data = currentCell.data;
        //变成未完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            data.isComplete = NO;
            self.dataSource = [self.dataManager completedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataManager saveData];
            
            [MobClick event:@"restore"];
        }
        //删除
        else if(state == MCSwipeTableViewCellState3 || state == MCSwipeTableViewCellState4){
            [[GanLocalNotificationManager sharedInstance] cancelLocalNotify:data];
            [self.dataManager removeData:data];
            self.dataSource = [self.dataManager completedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataManager saveData];
            
            [MobClick event:@"remove"];
        }
        [currentCell clear];
    }
}

#pragma mark - 摇一摇删除功能
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //检测到摇动
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self delAllComplate:self];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
@end
