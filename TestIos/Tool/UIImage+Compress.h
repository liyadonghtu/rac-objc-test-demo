//
//  UIImage+Compress.h
//  HsCommonEngine
//
//  Created by hs on 2020/11/3.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)

/** 优化图片的大小,压缩图片的质量 */
+ (UIImage *)optimizePicWithImage:(UIImage *)image;

/*
 *  压缩图片方法(压缩质量二分法)
 */
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

//图片转字符串
+(NSString *)UIImageToBase64Str:(UIImage *) image;

//字符串转图片
+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;


/**
 * base64转image，特殊处理前缀为 data:image/png;base64,或者，data:image/jpeg;base64  格式的图片
 */
+ (UIImage *)base64TtransformToImage:(NSString *)imgSrc;

/**
 * image转64
 */
+ (NSString *)imageTtransformToBase64:(UIImage *)image;



@end

NS_ASSUME_NONNULL_END
