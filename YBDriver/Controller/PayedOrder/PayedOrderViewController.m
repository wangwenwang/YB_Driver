//
//  PayedOrderViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/8/31.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "PayedOrderViewController.h"
#import <MJRefresh.h>
#import "PayedOrderService.h"
#import "Tools.h"
#import "UnPayTableViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderDetailService.h"
#import <MBProgressHUD.h>
#import "UITableView+NoDataPrompt.h"

@interface PayedOrderViewController ()<UITableViewDelegate, UITableViewDataSource, PayedOrderServiceDelegate, OrderDetailServiceDelegate, UISearchBarDelegate>


@property (strong, nonatomic)UITableView *myTableView;

@property (strong, nonatomic)UISearchBar *mySearchBar;

/// 已交付订单业务类
@property (strong, nonatomic) PayedOrderService *service;

/// 是否弹出对话框显示警告信息，pagemenue bug 滑动到底部的时候再进行左右滑动切换的时候会刷新数据
@property (assign, nonatomic) BOOL shouldShowAlert;

@property (strong, nonatomic) OrderDetailService *orderDetailService;

@end

@implementation PayedOrderViewController


#define kPageCount 20

#pragma mark - 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        self.tabBarItem.title = @"已交单";
        self.tabBarItem.image = [UIImage imageNamed:@"menu_order_payed_unselected"];
        _service = [[PayedOrderService alloc] init];
        self.service.delegate = self;
        _shouldRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.mySearchBar];
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
    self.navigationController.navigationBar.topItem.title = @"已交单";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    if(_shouldRefresh) {
        _service.tempPage = 1;
        [_myTableView.mj_header beginRefreshing];
        _shouldRefresh = NO;
    }
    
    [_myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _service.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"UnPayTableViewCell";
    UnPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.order = _service.orders[indexPath.row];
//    cell.outTimeLabel.text = @"出...";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

/// 点击 tableview 的 cell ，跳转到订单详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *or = _service.orders[indexPath.row];
    
    if(!_orderDetailService) {
        _orderDetailService = [[OrderDetailService alloc] init];
        _orderDetailService.delegate = self;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_orderDetailService getOrderData:or.ORD_IDX];
}

#pragma mark - 功能函数
- (void)loadMoreDataUp {
    if([Tools isConnectionAvailable]) {
        _service.tempPage = _service.page + 1;
        [_service getPayedOrderData:kPageCount];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用"];
    }
}

- (void)loadMoreDataDown {
    _service.tempPage = 1;
    if([Tools isConnectionAvailable]) {
        [_service getPayedOrderData:kPageCount];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用"];
    }
}

- (void)recoverKeyboardOnclick {
    
    [self.view endEditing:YES];
}

#pragma mark - 控件GET方法
- (UITableView *)myTableView {
    if(!_myTableView) {
        _myTableView = [[UITableView alloc] init];
    }
    _myTableView.separatorStyle = NO;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView setFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 49 - 64 - 40)];
    
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

- (UISearchBar *)mySearchBar {
    
    if(!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc] init];
    }
    _mySearchBar.delegate = self;
    [_mySearchBar setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _mySearchBar.placeholder = @"请输入车牌号";
    return _mySearchBar;
}

#pragma mark - PayedOrderServiceDelegate

- (void)successWithPayed {
    
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
    [_myTableView removeNoDataPrompt];
    
    if(_service.orders.count > kPageCount - 1) {
        
        _myTableView.mj_footer.hidden = NO;
        
        if(_service.page != 1) {
            
            [_myTableView reloadData];
            
            CGFloat y = _myTableView.contentOffset.y;
            CGPoint p = CGPointMake(0, y + 73);
            [_myTableView setContentOffset:p animated:YES];
        }
    } else {
        
        _myTableView.mj_footer.hidden = YES;
    }
    
    [Tools showAlert:_myTableView andTitle:@"获取成功"];
    [_myTableView reloadData];
}

- (void)failureWithPayed:(NSString *)msg {
    
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_footer endRefreshing];
    [Tools showAlert:_myTableView andTitle:msg ? msg : @"获取已交付订单失败！"];
    
    if(_service.page == 1) {
        
        [_service.orders removeAllObjects];
        [_myTableView noOrder:msg];
        if(_service.orders.count == 0) {
            
            [_myTableView.mj_footer setHidden:YES];
        }else {
            
            [_myTableView.mj_footer setHidden:NO];
        }
        [_myTableView.mj_footer setHidden:YES];
    } else {
        
        // 已加载完毕
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
        [_myTableView removeNoDataPrompt];
        [_myTableView.mj_footer setCount_NoMoreData:_service.orders.count];
    }
    
    [_myTableView reloadData];
}

#pragma mark - OrderDetailServiceDelegate
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


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    _service.TMS_PLATE_NUMBER = searchBar.text;
    [self loadMoreDataDown];
    [self.view endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor redColor];
    [coverView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_myTableView.frame))];
    coverView.tag = 10088;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverKeyboardOnclick)];
    tap.numberOfTapsRequired = 1;
    [coverView addGestureRecognizer:tap];
//    [_myTableView addSubview:coverView];
    coverView.alpha = 1;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:3.0f animations:^{
                
                coverView.alpha = 0.0f;
                [UIView animateWithDuration:3.0f animations:^{
                    
                    coverView.alpha = 0.5f;
                    
                }];
                
            }];
        });
    });
    
//    [UIView animateWithDuration:0.2 animations:^{
//
//        [coverView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_myTableView.frame))];
//        coverView.alpha = 0.4;
//    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    UIView *coverView = nil;
    for (int i = 0; i < _myTableView.subviews.count; i++) {
        
        UIView *view = _myTableView.subviews[i];
        NSInteger tag = view.tag;
        if(tag == 10088) {
            
            coverView = view;
        }
    }
    
    [UIView animateWithDuration:3 animations:^{
        
        [coverView setFrame:CGRectMake(0, 0, 0, 0)];
        coverView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [coverView removeFromSuperview];
    }];
}

@end
