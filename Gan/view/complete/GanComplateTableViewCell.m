//
//  GanComplateTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-7-21.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanComplateTableViewCell.h"
#import "UIColor+JDTHEXColor.h"
#import "Global_ENUM.h"

static const NSString *ReuseIdentifier = @"GanComplateTableViewCellIdentifier";
@class MCSwipeTableViewCell;

@implementation GanComplateTableViewCell

+(NSString *)reuseIdentifier{
    return ReuseIdentifier.copy;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addLine];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    DLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text = self.data.content;
}

-(void)setDataValToTxt{
    self.textLabel.text = self.data.content;
}

@end
