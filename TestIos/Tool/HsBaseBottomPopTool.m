//
//  HsBaseBottomPopTool.m
//  HsLianchu
//
//  Created by hs on 2020/10/14.
//  Copyright © 2020 wenjie zhao. All rights reserved.
//

#import "HsBaseBottomPopTool.h"


#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)//应用尺寸


@interface HsBaseBottomPopTool ()


@property (nonatomic ,strong) UIView *bottomContentView; //底部View
@property (nonatomic ,strong) UIView *backgroundView; //遮罩

@property (nonatomic, weak) id<HsBaseBottomPopToolDelegate> delegate;



@end


@implementation HsBaseBottomPopTool


static HsBaseBottomPopTool *_instance = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HsBaseBottomPopTool alloc] init];
     });
    return _instance;
}

- (void)showBottomViewWithDetailView:(UIView *)detailView height:(CGFloat)bottomHeight delegate:(id)delegate {
    
    
    self.delegate = delegate;
//    MyLog(@"show bottom view");
    // ------全屏遮罩
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.frame = [[UIScreen mainScreen] bounds];
    self.backgroundView.tag = 100;
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.backgroundView.opaque = NO;
    
    //--UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.backgroundView];
    
    // ------给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBottomView)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.backgroundView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
    
    // ------底部弹出的View
    self.bottomContentView = [[UIView alloc] init];
    self.bottomContentView.frame = CGRectMake(0, kSCREEN_HEIGHT - bottomHeight, kSCREEN_WIDTH, bottomHeight);
    self.bottomContentView.backgroundColor = [UIColor whiteColor];
    [self.bottomContentView addSubview:detailView];
    [appWindow addSubview:self.bottomContentView];
    
   
    // ------View出现动画
    self.bottomContentView.transform = CGAffineTransformMakeTranslation(0.01, kSCREEN_HEIGHT);
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomContentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(basicBottomViewWillShow:)]) {
            [self.delegate basicBottomViewWillShow:YES];
        }
    }];
}

/**
 * 功能： View退出
 */
- (void)dismissBottomView {
//    MyLog(@"exit bottom view");
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomContentView.transform = CGAffineTransformMakeTranslation(0.01, kSCREEN_HEIGHT);
        self.bottomContentView.alpha = 0.2;
        self.backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
        [self.bottomContentView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(basicBottomViewWillShow:)]) {
            [self.delegate basicBottomViewWillShow:NO];
        }
    }];
    
}


@end
