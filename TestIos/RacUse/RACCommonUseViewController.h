//
//  RACCommonUseViewController.h
//  TestIos
//
//  Created by liyadong on 2021/1/27.
//  Copyright © 2021 Liyadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACCommonUseViewController : UIViewController

/**
 * button 点击事件监听
 */
- (void)testRacBtnClick;

/**
 * 手势 事件
 */
- (void)testRACGesture;

/**
 * rac代替kvo
 */
- (void)RAC_KVO;


/**
 * RAC textField delegate
 */

- (void)racTextFieldDelegate;
/**
 * rac notification
 */
- (void)racNotification;

/**
 * rac timer
 */
- (void)racTimer;


@end

NS_ASSUME_NONNULL_END
