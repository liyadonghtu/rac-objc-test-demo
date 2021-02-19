//
//  RacConceptViewController.m
//  TestIos
//
//  Created by liyadong on 2021/2/19.
//  Copyright © 2021 Liyadong. All rights reserved.
//

#import "RacConceptViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface RacConceptViewController ()
/** tf */
@property (nonatomic, strong) UITextField *testTextField;

@property (nonatomic, strong) UIButton *testBtn;


@end

@implementation RacConceptViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.testTextField];

    [self testRacKeyWord];
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
        [_testBtn setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.9]];
        [_testBtn setTitle:@"点击" forState:UIControlStateNormal];
        [_testBtn setTitle:@"点击中" forState:UIControlStateHighlighted];
    }
    return _testBtn;
}


#pragma mark - RACSignal简单使用
/**
 * RACSignal 信号相当于一个电视塔 ，只要将电视机调到跟电视塔的赫兹相同的频道，就可以收到信息。subscribeNext 相当于订阅频道。当RACSignal信号发出sendNext消息时，subscribeNext就可以接收到信息。
 */
- (void)simpleDemoForSignal {
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //任何时候，都可以发送信号，可以异步
        [subscriber sendNext:@"发送一个信号"];
        //数据传递完，最好调用sendCompleted，这时命令才执行完毕。
        [subscriber sendCompleted];
        return nil;
    }];
    
    //2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        //收到信号时
        NSLog(@"信号内容：%@", x);
    }];
    
    //取消订阅
    [disposable dispose];
    
}

#pragma mark - 事件信号
/**
 名词                         描述                        说明
 RACTuple                         元祖                         只能存储OC对象 可以用于解包或者存储对象
 bind                        包装                        获取到信号返回的值，包装成新值,再次通过信号返回给订阅者
 concat                        合并                        按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
 then                        下一个                        用于连接两个信号，当第一个信号完成，才会连接then返回的信号
 merge                        合并                        把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
 zipWith                        压缩                        把两个信号压缩成一个信号，只有当两个信号都发出一次信号内容后,并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件(组合的数据都是一一对应的)
 combineLatest                        结合                        将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号(combineLatest 与 zipWith不同的是，每次只拿各个信号最新的值)
 reduce                        聚合                        用于信号发出的内容是元组，把信号发出元组的值聚合成一个值，一般都是先组合在聚合
 map                        数据筛选                        map 的底层实现是通过 flattenMap 实现的
 flattenMap                        信号筛选                        flattenMap 的底层实现是通过bind实现的
 filter                        过滤                        过滤信号，获取满足条件的信号
 
 */

