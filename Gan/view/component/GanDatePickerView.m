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

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    [_datePicker sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)dealloc{
    [self clear];
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self clear];
}

- (void)clear{
    [_datePicker removeTarget:self action:@selector(pickerDidChange:) forControlEvents:UIControlEventValueChanged];
    [_datePicker removeFromSuperview];
    [_maskView removeTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchDown];
    [_maskView removeFromSuperview];
    [_toolBar removeFromSuperview];
}

#pragma mark - getter\setter date
- (void)setDate:(NSDate *)date{
    if(date){
        _datePicker.date = date;
    }
}

- (NSDate *)date{
    return _datePicker.date;
}

#pragma mark - toolBar
- (void)addToolBar{
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, _selfViewH - ToolBarH - DatePickerH, _selfViewW, ToolBarH)];
    UIBarButtonItem *removeBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"removeLabel", @"Remove") style:UIBarButtonItemStylePlain target:self action:@selector(removeHandler)];
    UIBarButtonItem * spaceBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem : UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, ToolBarH)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = NSLocalizedString(@"remind", @"Remind");
    UIBarButtonItem *remindLbl = [[UIBarButtonItem alloc] initWithCustomView:lbl];
    UIBarButtonItem * spaceBtn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem : UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"confirmLabel", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(confirmHandler)];
    _toolBar.items = @[removeBtn, spaceBtn1, remindLbl, spaceBtn2, confirmBtn];
    [self addSubview:_toolBar];
}

- (void)removeHandler{
    if(_removeBlock){
        _removeBlock();
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
    [_datePicker addTarget:self
                    action:@selector(pickerDidChange:)
          forControlEvents:UIControlEventValueChanged];
}

- (void)pickerDidChange:(UIControlEvents *)event{
    if(_changeBlock){
        _changeBlock(_datePicker.date);
    }
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
