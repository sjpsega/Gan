//
//  GanStringUtil.m
//  Gan
//
//  Created by sjpsega on 14-8-17.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import "GanStringUtil.h"

@implementation GanStringUtil
+ (BOOL) isBlank:(NSString *) string {
    return nil == string || 0 == string.length;
}
@end
