//
//  GanLocalNotificationManager.m
//  Gan
//
//  Created by sjpsega on 14-8-16.
//  Copyright (c) 2014年 sjp. All rights reserved.
//

#import "GanLocalNotificationManager.h"
#import "GanDataModel.h"

@implementation GanLocalNotificationManager
+ (instancetype)sharedInstance{
    static GanLocalNotificationManager *sharedInstance;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[GanLocalNotificationManager alloc]init];
    });
    return sharedInstance;
}

- (void)registeredLocalNotify:(GanDataModel *)model{
    DLog(@"%@,%@,%d",model.remindDate,[NSDate date],[model.remindDate compare:[NSDate date]]);
    if(!model.remindDate || [model.remindDate compare:[NSDate date]] == NSOrderedAscending || model.isComplete){
        [self cancelLocalNotify:model];
        return;
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //设置本地通知的触发时间
    localNotification.fireDate = model.remindDate;
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone localTimeZone];
    //设置通知的内容
    localNotification.alertBody = model.content;
    //设置通知动作按钮的标题
    localNotification.alertAction = NSLocalizedString(@"localNotificationAlertAction", @"I know");
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    NSDictionary *infoDic = @{
                              @"type" : GAN_LOCAL_NOTIFY_TYPE,
                              @"id" : model.uuid
                             };
    localNotification.userInfo = infoDic;
    //在规定的日期触发通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //立即触发一个通知
    //    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
}

- (void)cancelLocalNotify:(GanDataModel *)model{
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    for (UILocalNotification *notify in notificaitons) {
        if ([notify.userInfo[@"id"] isEqualToString:model.uuid]) {
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            break;
        }
    }
    
}
@end
