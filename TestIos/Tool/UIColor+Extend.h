//
//  UIColor+Extend.h
//  HsCommonEngine
//
//  Created by wangzf on 2019/1/17.
//  Copyright © 2019年 tzyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extend)

/**
 * @brief 通过hexString实例化，支持RGB、RGBA
 */
+ (instancetype)colorWithHexString:(NSString*)hexString;

/**
 * @brief 通过hexString实例化，支持alpha修改 alpha范围 0 -- 1
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha;

/**
 * @brief 返回hexString(RGBA)
 */
- (NSString *)hexString;

/**
* @brief 返回hexString(RGB)
*/
- (NSString *)hexStringWithoutAlpha;
@end

NS_ASSUME_NONNULL_END
