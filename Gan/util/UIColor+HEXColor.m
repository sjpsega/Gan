//
//  UIColor+HEXColor.m
//  Gan
//
//  Created by sjpsega on 13-7-27.
//  Copyright (c) 2013年 sjp. All rights reserved.
//

#import "UIColor+HEXColor.h"

@implementation UIColor (HEXColor)
+(id)colorWithHEX:(int)rgbValue alpha:(float)alphaVal{
    return [UIColor
            colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
            green:((float)((rgbValue & 0xFF00) >> 8))/255.0
            blue:((float)(rgbValue & 0xFF))/255.0
            alpha:alphaVal];
}
@end