//
//  AppDelegate.m
//  TestIos
//
//  Created by Liyadong on 2019/4/2.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "TYCustomNavigationViewController.h"
#import "AFNetworking.h"
 
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
 
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *rootVC = [[RootViewController alloc] init];
 
    TYCustomNavigationViewController *nav = [[TYCustomNavigationViewController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark — 开始网络状态的监听
- (void)initNetWorkManager {
    DLog(@"开始进行网络状态的监听");
    self.haveNetwork = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                DLog(@"当前网络 = 未知网络");
                self.haveNetwork = YES;
                break;
                case AFNetworkReachabilityStatusNotReachable:
                DLog(@"当前网络 = 没有网络");
                self.haveNetwork = NO;
                break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"当前网络 = 手机自带网络");
                self.haveNetwork = YES;
                break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"当前网络 = WIFI");
                self.haveNetwork = YES;
                break;
        }
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@(status),@"netState", nil];
        NSNotification *notification = [NSNotification notificationWithName:netWorkChangeNotify object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }];
    [manager startMonitoring];
    
    
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
