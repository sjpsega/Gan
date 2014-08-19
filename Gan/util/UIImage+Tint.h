//
//  UIImage+Tint.h
//  Gan
//
//  Created by sjpsega on 14-8-19.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
@end
