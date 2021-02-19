//
//  HsBaseBottomPopTool.h
//  HsLianchu
//
//  Created by hs on 2020/10/14.
//  Copyright © 2020 wenjie zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HsBaseBottomPopToolDelegate <NSObject>

@optional

- (void)basicBottomViewWillShow:(BOOL)isShow;

@end


@interface HsBaseBottomPopTool : NSObject

+(instancetype)shareInstance;

- (void)showBottomViewWithDetailView:(UIView *)detailView height:(CGFloat)bottomHeight delegate:(id)delegate;

- (void)dismissBottomView;

@end


NS_ASSUME_NONNULL_END
