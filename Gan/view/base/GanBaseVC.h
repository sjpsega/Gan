//
// Created by sjpsega on 14-1-7.
// Copyright (c) 2014 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CELL_HEIGHT 44
@class GanDataManager;

@interface GanBaseVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)GanDataManager *dataManager;
@property (strong, nonatomic)UINavigationBar *navBar;
-(void)fitForiOS7;
@end