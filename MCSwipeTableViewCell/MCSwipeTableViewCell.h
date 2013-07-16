//
//  MCSwipeTableViewCell.h
//  MCSwipeTableViewCell
//
//  Created by Ali Karagoz on 24/02/13.
//  Copyright (c) 2013 Mad Castle. All rights reserved.
//

#import "GanTableViewCellDelegate.h"
#import "Global_ENUM.h"
@class MCSwipeTableViewCell;

@interface MCSwipeTableViewCell : UITableViewCell

@property(nonatomic, assign) id <GanTableViewCellDelegate> delegate;

@property(nonatomic, copy) NSString *firstIconName;
@property(nonatomic, copy) NSString *secondIconName;
@property(nonatomic, copy) NSString *thirdIconName;
@property(nonatomic, copy) NSString *fourthIconName;

@property(nonatomic, strong) UIColor *firstColor;
@property(nonatomic, strong) UIColor *secondColor;
@property(nonatomic, strong) UIColor *thirdColor;
@property(nonatomic, strong) UIColor *fourthColor;

@property(nonatomic, assign) MCSwipeTableViewCellMode mode;
@property(nonatomic, assign) BOOL isDragging;
@property(nonatomic, assign) BOOL shouldDrag;

@property(nonatomic, assign) MCSwipeTableViewCellDirection direction;
@property(nonatomic, assign) CGFloat currentPercentage;

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
- (void)bounceToOrigin;

-(BOOL)shouldMove;

- (MCSwipeTableViewCellState)stateWithPercentage:(CGFloat)percentage;
@end
