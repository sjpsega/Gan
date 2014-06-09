//
// Created by sjpsega on 14-1-10.
// Copyright (c) 2014 sjp. All rights reserved.
//

#import "GanBaseTableViewCell.h"
#import "UIColor+HEXColor.h"


@implementation GanBaseTableViewCell {

}

-(void)prepareForReuse{
    DLog(@"GanBaseTableViewCell prepareForReuse...");
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    DLog(@"GanBaseTableViewCell initWithSytle");
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

-(void)addLine{
    const CGFloat lineH = 1;
    const CGFloat paddingL = 10;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(paddingL, CGRectGetHeight(self.frame) - lineH, CGRectGetWidth(self.frame) - paddingL, lineH)];
    line.backgroundColor = [UIColor colorWithHEX:0xcccccc alpha:.5];
    [self.contentView addSubview:line];
}

-(void)setDataValToTxt{

}

@end