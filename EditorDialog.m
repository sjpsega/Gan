//
//  EditorDialog.m
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "EditorDialog.h"

@interface EditorDialog (){
    id<AlertViewProtocol> showDelegate;
}

@end

@implementation EditorDialog

-(id)initWithTitle:(NSString *)title showDelegate:(id)delegate type:(NSString *)type{
    self = [self initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.type = type;
    showDelegate = delegate;
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

//-(void)show{
//    [super show];
//    //调整原有Button的位置
//    CGRect detailFrame = self.detailTxt.frame;
//    for (UIView* view in self.subviews){
//        if([view isKindOfClass:[UIButton class]] || [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]){
//            CGRect btnBounds = view.frame;
//            btnBounds.origin.y = detailFrame.origin.y + detailFrame.size.height + 7;
//            view.frame = btnBounds;
//        }
//    }
//
//    //调整大小
//    CGRect frame = self.frame;
//    frame.size.height = frame.size.height + detailFrame.size.height + self.titleTxt.frame.size.height + 7;
//    self.frame = frame;
//
//    //弹出框动画后居中
////    self.center = CGPointMake(160, 200);
//}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    //调整原有Button的位置
    CGRect detailFrame = self.detailTxt.frame;
    for (UIView* view in self.subviews){
        if([view isKindOfClass:[UIButton class]] || [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]){
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = detailFrame.origin.y + detailFrame.size.height + 7;
            view.frame = btnBounds;
        }
    }
    
    //调整大小
    CGRect frame = self.frame;
    frame.size.height = frame.size.height + detailFrame.size.height + self.titleTxt.frame.size.height + 7;
    self.frame = frame;
    
    
    //弹出框动画后居中
    self.center = CGPointMake(160, 200);
    
    if(_data){
        self.titleTxt.text = _data.title;
        self.detailTxt.text = _data.detail;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(showDelegate && [showDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [showDelegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
}

-(UITextField *)createTextField:(NSString *)placeholder withFrame:(CGRect)frame{
    UITextField *txt = [[UITextField alloc]initWithFrame:frame];
    txt.placeholder = placeholder;
    txt.backgroundColor = [UIColor whiteColor];
    txt.borderStyle = UITextBorderStyleRoundedRect;
    txt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return txt;
}

@end
