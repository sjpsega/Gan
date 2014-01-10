//
// Created by sjpsega on 14-1-7.
// Copyright (c) 2014 sjp. All rights reserved.
//

#import "GanBaseVC.h"
#import "GanDataManager.h"
#import "Global_ENUM.h"
#import "DLog.h"
#import "UIColor+HEXColor.h"

static BOOL isAdjust = NO;

@implementation GanBaseVC {

}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){

    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [GanDataManager getInstance];
    self.view.backgroundColor = [UIColor whiteColor];

    [self genTableView];
    //创建一个导航栏
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.navBar.tintColor = [UIColor colorWithHEX:TITLE_TINY alpha:1.0f];

    [self.view addSubview:self.navBar];

    //只调整一次，因为tabBarController是全局的
    if(!isAdjust){
        isAdjust = YES;

        CGFloat adjustDis = 14.0;
        //调整底部TabBar高度，使得界面更美观
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
    }
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
    //TODO:-44?
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect)-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
@end