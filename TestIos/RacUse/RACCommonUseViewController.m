//
//  RACCommonUseViewController.m
//  TestIos
//
//  Created by liyadong on 2021/1/27.
//  Copyright © 2021 Liyadong. All rights reserved.
//

#import "RACCommonUseViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACCommonUseViewController ()<UITextFieldDelegate>

@property (nonatomic, copy) NSString  *nameStr;

/** tf */
@property (nonatomic, strong) UITextField *testTextField;

@property (nonatomic, strong) UIButton *testBtn;

@property (nonatomic, strong) RACDisposable *keyboardDisposable;


@end

@implementation RACCommonUseViewController

- (void)dealloc {
    NSLog(@"current page dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self racSubArray];
    
}
#pragma mark -- lazyload
- (UITextField *)testTextField {
    if (!_testTextField) {
        _testTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
        _testTextField.placeholder = @" 请输入内容";
        _testTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _testTextField.layer.borderWidth = 1.0;
    }
    return _testTextField;
}
- (UIButton *)testBtn {
    if (!_testBtn) {
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _testBtn.frame = CGRectMake(10, 200, 200, 50);
        [_testBtn setBackgroundColor:[UIColor greenColor]];
        [_testBtn setTitle:@"点击" forState:UIControlStateNormal];
        [_testBtn setTitle:@"点击中" forState:UIControlStateHighlighted];
    }
    return _testBtn;
}


#pragma mark - button点击事件监听
- (void)testRacBtnClick {
    [self.view addSubview:self.testBtn];
    
    [[self.testBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       NSLog(@"btn click %@",x);
    }];
    
}


#pragma mark - 手势 事件
- (void)testRACGesture {
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 200, 50)];
    aLabel.text = @"这是一个Lable";
    aLabel.backgroundColor = [UIColor greenColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.userInteractionEnabled = YES;
    [self.view addSubview:aLabel];
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [aLabel addGestureRecognizer:tap];
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"ges click %@", x);
    }];
}

#pragma mark - rac代替kvo
- (void)RAC_KVO {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.nameStr = @"10";
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.nameStr = @"20";
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.nameStr = @"30";
    });
    
    [RACObserve(self, nameStr) subscribeNext:^(id  _Nullable x) {
        NSLog(@"kvo value = %@", x);
    }];
}


#pragma mark - RAC 实现 textField delegate
- (void)racTextFieldDelegate {
    [self.view addSubview:self.testTextField];
    self.testTextField.delegate = self;

    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"text field = %@",x);
    }];
 
}
 


#pragma mark - rac notification

- (void)racNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"key board show %@", x);
    }];
}


#pragma mark - rac timer
- (void)racTimer {
    //主线程中每2秒执行一次
    RACSignal *single = [RACSignal interval:2.0 onScheduler:[RACScheduler mainThreadScheduler]];
    [single subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"every 2 second do = %@", x);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [single rac_deallocDisposable];
//        [RACDisposable disposableWithBlock:^{
//        }];
    });
    
}



#pragma mark - rac 遍历数组
- (void)racSubArray {
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4,@5,@6];
    // 这里其实是三步(底层已经封装好了,直接使用就行)
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
     NSLog(@"%@",x);
    }];
    
    
}



#pragma mark - UIKit （基于UIView控件）
- (void)testUiKitDemo {
    [self.view addSubview:self.testTextField];
    
    //1、rac_textSignal 文本监听信号，可以减少对代理方法的依赖
    //UITextField创建了一个 `textSignal`的信号，并订阅了该信号
    //当UITextField的内容发生改变时，就会回调subscribeNext
    [[self.testTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
         NSLog(@"text changed = %@", x);
    }];
    
    //2、filter 对订阅的信号进行筛选
    //当UITextField内输入的内容长度大于5时，才会回调subscribeNext
    [[[self.testTextField rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
          return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
          NSLog(@"filter result = %@",  x);
    }];
    
    //3、ignore 对订阅的信号进行过滤
    [[[self.testTextField rac_textSignal] ignore:@"666"] subscribeNext:^(NSString * _Nullable x) {
        //当输入的内容 equalTo @"666" 时，这里不执行
        //其他内容，均会执行subscribeNext
        NSLog(@"ignore = %@", x);
    }];
    
    //4、rac_signalForControlEvents 创建事件监听信号
    //当UIButton点击时，会调用subscribeNext
    [self.view addSubview:self.testBtn];
    [[self.testBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"button clicked");
    }];
    
}

