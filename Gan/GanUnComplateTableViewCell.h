//
//  GanTableViewCell.h
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GanDataModel.h"
#import "MCSwipeTableViewCell.h"

@interface GanUnComplateTableViewCell : MCSwipeTableViewCell
+(NSString *)getReuseIdentifier;
@property(strong,nonatomic)UITextField *contentEditTxt;
@property(nonatomic)BOOL isEditing;
@property(weak,nonatomic)GanDataModel *data;
@end
