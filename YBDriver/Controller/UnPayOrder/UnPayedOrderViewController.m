//
//  UnPayedOrderViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "UnPayedOrderViewController.h"
#import <MJRefresh.h>
#import "NotPayOrderService.h"
#import "Tools.h"
#import "UnPayTableViewCell.h"
#import "OrderDetailViewController.h"
#import <MBProgressHUD.h>
#import "UITableView+NoDataPrompt.h"

@interface UnPayedOrderViewController ()<UITableViewDelegate, UITableViewDataSource, NotPayOrderServiceDelegate, OrderDetailServiceDelegate>

@property (strong, nonatomic)UITableView *myTableView;

/// 未交付订单业务类
@property (strong, nonatomic) NotPayOrderService *service;

/// 界面显示到前台的时候是否要刷新数据、主要在司机交付订单成功后返回该界面和登陆界面使用
@property (assign, nonatomic) BOOL shouldRefresh;

/// 是否弹出对话框显示警告信息，pagemenue bug 滑动到底部的时候再进行左右滑动切换的时候会刷新数据
@property (assign, nonatomic) BOOL shouldShowAlert;

@end

@implementation UnPayedOrderViewController


#define kPageCount 20

#pragma mark - 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        self.tabBarItem.title = @"未交单";
        self.tabBarItem.image = [UIImage imageNamed:@"menu_order_unpay_unselected"];
        _shouldRefresh = YES;
        _shouldShowAlert = NO;
        _service = [[NotPayOrderService alloc] init];
        _service.delegate = self;
        _isRequestData = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    [self.view addSubview:self.myTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
    if(_shouldRefresh) {
        _service.tempPage = 1;
        [_myTableView.mj_header beginRefreshing];
        _shouldRefresh = NO;
    }
    _shouldShowAlert = YES;
    
    [_myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
    self.navigationController.navigationBar.topItem.title = @"未交单";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    if(_isRequestData) {
        [_myTableView.mj_header beginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark -- 控件GET方法
- (UITableView *)myTableView {
    if(!_myTableView) {
        _myTableView = [[UITableView alloc] init];
    }
    _myTableView.separatorStyle = NO;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - 64)];
    
    UINib *n = [UINib nibWithNibName:@"UnPayTableViewCell" bundle:nil];
    [_myTableView registerNib:n forCellReuseIdentifier:@"UnPayTableViewCell"];
    
    /// 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataDown)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _myTableView.mj_header = header;
    
    /// 上拉分页加载
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataUp)];
    _myTableView.mj_footer.hidden = YES;
    
    return _myTableView;
}

#pragma mark -- 功能函数
- (void)loadMoreDataUp {
    if([Tools isConnectionAvailable]) {
        _service.tempPage = _service.page + 1;
        [_service getNotPayOrderData:kPageCount];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用"];
    }
}

- (void)loadMoreDataDown {
    _service.tempPage = 1;
    if([Tools isConnectionAvailable]) {
        _service.isDropDown = YES;
        [_service getNotPayOrderData:kPageCount];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用"];
    }
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _service.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"UnPayTableViewCell";
    UnPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.order = _service.orders[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *or = _service.orders[indexPath.row];
    
    if(!_orderDetailService) {
        _orderDetailService = [[OrderDetailService alloc] init];
        _orderDetailService.delegate = self;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_orderDetailService getOrderData:or.ORD_IDX];
}

#pragma mark -- NotPayOrderServiceDelatate
- (void)successWithNotPay {
    
    _service.isDropDown = NO;
    
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
    
    [_myTableView reloadData];
    
    if(_service.orders.count > kPageCount - 1) {
        
        _myTableView.mj_footer.hidden = NO;
        
        if(_service.page != 1) {
            
            CGFloat y = _myTableView.contentOffset.y;
            CGPoint p = CGPointMake(0, y + 73);
            [_myTableView setContentOffset:p animated:YES];
        }
    }else {
        _myTableView.mj_footer.hidden = YES;
    }
    [Tools showAlert:_myTableView andTitle:@"获取成功"];
    
    _isRequestData = NO;
}

- (void)failureWithNotPay:(NSString *)msg {
    _service.isDropDown = NO;
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
    [Tools showAlert:_myTableView andTitle:msg ? msg : @"获取已交付订单失败！"];
    
    if(_service.page == 1) {
        
        [_service.orders removeAllObjects];
        [_myTableView noOrder:msg];
    } else {
        
        // 已加载完毕
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
        [_myTableView removeNoDataPrompt];
        [_myTableView.mj_footer setCount_NoMoreData:_service.orders.count];
    }
    
    [_myTableView reloadData];
    
    _isRequestData = NO;
}

#pragma mark -- OrderDetailServiceDelegate
- (void)success {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.service = _orderDetailService;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)failure:(NSString *)msg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg ? msg : @"请求失败"];
}

@end
