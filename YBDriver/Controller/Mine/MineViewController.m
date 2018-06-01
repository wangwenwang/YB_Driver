//
//  MineViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "ChangePasswordViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ManangeInformationViewController.h"
#import "ManangeInformationService.h"
#import <MBProgressHUD.h>
#import "Tools.h"
#import "MainViewController.h"
#import "QRCodeViewController.h"
#import "FactoryChartViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, ManangeInformationServiceDelegate> {
    NSMutableArray *_minePlistArrM;
    AppDelegate *_app;
}

@property (weak, nonatomic) IBOutlet UITableView *mineTableView;
- (IBAction)changeAccount:(UIButton *)sender;
@property (strong, nonatomic) ManangeInformationService *manangeInformationService;

// 底部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end

@implementation MineViewController

#pragma -- mark 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        self.title = @"我的";
        self.tabBarItem.image = [UIImage imageNamed:@"menu_mine_unselected"];
        _minePlistArrM = [[NSMutableArray alloc] init];
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _manangeInformationService = [[ManangeInformationService alloc] init];
        _manangeInformationService.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    // 设定pList文件路径
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"Mine.plist" ofType:nil];
    // 填充数组内容
    _minePlistArrM = [NSMutableArray arrayWithContentsOfFile:dataPath];
    
    
    if(![Tools isADMINorWLS]) {
        
        for (int i = 0; i < _minePlistArrM.count; i++) {
            
            if([_minePlistArrM[i][@"title"] isEqualToString:@"工厂管理信息"]) {
                
                [_minePlistArrM removeObjectAtIndex:i];
            }
        }
    }
    
    [self initMineTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
    
    self.navigationController.navigationBar.topItem.title = @"我的";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    _bottomHeight.constant = KISIphoneX ? (34 + 49) : 49;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

#pragma mark - 功能函数
// 初始我的列表
- (void)initMineTableView {
    UINib *n = [UINib nibWithNibName:@"MineTableViewCell" bundle:nil];
    [self.mineTableView registerNib:n forCellReuseIdentifier:@"MineTableViewCell"];
}

// 销毁MainViewController的计时器，不然控制器不释放
- (void)invalidateTimer {
    NSArray *navControllers = self.navigationController.viewControllers;
    MainViewController *mainVc = nil;
    UITabBarController *tbarVc = nil;
    for (int i = 0; i < navControllers.count; i++) {
        UIViewController *vc = navControllers[i];
        if([vc isMemberOfClass:[UITabBarController class]]) {
            tbarVc = (UITabBarController *)vc;
            break;
        }
    }
    NSArray *tbarControllers = tbarVc.viewControllers;
    for (int i = 0; i < tbarControllers.count; i++) {
        UIViewController *vc = tbarControllers[i];
        if([vc isMemberOfClass:[MainViewController class]]) {
            mainVc = (MainViewController *)vc;
            break;
        }
    }
    [mainVc.localTimer invalidate];
}

#pragma mark - 点击事件
- (IBAction)changeAccount:(UIButton *)sender {
    [self invalidateTimer];
    
    LoginViewController *LoginVc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:LoginVc];
    
    [Tools setRootViewController:_app.window andViewController:nav];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _minePlistArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.oneLabel.text = _minePlistArrM[indexPath.row][@"title"];
    cell.twoLabel.text = _minePlistArrM[indexPath.row][@"prompt"];
    
    if([cell.oneLabel.text isEqualToString:@"用户姓名："]) {
        
        cell.twoLabel.text = _app.user.USER_NAME ? _app.user.USER_NAME : @"";
    } else if([cell.oneLabel.text isEqualToString:@"用户角色："]) {
        
        cell.twoLabel.text = _app.user.USER_NAME ? _app.user.USER_TYPE : @"";
    } else if([cell.oneLabel.text isEqualToString:@"当前版本    "]) {
        
        cell.twoLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    
    if([_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"修改密码"] ||
       [_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"物流管理信息"] ||
       [_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"工厂管理信息"] ||
       [_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"二维码"] ||
       [_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"关于"]
       ) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"修改密码"]) {
        
        ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"物流管理信息"]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if([Tools isConnectionAvailable]) {
            [_manangeInformationService.arrM removeAllObjects];
            [_manangeInformationService getManangeInformationData:@""];
        }else {
            [Tools showAlert:self.view andTitle:@"网络不可用"];
        }
    }else if([_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"工厂管理信息"]) {
        
        FactoryChartViewController *vc = [[FactoryChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"二维码"]) {
        
        QRCodeViewController *vc = [[QRCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([_minePlistArrM[indexPath.row][@"title"] isEqualToString:@"关于"]) {
        
        AboutViewController *vc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //    //权限管理
    //    if([Tools isADMINorWLS]) {
    //
    //    }else {
    //        if(indexPath.row == 3) {
    //
    //        }
    //    }
}

#pragma mark - ManangeInformationServiceDelegate
- (void)success {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    ManangeInformationViewController *vc = [[ManangeInformationViewController alloc] init];
    vc.arrM = _manangeInformationService.arrM;
    if(_manangeInformationService.arrM.count) {
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [Tools showAlert:self.view andTitle:@"没有数据"];
    }
}

- (void)failure:(NSString *)msg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg ? msg : @"请求失败"];
}

@end
