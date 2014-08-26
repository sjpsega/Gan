//
//  GanDateUtil.m
//  Gan
//
//  Created by sjpsega on 14-8-23.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import "GanDateUtil.h"

@implementation GanDateUtil
+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return NSLocalizedString(@"today", @"today");
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return NSLocalizedString(@"yesterday", @"yesterday");
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return NSLocalizedString(@"tomorrow", @"tomorrow");
    }
    else
    {
        return nil;
    }
}
@end
