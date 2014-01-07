//
// Created by sjpsega on 14-1-7.
// Copyright (c) 2014 sjp. All rights reserved.
//

#import "GanBaseVC.h"
#import "GanDataManager.h"
#import "Global_ENUM.h"
#import "DLog.h"

@implementation GanBaseVC {

}

-(void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [GanDataManager getInstance];
    [self genTableView];
}

-(void)fitForiOS7{
    if(SystemVersion_floatValue>=7.0f){
        //iOS7 给 UITableView 新增的一个属性 separatorInset，去除
        self.tableView.separatorInset = UIEdgeInsetsZero;

        CGFloat statusHeight = 20.0f;

        //ios7的nav默认y为0，为了不挡住statusBar，拉低y的高度，并减少tableView的高度
        CGRect frame = _navBar.frame;
        frame.size.height += statusHeight;
        _navBar.frame = frame;

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

#pragma mark implement UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"didSelectRowAtIndexPath %@ %@",[tableView indexPathForSelectedRow],indexPath);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

#pragma mark private
-(void)genTableView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
@end