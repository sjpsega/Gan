//
//  GanTableViewCell.m
//  Gan
//
//  Created by sjpsega on 13-6-16.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "GanTableViewCell.h"
#import "GanViewController.h"
@implementation GanTableViewCell

-(void)prepareForReuse{
    NSLog(@"prepareForReuse...");
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"initWithSytle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self addDoubleClickEvnet];
        self.textLabel.hidden = YES;
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.frame = CGRectMake(0,0, 100, 44);
        self.contentLabel.shadowColor = [[UIColor alloc]initWithRed:0xcc/255.f green:0xcc/255.f blue:0xcc/255.f alpha:1];
        self.contentLabel.shadowOffset = CGSizeMake(2, 1);
        [self.contentView addSubview:self.contentLabel];
        
        self.contentEditTxt = [[UITextField alloc]init];
        self.contentEditTxt.frame = CGRectMake(0,0, 100, 44);
        [self.contentView addSubview:self.contentEditTxt];
        
        //        self.detailLabel = [[UILabel alloc]init];
        //        self.detailLabel.frame = CGRectMake(0,44, 100, 44);
        //        self.detailLabel.textColor = [[UIColor alloc]initWithRed:0x33/255.f green:0x33/255.f blue:0x33/255.f alpha:1];
        //        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

-(void)addDoubleClickEvnet{
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editHandler:)];
    doubleClick.numberOfTapsRequired = 2;
    doubleClick.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleClick];
}

-(void)editHandler:(UIGestureRecognizer *)recognizer{
    NSLog(@"doubleLick");
//    [self.viewController cellDataEditHandler:_data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    NSLog(@"setSelected %i",selected);
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    //    self.detailLabel.hidden = YES;
    //    if(selected == YES){
    //        self.detailLabel.hidden = NO;
    //    }
    
    self.contentEditTxt.hidden = YES;
    self.contentLabel.hidden = NO;
    if(selected == YES){
        self.contentEditTxt.text = self.contentLabel.text;
        self.contentEditTxt.hidden = NO;
        self.contentLabel.hidden = YES;
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    NSLog(@"willMoveToSuperview");
    [super willMoveToSuperview:newSuperview];
    self.contentLabel.text = _data.title;
    //    self.detailLabel.text = _data.detail;
}

@end
