//
//  GanInit.m
//  Gan
//
//  Created by sjpsega on 14-8-17.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import "GanInit.h"
#import "GanLocalNotificationManager.h"
@implementation GanInit
+ (void)init{
    //重新添加本地提醒
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSArray *unCompleteDatas = [[GanDataManager sharedInstance] unCompletedData];
    [unCompleteDatas enumerateObjectsUsingBlock:^(GanDataModel *model, NSUInteger idx, BOOL *stop) {
        [[GanLocalNotificationManager sharedInstance]registeredLocalNotify:model];
    }];
}
@end
