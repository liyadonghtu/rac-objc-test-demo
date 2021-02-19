//
//  ButtonWithIndex.h
//  Liyadong
//
//  Created by Liyadong on 2019/4/13.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonWithIndex : UIButton

/** btn下标 */
@property (nonatomic, assign) NSInteger index;

/** btn位置属性 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/** btn步骤按钮 */
+ (ButtonWithIndex *)creatTYStepBtnWithFrame:(CGRect)frame
                             Target:(id)target
                             Action:(SEL)action
                              Title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
