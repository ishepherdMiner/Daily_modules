//
//  AppDelegate.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "JANoticeServiceKit.h"
#import "UIImage+JACoder.h"
#import <CoreMotion/CoreMotion.h>
#import "UIDevice+JACoder.h"
#import "NSDate+JACoder.h"

@interface AppDelegate ()
@property (nonatomic,strong) JANoticeService *service;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    JANoticeServiceNative *native = [[JANoticeServiceNative alloc] init];
    JANoticeServiceJPush *jpush = [[JANoticeServiceJPush alloc] init];
    UIImage *image = [UIImage imageNamed:@"invited_3_02"];
    UIImage *img2 = [image imageWithCorner:image.size.width * 0.5];
    if ([NSDate isDiffDay]) {
        NSLog(@"test");
    }
    // 默认选择注册sound,badge,alert
    [JANoticeService registerNoticeServiceWithDelegate:native];
    
    // 选择注册服务
    //  [JANoticeService registerNoticeServiceWithTypes:JANoticeServiceTypeAll
    //                                         delegate:native];
    NSLog(@"%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSBundle mainBundle].bundlePath error:nil]);
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 去头尾<>,去空格
    NSString *deviceTokenString = [JANoticeService deviceToken:deviceToken];
    // 注册deviceToken
    // 发送给服务器
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