#pragma mark - Foundation （Foundation对象）
- (void)testRacFoundation {
    
    [self.view addSubview:self.testTextField];

    //1、NSNotificationCenter 通知
    self.keyboardDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil]  subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@ 键盘弹起", x); // x 是通知对象
    }];
    //注意：rac_addObserverForName同样需要移除监听。RAC通知监听会返回一个RACDisposable清洁工的对象，在dealloc中销毁信号，信号销毁时，RAC在销毁的block中移除了监听
//    - (void)dealloc {
//        [_keyboardDisposable dispose];
//    }
    
    
    
    //2、 interval定时器 （程序进入后台，再重新进入前台时，仍然有效，内部是用GCD实现的）
    //创建一个定时器，间隔1s，在主线程中运行
    RACSignal *timerSignal = [RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]];
    //定时器总时间3秒
    timerSignal = [timerSignal take:3];
    //定义一个倒计时的NSInteger变量
    __block NSInteger counter = 3;
    @weakify(self)
    [timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        counter--;
        NSLog(@"count = %ld", (long)counter);
    } completed:^{
        //计时完成
        NSLog(@"Timer completed");
    }];

    
    //3、delay延迟
    //创建一个信号，2秒后订阅者收到消息
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"delay : %@", x);
    }];
    
    //4、NSArray 数组遍历
    NSArray *array = @[@"1", @"2", @"3", @"4", @"5"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"数组内容：%@", x);
    }];
    
    //5、NSDictionary字典遍历
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3"};
    [dictionary.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        // x 是一个元祖，这个宏能够将 key 和 value 拆开   乱序
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"字典内容：%@ : %@", key, value);
    }];
    
    
    //6、RACSubject代理
    //定义一个DelegateView视图，并且声明一个RACSubject的信号属性，在touchesBegan方法中，给信号发送消息
    //在UIViewController中声明DelegateView作为属性
  /**
    @interface DelegateView : UIView
    //定义了一个RACSubject信号
    @property (nonatomic, strong) RACSubject *delegateSignal;
    @end

    @implementation DelegateView

    - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        // 判断代理信号是否有值
        if (self.delegateSignal) {
            // 有值，给信号发送消息
            [self.delegateSignal sendNext:@666];
        }
    }
    @end
    
   @interface ViewController ()
   @property (nonatomic, strong) DelegateView *bView;
   @end

   //使用前，记得初始化
   self.bView.delegateSignal = [RACSubject subject];
   [self.bView.delegateSignal subscribeNext:^(id  _Nullable x) {
       //订阅到 666 的消息
       NSLog(@"RACSubject result = %@", x);
   }];

   */
}

#pragma mark - KVO （关于监听）
- (void)testRacKVO {
    //1、rac_valuesForKeyPath 通过keyPath监听
    /**
     [[self.bView rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
         //当self.bView的frame变化时，会收到消息
         NSLog(@"kvo = %@", x);
     }];
     */
    
    //2、RACObserve 属性监听,在进行监听时，同样可以使用filter信号，对值进行筛选
    /**
     //counter是一个NSInteger类型的属性
     [[RACObserve(self, counter) filter:^BOOL(id  _Nullable value) {
             return [value integerValue] >= 2;
     }] subscribeNext:^(id  _Nullable x) {
             NSLog(@"RACObserve : value = %@", x);
     }];
     */
    
    [self.view addSubview:self.testTextField];
    //3、RAC 事件绑定
     //当UITextField输入的内容为@"666"时，bView视图的背景颜色变为grayColor
     RAC(self.view, backgroundColor) = [self.testTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
         return [value isEqualToString:@"666"]?[UIColor grayColor]:[UIColor orangeColor];
     }];
     //#define RAC(TARGET, ...)这个宏定义是将对象的属性变化信号与其他信号关联，比如：登录时，当手机号码输入框的文本内容长度为11位时，"发送验证码" 的按钮才可以点击
    
}





@end
