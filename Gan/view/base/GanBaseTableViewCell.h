//
// Created by sjpsega on 14-1-10.
// Copyright (c) 2014 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCSwipeTableViewCell.h"


@interface GanBaseTableViewCell : MCSwipeTableViewCell
@property(weak, nonatomic)GanDataModel *data;
- (void)addLine;
- (void)setDataValToTxt;
- (void)setRemindDate:(NSDate *)date;
@end