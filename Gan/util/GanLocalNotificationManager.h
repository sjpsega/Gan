//
//  GanLocalNotificationManager.h
//  Gan
//
//  Created by sjpsega on 14-8-16.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GanLocalNotificationManager : NSObject
+ (instancetype)sharedInstance;
- (void)registeredLocalNotify:(GanDataModel *)model;
- (void)cancelLocalNotify:(GanDataModel *)model;
@end
