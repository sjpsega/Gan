//
//  EditorDialog.h
//  Gan
//
//  Created by sjpsega on 13-6-19.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GanDataModel.h"

@interface EditorDialog : UIAlertView
@property(strong,nonatomic) UITextField *titleTxt;
@property(strong,nonatomic) UITextField *detailTxt;
@property(strong,nonatomic) NSString *type;
@property(strong,nonatomic) GanDataModel *data;
-(id)initWithTitle:(NSString *)title showDelegate:(id)delegate type:(NSString *)type;
@end