- (void)testRacKeyWord {
    //1、RACTuple 元祖
    //只能存储OC对象 可以用于解包或者存储对象
    //解包数据
    /**
     RACTupleUnpack(NSNumber *a, NSNumber *b) = x;
     */

    //2、bind 包装
    //获取到信号返回的值，包装成新值, 再次通过信号返回给订阅者
    [[self.testTextField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{ return ^RACSignal*(id value, BOOL *stop){
        // 处理完成之后，包装成信号返回出去
        return [RACSignal return:[NSString stringWithFormat:@"hello: %@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"bind : %@",x); // hello: "x"
    }];

    
    //3、concat 合并
    //按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalA"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalB"];
        [subscriber sendCompleted];
        return nil;
    }];
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活 顺序执行
    [[signalA concat:signalB] subscribeNext:^(id  _Nullable x) {
        //先拿到 signalA 的结果 ， 再拿到 signalB 的结果 ， 执行两次
        NSLog(@"concat result = %@", x);
    }];
    
    
    //4、then 下一个
    //用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    // 底层实现  1.使用concat连接then返回的信号  2.先过滤掉之前的信号发出的值
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //可以对第一个信号的数据进行过滤处理 , 不能直接获得第一个信号的数据返回值
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"then : %@",x); // 2
    }];

    
    //5、merge 合并
    //把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
    //创建多个信号
    RACSignal *mergeSignalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalA"];
        return nil;
    }];
    RACSignal *mergeSignalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"signalB"];
        return nil;
    }];
    // 合并信号,只要有信号发送数据，都能监听到.
    RACSignal *mergeSignal = [mergeSignalA merge:mergeSignalB];
        
    [mergeSignal subscribeNext:^(id x) {
        //每次获取单个信号的值
        NSLog(@"merge resul = %@",x);
    }];
    

    //6、zipWith 压缩
    //把两个信号压缩成一个信号，只有当两个信号都发出一次信号内容后,并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件(组合的数据都是一一对应的)
    RACSignal *zipSignalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@4];

        return nil;
    }];
    RACSignal *zipSignalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //3秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@3];
        });
        //5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@5];
        });
                
        return nil;
    }];
        
    RACSignal *zipSignal = [zipSignalA zipWith:zipSignalB];
        
    [zipSignal subscribeNext:^(id  _Nullable x) {
        // x 是一个元祖
        RACTupleUnpack(NSNumber *a, NSNumber *b) = x;
        NSLog(@"zip with : %@   %@", a, b);
        //第一次输出   1  3
        //第二次输出   2  5
    }];

    
    //7、combineLatest 结合
    //将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号 (combineLatest 与 zipWith不同的是，每次只拿各个信号最新的值)
    RACSignal *combineSignalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@8];
        return nil;
    }];
        
    RACSignal *combineSignalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@3];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@5];
        });
                
        return nil;
    }];
        
    RACSignal *combineSignal = [combineSignalA combineLatestWith:combineSignalB];
        
    [combineSignal subscribeNext:^(id  _Nullable x) {
        // x 是一个元祖
        RACTupleUnpack(NSNumber *a, NSNumber *b) = x;
        NSLog(@"combineLatest : %@   %@", a, b);
        //第一次输出 2 3
        //第二次输出 2 5
        //因为combineSignalA中的2是最新数据，所以，combineSignalA每次获取到的都是2
    }];

   
    //8、reduce 聚合
    //用于信号发出的内容是元组，把信号发出元组的值聚合成一个值，一般都是先组合在聚合
    RACSignal *reduceSignalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }];
        
    RACSignal *reduceSignalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@3];
        return nil;
    }];
        
    RACSignal *reduceSignal = [RACSignal combineLatest:@[reduceSignalA, reduceSignalB] reduce:^id(NSNumber *a, NSNumber *b) {
        //reduce中主要是对返回数据的处理
        return [NSString stringWithFormat:@"%@ - %@", a, b];
    }];
        
    [reduceSignal subscribeNext:^(id  _Nullable x) {
        //返回值x 取决于reduce之后的返回
        NSLog(@"reduce : %@", x);
    }];
    
    
    //9、map 数据过滤
    //map 的底层实现是通过flattenMap 实现的。map 直接对数据进行处理，并且返回处理后的数据
    [[self.testTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        // 当源信号发出，就会调用这个block，修改源信号的内容
        // 返回值：就是处理完源信号的内容。
        return [NSString stringWithFormat:@"hello : %@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"Map : %@",x); // hello: "x"
    }];
    
    
    //10、flattenMap 信号过滤
    //flattenMap 的底层实现是通过bind实现的。拿到原数据，处理完成之后，包装成信号返回
    [[self.testTextField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return  [RACSignal return:[NSString stringWithFormat:@"hello : %@", value]];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap : %@", x); // hello "x"
    }];
    
    
    //11、filter 过滤
    //过滤信号，获取满足条件的信号
    [[self.testTextField.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length > 6;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter ： %@", x); // x 值位数大于6
    }];
    
}

#pragma mark - 结合网络请求使用,以下网络接口均基于MVVM模式
#pragma mark - 1、请求单个接口
/**
 //创建请求接口的信号，该方法可以定义并实现在ViewModel层
 #pragma mark - 获取指定时间的课程
 + (RACSignal *)getCourseInfoByTime:(NSInteger)time {
     //此处为接口所需参数
     NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
     [paramter setObject:@(time) forKey:@"exerciseTime"];
     
     return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         //这里为接口请求方法
         //接口url： CombinePath(TY_DEBUG_HOST, SPORT_HOME_COURSE)
         //postRequest：接口请求类型 post
         //paramter：参数
         //[SportCourseDataModel class]：接口返回类型model
         [Networking requestWithPath:CombinePath(TY_DEBUG_HOST, SPORT_HOME_COURSE) requestType:postRequest requestParamter:paramter responseObjctClass:[SportCourseDataModel class] completionBlock:^(BOOL isSuccess, id object, NSError *error) {
             //当接口返回结果后，根据状态，分别传递object或者error给订阅者
             if (isSuccess) {
                 //将接口返回的接口object传递给subscribeNext
                 [subscriber sendNext:object];
                 //信号完成之后，最好调用sendCompleted
                 [subscriber sendCompleted];
             }
             else {
                 [subscriber sendError:error];
             }
         }];
         return nil;
     }];
 }

 //信号订阅
 //在ViewController中定义一个方法，用来调用网络接口方法
 - (void)getCourseByIsExperience:(BOOL)isExperience {
     //使用 @weakify(self) 和 @strongify(self) 避免循环引用
     @weakify(self)
     [[SportViewModel getCourseInfoByTime:0 isExperience:isExperience] subscribeNext:^(id  _Nullable x) {
         @strongify(self)
         //接口请求成功，订阅者可以在这里获取到接口返回的内容 x
     } error:^(NSError * _Nullable error) {
         @strongify(self)
         //当接口出错时，这里可以处理错误信息
     }];
 }
 */

