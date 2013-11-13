//
//  MCSwipeTableViewCell.h
//  MCSwipeTableViewCell
//
//  Created by Ali Karagoz on 24/02/13.
//  Copyright (c) 2013 Mad Castle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GanTableViewDelegate.h"
@class MCSwipeTableViewCell;

//@protocol MCSwipeTableViewCellDelegate <NSObject>
//
//@optional
//
//// When the user starts swiping the cell this method is called
//- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell;
//
//// When the user ends swiping the cell this method is called
//- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell;
//
//// When the user is dragging, this method is called and return the dragged percentage from the border
//- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipWithPercentage:(CGFloat)percentage;
//
//// When the user releases the cell, after swiping it, this method is called
//- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode;
//
//@end

@interface MCSwipeTableViewCell : UITableViewCell

@property (nonatomic, assign) id <GanTableViewDelegate> delegate;

@property (nonatomic, copy) NSString *firstIconName;
@property (nonatomic, copy) NSString *secondIconName;
@property (nonatomic, copy) NSString *thirdIconName;
@property (nonatomic, copy) NSString *fourthIconName;

@property (nonatomic, strong) UIColor *firstColor;
@property (nonatomic, strong) UIColor *secondColor;
@property (nonatomic, strong) UIColor *thirdColor;
@property (nonatomic, strong) UIColor *fourthColor;

// Percentage of when the first and second action are activated, respectively
@property (nonatomic, assign) CGFloat firstTrigger;
@property (nonatomic, assign) CGFloat secondTrigger;

// Color for background, when any state hasn't triggered yet
@property (nonatomic, strong) UIColor *defaultColor;

// This is the general mode for all states
// If a specific mode for a state isn't defined, this mode will be taken in action
@property (nonatomic, assign) MCSwipeTableViewCellMode mode;

// Individual mode for states
@property (nonatomic, assign) MCSwipeTableViewCellMode modeForState1;
@property (nonatomic, assign) MCSwipeTableViewCellMode modeForState2;
@property (nonatomic, assign) MCSwipeTableViewCellMode modeForState3;
@property (nonatomic, assign) MCSwipeTableViewCellMode modeForState4;

@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL shouldDrag;
@property (nonatomic, assign) BOOL shouldAnimatesIcons;

//become public var add by jianping.shen 2013-11-13
@property (nonatomic, assign) MCSwipeTableViewCellDirection direction;
@property (nonatomic, assign) CGFloat currentPercentage;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
 firstStateIconName:(NSString *)firstIconName
         firstColor:(UIColor *)firstColor
secondStateIconName:(NSString *)secondIconName
        secondColor:(UIColor *)secondColor
      thirdIconName:(NSString *)thirdIconName
         thirdColor:(UIColor *)thirdColor
     fourthIconName:(NSString *)fourthIconName
        fourthColor:(UIColor *)fourthColor;

- (void)setFirstStateIconName:(NSString *)firstIconName
                   firstColor:(UIColor *)firstColor
          secondStateIconName:(NSString *)secondIconName
                  secondColor:(UIColor *)secondColor
                thirdIconName:(NSString *)thirdIconName
                   thirdColor:(UIColor *)thirdColor
               fourthIconName:(NSString *)fourthIconName
                  fourthColor:(UIColor *)fourthColor;


// Manually swipe to origin
- (void)swipeToOriginWithCompletion:(void(^)(void))completion;

//become public function add by jianping.shen 2013-11-13
- (MCSwipeTableViewCellState)stateWithPercentage:(CGFloat)percentage;

-(BOOL)shouldMove;

@end
