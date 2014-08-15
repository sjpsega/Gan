//
//  GanUIDatePicker.m
//  Gan
//
//  Created by sjpsega on 14-8-13.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import "GanDatePickerView.h"

static const CGFloat ToolBarH = 40.0f;
static const CGFloat DatePickerH = 200.0f;

@implementation GanDatePickerView{
    CGFloat _selfViewW;
    CGFloat _selfViewH;
    UIControl *_maskView;
    UIToolbar *_toolBar;
    UIDatePicker *_datePicker;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selfViewW = CGRectGetWidth(self.frame);
        _selfViewH = CGRectGetHeight(self.frame);
        [self addToolBar];
        [self addDatePicker];
        [self addMaskView];
    }
    return self;
}

- (void)dealloc{
    [self clear];
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self clear];
}

- (void)clear{
    [_datePicker removeFromSuperview];
    [_maskView removeTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchDown];
    [_maskView removeFromSuperview];
    [_toolBar removeFromSuperview];
}

#pragma mark - getter\setter date
- (void)setDate:(NSDate *)date{
    _datePicker.date = date;
}

- (NSDate *)date{
    return _datePicker.date;
}

#pragma mark - toolBar
- (void)addToolBar{
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, _selfViewH - ToolBarH - DatePickerH, _selfViewW, ToolBarH)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"移除" style:UIBarButtonItemStylePlain target:self action:@selector(cancelHandler)];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem : UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmHandler)];
    _toolBar.items = @[cancelBtn, spaceBtn, confirmBtn];
    [self addSubview:_toolBar];
}

- (void)cancelHandler{
    if(_cancelBlock){
        _cancelBlock();
    }
}

- (void)confirmHandler{
    if(_confirmBlock){
        _confirmBlock(_datePicker.date);
    }
}

#pragma mark - datePicker
- (void)addDatePicker{
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, _selfViewH - DatePickerH, _selfViewW, DatePickerH)];
    _datePicker.locale = [NSLocale currentLocale];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.alpha = 0.85f;
    [self addSubview:_datePicker];
}

#pragma mark - maskView
- (void)addMaskView{
    _maskView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, _selfViewW, _selfViewH - ToolBarH - DatePickerH)];
    [self addSubview:_maskView];
    [_maskView addTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchDown];
}

- (void)maskViewTap{
    [self confirmHandler];
}

@end