/**
 分析：
 1、在ViewModel类中，创建了一个信号，这个信号请求了一个获取课程的接口。信号创建之后，并不会立即执行，要等订阅者，订阅并调用subscribeNext时，才会执行。
 2、在ViewController中，经过用户操作，开始调用getCourseByIsExperience方法。此时，订阅者开始订阅信号，信号中的createSignal开始执行接口请求方法。
 3、当接口请求成功后，根据状态，将对应的object或者error通过sendNext: 和sendError:传递给订阅者
 4、订阅者开始执行subscribeNext 或者 error block中的代码
 （ps：如果接口请求之后，不需要获取返回值，则可以在信号中这样返回 [subscriber sendNext:nil]）

 优点：这个接口请求过程，ViewController只需要将接口所需参数传入，即可得到接口的结果，大大简化了控制器层面的内容，使得控制器更加专注于页面之间的业务处理，数据传递等功能。
 */


#pragma mark - 2、多个接口的同时调用 (以下的接口信号创建过程，不再描述)
/**
 //获取血压收缩的数据 接口信号
 RACSignal *systolicSignal = [DataStatisticsViewModel getItemDataByPersonId:personId baseItemId:self.systolicItemModel.baseItemId];
 //获取血压舒张压的数据 接口信号
 RACSignal *diastolicSignal = [DataStatisticsViewModel getItemDataByPersonId:personId baseItemId:self.diastolicItemModel.baseItemId];
 @weakify(self)
 //因为两个接口是需要同时获取到数据的，所以可以使用combineLatest组合信号
 [[RACSignal combineLatest:@[systolicSignal, diastolicSignal]] subscribeNext:^(RACTuple * _Nullable x) {
     @strongify(self)
     //因为是请求了多个接口，所以会有多个数据返回，此处的x是一个元祖，所以使用RACTupleUnpack解包元祖
     //返回结果值(DataItemRecordModel)的顺序对应combineLatest中数组的信号顺序
     RACTupleUnpack(DataItemRecordModel *systolicModel, DataItemRecordModel *diastolicModel) = x;
     //这里可以直接使用返回值  systolicModel  和  diastolicModel
             
 } error:^(NSError * _Nullable error) {
     @strongify(self)
     //没有数据
     [self handleTheErrorMessage:error];
 }];
 */

/**
 多个接口同时调用的过程同单个接口请求类似。
 需注意：
 (一)多个接口同时请求时，只要有其中一个返回错误信息，整个结果即为失败，即会走error:^(NSError * _Nullable error){}这个block，所以必须多个接口都成功时，才会调用subscribeNext:^(RACTuple * _Nullable x){}block。
 (二)可以对结果先做聚合处理，返回再返回结果，比如：
 */
/**
 [[RACSignal combineLatest:@[systolicSignal, diastolicSignal] reduce:^id(DataItemRecordModel *systolicModel, DataItemRecordModel *diastolicModel) {
     //reduce中对数据进行处理，可以将多个接口请求的数据，处理之后，统一返回一个结果
     return systolicModel;
     //也可以将处理完的数据包装成元祖返回
     RACTuple *tuple = RACTuplePack(systolicModel, diastolicModel);
     return tuple;
 }] subscribeNext:^(id  _Nullable x) {
     //这里获取到reduce处理完成之后的数据
 } error:^(NSError * _Nullable error) {
     //这里处理错误信息
 }];
 */



@end
