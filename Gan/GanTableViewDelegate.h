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
// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell;

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell;

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipWithPercentage:(CGFloat)percentage;

// When the user releases the cell, after swiping it, this method is called
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode;

-(void)deleteCell:(GanDataModel*)data;
-(void)focusCell:(MCSwipeTableViewCell*)cell;
-(void)blurCell;
@end

