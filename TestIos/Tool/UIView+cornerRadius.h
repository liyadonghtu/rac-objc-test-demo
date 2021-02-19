//
//  UIView+cornerRadius.h
//  HsLianchu
//
//  Created by hs on 2020/10/12.
//  Copyright © 2020 wenjie zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (cornerRadius)

/*设置顶部圆角*/
- (void)setCornerOnTop:(CGFloat )cornerRadius;

/*设置顶部左边圆角*/
- (void)setCornerOnTopLeft:(CGFloat )cornerRadius;

/*设置顶部右边圆角*/
- (void)setCornerOnTopRight:(CGFloat )cornerRadius;



/*设置底部圆角*/
- (void)setCornerOnBottom:(CGFloat )cornerRadius;

/*设置底部左侧圆角*/
- (void)setCornerOnBottomLeft:(CGFloat )cornerRadius;

/*设置底部右侧圆角*/
- (void)setCornerOnBottomRight:(CGFloat )cornerRadius;



/*设置左边圆角*/
- (void)setCornerOnLeft:(CGFloat )cornerRadius;

/*设置右边圆角*/
- (void)setCornerOnRight:(CGFloat )cornerRadius;

/*设置四边圆角*/
- (void)setAllCorner;

@end

NS_ASSUME_NONNULL_END
