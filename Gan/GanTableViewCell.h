//
//  GanTableViewCell.h
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GanDataModel.h"
#import "GanViewController.h"
@interface GanTableViewCell : UITableViewCell
@property(strong,nonatomic)GanViewController *viewController;
@property(strong,nonatomic)GanDataModel *data;
@property(strong,nonatomic)UILabel *contentLabel;
@property(strong,nonatomic)UITextField *contentEditTxt;
@end
