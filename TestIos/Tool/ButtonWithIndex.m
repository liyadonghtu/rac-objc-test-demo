//
//  ButtonWithIndex.m
//  Liyadong
//
//  Created by Liyadong on 2019/4/13.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import "ButtonWithIndex.h"
#import "UIColor+Extend.h"

@implementation ButtonWithIndex

+ (ButtonWithIndex *)creatTYStepBtnWithFrame:(CGRect)frame
                                      Target:(id)target
                                      Action:(SEL)action
                                       Title:(NSString *)title {
    ButtonWithIndex *button = [[ButtonWithIndex alloc] initWithFrame:frame];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:TY_Title_Pingfang_font_bold size:18];
    [button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    
//    [button setBackgroundColor:[UIColor colorWithHexString:@"#3398ff"] forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    
    return button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
