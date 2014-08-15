//
//  GanUIDatePicker.h
//  Gan
//
//  Created by sjpsega on 14-8-13.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DatePickerConfirmBlock)(NSDate *date);
typedef void (^DatePickerCancelBlock)();

@interface GanDatePickerView : UIView
@property (strong, nonatomic)NSDate *date;
@property (copy ,nonatomic) DatePickerConfirmBlock confirmBlock;
@property (copy ,nonatomic) DatePickerConfirmBlock changeBlock;
@property (copy ,nonatomic) DatePickerCancelBlock cancelBlock;
@end
