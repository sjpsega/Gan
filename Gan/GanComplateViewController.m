//
//  GanDownViewController.m
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanComplateViewController.h"
#import "GanDataModel.h"
#import "GanComplateTableViewCell.h"
#import "GanDataManager.h"
#import "DLog.h"
#import "UIColor+HEXColor.h"

@interface GanComplateViewController ()<GanTableViewCellDelegate,UIAlertViewDelegate>{
    NSMutableArray *dataSource;
    GanDataManager *dataManager;
}

@end

@implementation GanComplateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self addTashBtnEvent];
    [self setBgColor];
    dataManager = [GanDataManager getInstance];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHEX:TITLE_TINY alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    DLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super viewWillAppear:animated];
    [self initDataSource];
    [self.tableView reloadData];
}

-(void)initDataSource{
    //    dataSource = [NSMutableArray arrayWithArray:
    //                  @[
    //                  [[GanDataModel alloc]initWithContent:@"aaa"],
    //                  [[GanDataModel alloc]initWithContent:@"bbb"],
    //                  [[GanDataModel alloc]initWithContent:@"ccc"],
    //                  [[GanDataModel alloc]initWithContent:@"ddd"],
    //                  [[GanDataModel alloc]initWithContent:@"eee"],
    //                  [[GanDataModel alloc]initWithContent:@"fff"]]];
    
    
    //    [self.tableView setEditing:YES animated:YES];
    
    
    //TODO:filter已完成的数据
    dataSource = [[GanDataManager getInstance] getCompletedData];
    
    DLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%i",[dataSource count]);
}

-(void)setBgColor{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backgroundView setBackgroundColor:[UIColor colorWithHEX:TABLE_BG alpha:1.0f]];
    [self.tableView setBackgroundView:backgroundView];
}

-(void)addTashBtnEvent{
    [self.trashBtn setTarget:self];
    [self.trashBtn setAction:@selector(delAllComplate:)];
}

-(IBAction)delAllComplate:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"删除所有已完成项?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else if (buttonIndex == 1){
        //ok clicked
        for (GanDataModel *data in dataSource) {
            [dataManager removeData:data];
        }
        dataSource = [dataManager getCompletedData];
        [dataManager saveData];
        [self.tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"cellForRowAtIndexPath %@",tableView.indexPathForSelectedRow);
    NSString *cellName = [GanComplateTableViewCell getReuseIdentifier];
    //这里使用dequeueReusableCellWithIdentifier:cellName，发现使用自定义的cell，没有调用init函数
    //storyboard情况下，cell init使用的是awakeFromNib方法
    GanComplateTableViewCell *cell = (GanComplateTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[GanComplateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    // For the delegate callback
    [cell setDelegate:self];
    
    // We need to provide the icon names and the desired colors
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithHEX:UNCOMPLATE_COLOR alpha:1.0]
            secondStateIconName:@"check.png"
                    secondColor:[UIColor colorWithHEX:UNCOMPLATE_COLOR alpha:1.0]
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithHEX:DEL_COLOR alpha:0.5]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor colorWithHEX:DEL_COLOR alpha:1.0]];
    
    // We need to set a background to the content view of the cell
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]];
    
    // Setting the type of the cell
    [cell setMode:MCSwipeTableViewCellModeExit];
    cell.data = ((GanDataModel *)[dataSource objectAtIndex:indexPath.row]);
    return cell;
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
    DLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        GanDataModel *data = ((GanComplateTableViewCell *)cell).data;
        //变成未完成
        if(state == MCSwipeTableViewCellState1 || state == MCSwipeTableViewCellState2){
            [data setIsCompelete:NO];
            dataSource = [dataManager getCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
        }
        //删除
        else if(state == MCSwipeTableViewCellState3 || state == MCSwipeTableViewCellState4){
            [dataManager removeData:data];
            dataSource = [dataManager getCompletedData];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            [dataManager saveData];
        }
    }
}

@end
