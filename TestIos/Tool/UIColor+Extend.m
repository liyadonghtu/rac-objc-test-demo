//
//  UIColor+Extend.m
//  HsCommonEngine
//
//  Created by wangzf on 2019/1/17.
//  Copyright © 2019年 tzyj. All rights reserved.
//

#import "UIColor+Extend.h"

int getIntegerFromHexString(NSString *str) {
    int nValue = 0;
    for (int i = 0; i < [str length]; i++)
    {
        int nLetterValue = 0;
        
        if ([str characterAtIndex:i] >='0' && [str characterAtIndex:i] <='9') {
            nLetterValue += ([str characterAtIndex:i] - '0');
        }
        else{
            switch ([str characterAtIndex:i])
            {
                case 'a':case 'A':
                    nLetterValue = 10;break;
                case 'b':case 'B':
                    nLetterValue = 11;break;
                case 'c': case 'C':
                    nLetterValue = 12;break;
                case 'd':case 'D':
                    nLetterValue = 13;break;
                case 'e': case 'E':
                    nLetterValue = 14;break;
                case 'f': case 'F':
                    nLetterValue = 15;break;
                default:nLetterValue = '0';
            }
        }
        
        nValue = nValue * 16 + nLetterValue; //16进制
    }
    return nValue;
}


@implementation UIColor (Extend)

+ (instancetype)colorWithHexString:(NSString*)hexString{
    if ([hexString length] == 0) {
        return [UIColor clearColor];
    }
    
    if ( [hexString rangeOfString:@"#"].location != 0 ) {//error
        return [UIColor redColor];
    }
    
    if ([hexString length] == 7) {
        hexString = [hexString stringByAppendingString:@"FF"];
    }
    
    if ([hexString length] != 9) { //error
        return [UIColor redColor];
    }
    
    const char * strBuf= [hexString UTF8String];
    
    unsigned long iColor = strtoul((strBuf+1), NULL, 16);
    typedef struct colorByte {
        unsigned char a;
        unsigned char b;
        unsigned char g;
        unsigned char r;
    }CLRBYTE;
    
    CLRBYTE  pclr ;
    memcpy(&pclr, &iColor, sizeof(CLRBYTE));
    
    return [UIColor colorWithRed:(pclr.r/255.0)
                           green:(pclr.g/255.0)
                            blue:(pclr.b/255.0)
                           alpha:(pclr.a/255.0)];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha
{
    UIColor *color = [UIColor clearColor];
    
    if ([[hexString substringToIndex:1] isEqualToString:@"#"]) {
        
        if ([hexString length]==7) {
            NSRange range = NSMakeRange(1,2);
            NSString *strRed = [hexString substringWithRange:range];
            
            range.location = 3;
            NSString *strGreen = [hexString substringWithRange:range];
            
            range.location = 5;
            NSString *strBlue = [hexString substringWithRange:range];
            
            float r = getIntegerFromHexString(strRed);
            float g = getIntegerFromHexString(strGreen);
            float b = getIntegerFromHexString(strBlue);
            
            color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:alpha];
        }
    }
    return color;
}

- (NSString *)hexString {
    //颜色值个数，rgb和alpha
    NSInteger cpts = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];//红色
    CGFloat g = components[1];//绿色
    CGFloat b = components[2];//蓝色
    if (cpts == 4) {
        CGFloat a = components[3];//透明度
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    } else {
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    }
}

- (NSString *)hexStringWithoutAlpha {
    //颜色值个数，rgb和alpha
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];//红色
    CGFloat g = components[1];//绿色
    CGFloat b = components[2];//蓝色

    return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}

@end
