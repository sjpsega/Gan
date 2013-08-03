//
//  GanDownViewController.h
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GanComplateViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
