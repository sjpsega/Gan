//
//  GanComplateTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-7-21.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanComplateTableViewCell.h"
#import "DLog.h"
#import "UIColor+HEXColor.h"
#import "Global_ENUM.h"

static const NSString *ReuseIdentifier = @"GanComplateTableViewCellIdentifier";
@class MCSwipeTableViewCell;

@implementation GanComplateTableViewCell

+(NSString *)getReuseIdentifier{
    return ReuseIdentifier.copy;
}

-(void)prepareForReuse{
    DLog(@"GanTableViewCell prepareForReuse...");
}


-(NSString *)reuseIdentifier{
    return ReuseIdentifier.copy;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    DLog(@"GanTableViewCell initWithSytle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgColorView = [[UIView alloc] initWithFrame:self.bounds];
        bgColorView.backgroundColor = [UIColor colorWithHEX:CELL_EDIT_BG alpha:1.0f];
        [self setSelectedBackgroundView:bgColorView];
        
        self.textLabel.font = [UIFont fontWithName:@"Arial" size:18.0];
        self.textLabel.highlightedTextColor = [UIColor blackColor];
    }
    return self;
}

-(void)viewDidLoad{
    DLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~");
//    self.textLabel.text = self.data.content;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    DLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text = _data.content;
}

-(void)setDataValToTxt{
    self.textLabel.text = self.data.content;
}

@end
