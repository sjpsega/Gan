//
//  clickView.h
//  Gan
//
//  Created by sjpsega on 13-6-20.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertViewProtocol <NSObject>
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
