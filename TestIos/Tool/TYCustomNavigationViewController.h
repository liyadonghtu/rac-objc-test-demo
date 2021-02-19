//
//  TYCustomNavigationViewController.h
//  Liyadong
//
//  Created by Liyadong on 2019/4/9.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYCustomNavigationViewController : UINavigationController

+(void)addBackBtnForVC:(UIViewController *)tempVC action:(SEL)action;


@end

NS_ASSUME_NONNULL_END
