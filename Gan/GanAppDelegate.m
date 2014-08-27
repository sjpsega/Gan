//
//  GanAppDelegate.m
//  Gan
//
//  Created by sjpsega on 13-6-15.
//  Copyright (c) 2013年 sjp. All rights reserved.
//
/** DEBUG LOG **/

#import "GanAppDelegate.h"
#import "GanDataManager.h"
#import "MobClick.h"
#import "GanUnComplateVC.h"
#import "GanComplateVC.h"
#import "GanConstants.h"
#import "GanUnComplateTableViewCell.h"
#import "GanInit.h"

#define UMENG_APPKEY @"526b6a1d56240b395506cbd5"

@interface GanAppDelegate()<UITabBarControllerDelegate>

@end

@implementation GanAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //友盟统计分析
    [MobClick setLogEnabled:YES];
    #if !DEBUG
        [MobClick setLogEnabled:NO];
        [MobClick startWithAppkey:UMENG_APPKEY];
    #endif
    //友盟升级提醒
    [MobClick setAppVersion:APP_VERSION];
    [MobClick checkUpdate];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    GanUnComplateVC *unComplateVC = [[GanUnComplateVC alloc] init];
    GanComplateVC *complateVC = [[GanComplateVC alloc] init];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[unComplateVC, complateVC];
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    if(SystemVersion_floatValue >= 7.0){
        tabBarController.tabBar.translucent = NO;
    }
    [self.window makeKeyAndVisible];
    [GanInit init];
    return YES;
}

#pragma mark implement UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    GanBaseVC *vc = (GanBaseVC *)viewController;
    [vc didSelectThisVC];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([notification.userInfo[@"type"] isEqualToString:GAN_LOCAL_NOTIFY_TYPE]) {
        //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
        if (application.applicationState == UIApplicationStateActive) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitle", @"Alert")
                                                            message:notification.alertBody
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:notification.alertAction, nil];
            [alert show];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self setApplicationIconBadgeNumber];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setApplicationIconBadgeNumber];
}

-(void)setApplicationIconBadgeNumber{
    NSInteger unCompleteDataCount = [[[GanDataManager sharedInstance] unCompletedData] count];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unCompleteDataCount];
}

@end
