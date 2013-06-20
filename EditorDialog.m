//
//  EditorDialog.m
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "EditorDialog.h"

@implementation EditorDialog

-(id)initWithTitle:(NSString *)title{
    self = [self initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    return self;
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if(self != nil){
        self.titleTxt = [self createTextField:@"标题" withFrame:CGRectMake(20, 45, 240, 36)];
        [self addSubview:self.titleTxt];
        
        self.detailTxt = [self createTextField:@"详情" withFrame:CGRectMake(20, 45 + 36+7, 240, 90)];
        [self addSubview:self.detailTxt];
    }
    return self;
}

-(void)show{
    [super show];
}

-(void)layoutSubviews{
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    CGRect detailFrame = self.detailTxt.frame;
    for (UIView* view in self.subviews){
        if([view isKindOfClass:[UIButton class]] || [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]){
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = detailFrame.origin.y + detailFrame.size.height+7;
            view.frame = btnBounds;
        }
    }
    CGRect bounds = self.frame;
    bounds.size.height = bounds.size.height + detailFrame.size.height+ self.titleTxt.frame.size.height +7;
    self.frame = bounds;
}


-(UITextField *)createTextField:(NSString *)placeholder withFrame:(CGRect)frame{
    UITextField *txt = [[UITextField alloc]initWithFrame:frame];
    txt.placeholder = placeholder;
    txt.backgroundColor = [UIColor whiteColor];
    txt.borderStyle = UITextBorderStyleRoundedRect;
    txt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return txt;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
