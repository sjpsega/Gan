//
//  GanViewController.h
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewProtocol.h"
#import "GanDataModel.h"
@interface GanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AlertViewProtocol>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(void)cellDataEditHandler:(GanDataModel *)data;
@end
