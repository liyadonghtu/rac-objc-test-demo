//
//  HsPopViewTool.h
//  TestIos
//
//  Created by hs on 2020/10/21.
//  Copyright © 2020 Liyadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 *  关闭按钮的位置
 */
typedef NS_ENUM(NSInteger, ButtonPositionType) {
    /**
     *  无
     */
    ButtonPositionTypeNone = 0,
    /**
     *  左上角
     */
    ButtonPositionTypeLeft = 1 << 0,
    /**
     *  右上角
     */
    ButtonPositionTypeRight = 2 << 0
};


typedef void(^completeBlock)(void);


@interface HsPopViewTool : NSObject


@property (assign, nonatomic) BOOL tapOutsideToDismiss;//点击蒙板是否弹出视图消失

@property (assign, nonatomic) ButtonPositionType closeButtonType;//关闭按钮的类型

/**
 *  创建一个实例
 *
 *  @return CHWPopTool
 */
+ (HsPopViewTool *)sharedInstance;
/**
 *  弹出要展示的View
 *
 *  @param presentView show View
 *  @param animated    是否动画
 */
- (void)showWithPresentView:(UIView *)presentView animated:(BOOL)animated;
/**
 *  关闭弹出视图
 *
 *  @param complete complete block
 */
- (void)closeWithBlcok:(void(^)(void))complete;



@end

NS_ASSUME_NONNULL_END
