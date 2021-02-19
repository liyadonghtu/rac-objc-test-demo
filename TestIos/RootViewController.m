//
//  RootViewController.m
//  TestIos
//
//  Created by Liyadong on 2019/4/17.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import "RootViewController.h"
#import "Masonry.h"
 

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

 
/** table列表 */
@property (nonatomic, strong) UITableView *myTableView;

/** 数据源 */
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.title = @"主目录视图";

    [self.view addSubview:self.myTableView];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    self.dataArray = @[
    @{@"title":@"Rac基本概念理解",@"VC":@"RacConceptViewController"},
    @{@"title":@"ReactiveObjC常见用法",@"VC":@"RACCommonUseViewController"}
    ];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}


#pragma mark — lazyload

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
    }
    return _myTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierStr = @"iosUserDemo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierStr];
    }
    NSDictionary *tempDic = self.dataArray[indexPath.row];
    cell.textLabel.text = tempDic[@"title"];
    cell.detailTextLabel.text = tempDic[@"VC"];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *tempDic = self.dataArray[indexPath.row];
    NSString *VCTitle = tempDic[@"title"];
    NSString *VCName = tempDic[@"VC"];
    Class tempClass = NSClassFromString(VCName);
    
    UIViewController *tempVC = [tempClass new];
    tempVC.title = VCTitle;
    tempVC.view.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
 
    [self.navigationController pushViewController:tempVC animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
