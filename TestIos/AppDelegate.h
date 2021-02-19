//
//  AppDelegate.h
//  TestIos
//
//  Created by Liyadong on 2019/4/2.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 记录当前APP是否存在网络 */
@property (nonatomic, assign) BOOL haveNetwork;

@end

