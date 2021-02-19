//
//  UIImage+colorImage.h
//  TestIos
//
//  Created by hs on 2020/10/15.
//  Copyright © 2020 Liyadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (colorImage)

//通过颜色生成一张图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//给图片切割圆角
+ (UIImage *)setCornerWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius;
//根据颜色生成一张带圆角的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;



@end

NS_ASSUME_NONNULL_END
