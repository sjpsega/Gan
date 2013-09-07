//
//  GanTableViewCellDelegate.h
//  Gan
//
//  Created by sjpsega on 13-7-10.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global_ENUM.h"
@class MCSwipeTableViewCell;
@class GanDataModel;
@protocol GanTableViewDelegate <NSObject>
@optional
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode;
-(void)deleteCell:(GanDataModel*)data;
-(void)focusCell:(MCSwipeTableViewCell*)cell;
-(void)blurCell;
@end

