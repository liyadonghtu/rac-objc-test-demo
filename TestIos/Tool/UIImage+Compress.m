//
//  UIImage+Compress.m
//  HsCommonEngine
//
//  Created by hs on 2020/11/3.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)


+ (UIImage *)optimizePicWithImage:(UIImage *)image {

    NSData *originData = UIImageJPEGRepresentation(image, 1.0f);
    
    double originDataSize = (double)originData.length/1024.0f/1024.0f;
    
    NSLog(@"%@",[NSString stringWithFormat:@"原数据大小:%.4f MB",originDataSize]);
    
    NSLog(@"原数据尺寸: width:%f height:%f",image.size.width,image.size.height);
    
    
    if (originDataSize > 0.1) {
        //图片压缩
        NSData *compressData = [image compressBySizeWithLengthLimit:0.1 * 1024.0f * 1024.0f];
        UIImage *compressImage = [UIImage imageWithData:compressData];
        NSLog(@"压缩后数据尺寸: width:%f height:%f",compressImage.size.width,compressImage.size.height);
        NSLog(@"压缩后数据大小:%.4f MB",(double)compressData.length/1024.0f/1024.0f);
        return compressImage;
    } else { //图片较小不需要压缩
        return image;
    }
    
}

-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}

+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}


//图片转字符串
+(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}


/**
 * base64转image，特殊处理前缀为 data:image/png;base64,或者，data:image/jpeg;base64  格式的图片
 */
+ (UIImage *)base64TtransformToImage:(NSString *)imgSrc {
    //进行首尾空字符串的处理
    imgSrc = [imgSrc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除掉首尾的空白字符和换行字符
    //进行空字符串的处理
    imgSrc = [imgSrc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    //进行换行字符串的处理
    imgSrc = [imgSrc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //去掉头部的前缀//data:image/png;base64, （可根据实际数据情况而定，如果数据有固定的前缀，就执行下面的方法，如果没有就注销掉或删除掉）
//    if ([imgSrc hasPrefix:@"data:image/png;base64,"]) {
//        imgSrc = [imgSrc substringFromIndex:22];
//    }
//
//    if ([imgSrc hasPrefix:@"data:image/jpeg;base64,"]) {
//        imgSrc = [imgSrc substringFromIndex:23];
//    }
    
    NSString *specialStr = @";base64,";
    if ([imgSrc containsString:specialStr]) {
        NSArray *imageStrArray = [imgSrc componentsSeparatedByString:specialStr];
        imgSrc = imageStrArray.lastObject;
    }
    
    
    NSString *encodedImageStr = imgSrc;
    //进行字符串转data数据 -------NSDataBase64DecodingIgnoreUnknownCharacters
    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //把data数据转换成图片内容
    UIImage *decodedImage = [UIImage imageWithData:decodedImgData];
    return decodedImage;
}


+ (BOOL)imageHasAlpha:(UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
+ (NSString *)imageTtransformToBase64:(UIImage *)image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
  
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
  
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
           [imageData base64EncodedStringWithOptions: 0]];
  
}


 


@end
