//
// Created by sjpsega on 14-1-7.
// Copyright (c) 2014 sjp. All rights reserved.
//

#import "GanBaseVC.h"
#import "GanDataManager.h"
#import "GanConstants.h"

static BOOL isAdjust = NO;

@implementation GanBaseVC {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataManager = [GanDataManager sharedInstance];
    self.view.backgroundColor = [UIColor whiteColor];

    [self genTableView];
    //创建一个导航栏
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, UI_NAVIGATION_BAR_HEIGHT)];
    self.navBar.tintColor = [UIColor Gan_ColorWithHEX:TITLE_TINY alpha:1.0f];

    [self.view addSubview:self.navBar];

    //FIXME:iOS7.1中，这样设置样式有问题
    //只调整一次，因为tabBarController是全局的
    if(!isAdjust){
        isAdjust = YES;

        CGFloat adjustDis = GAN_TABBAR_ADJUST_H;
        //调整底部TabBar高度，使得界面更美观
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.size.height -= adjustDis;
        frame.origin.y += adjustDis;
        self.tabBarController.tabBar.frame = frame;

        //重设设置内容区域高度
        UIView *transitionView = [[self.tabBarController.view subviews] firstObject];
        frame = transitionView.frame;
        frame.size.height += adjustDis;
        transitionView.frame = frame;

        //调整TabBarItem中图片的位置
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"7.1")){
            NSArray *items = self.tabBarController.tabBar.items;
            UIEdgeInsets imageInset = UIEdgeInsetsMake(5, 0, -5, 0);
            for (UITabBarItem *item in items) {
                item.imageInsets = imageInset;
            }
        }
    }
}

- (void)dealloc{
    self.tableView.delegate = nil;
}

- (void)fitForiOS7{
    if(SystemVersion_floatValue >= 7.0f){
        //iOS7 给 UITableView 新增的一个属性 separatorInset，去除
        self.tableView.separatorInset = UIEdgeInsetsZero;

        //ios7的nav默认y为0，为了不挡住statusBar，拉低y的高度，并减少tableView的高度
        CGRect frame = _navBar.frame;
        frame.size.height += UI_STATUS_BAR_HEIGHT;
        _navBar.frame = frame;

        frame = self.tableView.frame;
        frame.origin.y += UI_STATUS_BAR_HEIGHT;
        frame.size.height -= UI_STATUS_BAR_HEIGHT;
        self.tableView.frame = frame;
    }
}

- (void)didSelectThisVC{
    
}

#pragma mark implement UITableViewDataSource,UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"didSelectRowAtIndexPath %@ %@",[tableView indexPathForSelectedRow],indexPath);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GAN_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    return cell;
}

#pragma mark private
- (void)genTableView{
    CGRect viewFrame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame) - UI_NAVIGATION_BAR_HEIGHT - GAN_TABBAR_H)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
@end