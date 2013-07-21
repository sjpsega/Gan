//
//  GanComplateTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-7-21.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanComplateTableViewCell.h"

static const NSString *ReuseIdentifier = @"GanComplateTableViewCellIdentifier";
@class MCSwipeTableViewCell;

@implementation GanComplateTableViewCell

+(NSString *)getReuseIdentifier{
    return ReuseIdentifier.copy;
}

-(void)prepareForReuse{
    NSLog(@"GanTableViewCell prepareForReuse...");
}


-(NSString *)reuseIdentifier{
    //    NSLog(@"reuseIdentifier...");
    return ReuseIdentifier.copy;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"GanTableViewCell initWithSytle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self clearColorWithElement];
        //        UIView *bgColorView = [[UIView alloc] initWithFrame:self.bounds];
        //        bgColorView.backgroundColor = [UIColor colorWithRed:0xf6 * 1.1 /255.f green:0xf6* 1.1 /255.f blue:0x34* 1.1 /255.f alpha:1.0];
        
        //        [self setSelectedBackgroundView:bgColorView];
    }
    return self;
}

-(void)viewDidLoad{
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~");
//    self.textLabel.text = self.data.content;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    NSLog(@"willMoveToSuperview~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    [super willMoveToSuperview:newSuperview];
    self.textLabel.text =_data.content;
}

@end
