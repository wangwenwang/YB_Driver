//
//  OrderPathCheckViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/3.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "OrderPathCheckViewController.h"
#import "NotPayOrderService.h"
#import "CheckPayedOrderPathService.h"
#import "Tools.h"
#import "NotPayedTableViewCell.h"
#import <MJRefresh.h>
#import "CheckPathViewController.h"


@interface OrderPathCheckViewController ()<UITableViewDelegate, UITableViewDataSource, CheckPayedOrderPathServiceDelegate, NotPayOrderServiceDelegate> {
    /// 提示信息对话框
    //    private var alertController = UIAlertView()
    
    /// 用户当前选择的时间类型  1:起始时间 2:结束时间
    int _choiceTimeType;
    
    /// 起始时间按钮
    __weak IBOutlet UIButton *startTimeBtn;
    
    /// 结束时间按钮
    __weak IBOutlet UIButton *endTimeBtn;
    
    NSDateFormatter *_formatter;
    
}

/// 记住用户选的开始时间，存储用
@property(copy, nonatomic) NSString *startTime;

/// 记住用户选的结束时间，存储用
@property(copy, nonatomic) NSString *endTime;

/// 开始时间,默认为 "2015-08-01 00:00:00"，显示用
@property(copy, nonatomic) NSDate *startDate;

/// 结束时间，默认未当前时间，显示用
@property(copy, nonatomic) NSDate *endDate;

///// 用户选择的时间
//@property(copy, nonatomic) NSString *choiceTime;

/// 未交付订单业务类
@property(strong, nonatomic) NotPayOrderService *notPayOrderService;

/// 已交付订单业务类
@property(strong, nonatomic) CheckPayedOrderPathService *payedOrderService;

/// 显示时间选择器控件
@property (strong, nonatomic) UIView *coView;

///时间选择器是否弹出
@property (assign, nonatomic) BOOL isShowDatePicker;

@property (weak, nonatomic) IBOutlet UITableView *notPayTableView;
@property (weak, nonatomic) IBOutlet UITableView *payedTableView;

- (IBAction)startTimeOnclick:(UIButton *)sender;
- (IBAction)endTimeOnclick:(UIButton *)sender;


@end

@implementation OrderPathCheckViewController

#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        _isShowDatePicker = NO;
        _notPayOrderService = [[NotPayOrderService alloc] init];
        _notPayOrderService.delegate = self;
        _payedOrderService = [[CheckPayedOrderPathService alloc] init];
        _payedOrderService.delegate = self;
        
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        _startTime = @"2015-08-01 00:00:00";
        _startDate = [_formatter dateFromString:_startTime];
        _endDate = [NSDate date];
        _endTime = [_formatter stringFromDate:_endDate];
        
        self.title = @"订单线路";
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    [self initNotPayedTableView];
    [self initPayedTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
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

#pragma mark -- 功能函数
/// 初始未交付订单列表
- (void)initNotPayedTableView {
    UINib *n = [UINib nibWithNibName:@"NotPayedTableViewCell" bundle:nil];
    [self.notPayTableView registerNib:n forCellReuseIdentifier:@"NotPayedTableViewCell"];
    _notPayTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _notPayTableView.separatorStyle = NO;
    
    /// 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownNotpay)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.notPayTableView.mj_header = header;
    [self.notPayTableView.mj_header beginRefreshing];
    
    /// 上拉分页加载
    self.notPayTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToNotPay)];
    self.notPayTableView.mj_footer.hidden = YES;
}

/// 初始已交付订单列表
- (void)initPayedTableView {
    UINib *n = [UINib nibWithNibName:@"NotPayedTableViewCell" bundle:nil];
    [_payedTableView registerNib:n forCellReuseIdentifier:@"NotPayedTableViewCell"];
    //    _payedTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _payedTableView.separatorStyle = NO;
    
    /// 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownPayed)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _payedTableView.mj_header = header;
    [_payedTableView.mj_header beginRefreshing];
    
    /// 上拉分页加载
    _payedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToPayed)];
    _payedTableView.mj_footer.hidden = YES;
}

- (void)dropDownNotpay {
    _notPayOrderService.tempPage = 1;
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        _notPayOrderService.isDropDown = YES;
        [_notPayOrderService getNotPayOrderData];
    }else{
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
        [_notPayTableView.mj_header endRefreshing];
    }
}

- (void)pullToNotPay {
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        _notPayOrderService.tempPage = _notPayOrderService.page + 1;
        [_notPayOrderService getNotPayOrderData];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
        [_notPayTableView.mj_footer endRefreshing];
    }
}

- (void)dropDownPayed {
    _payedOrderService.tempPage = 1;
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        [_payedOrderService getPayedOrderData:_startTime andEndTime:_endTime];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
        [_payedTableView.mj_header endRefreshing];
    }
}

- (void)pullToPayed {
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        _notPayOrderService.tempPage = _notPayOrderService.page + 1;
        [_payedOrderService getPayedOrderData:_startTime andEndTime:_endTime];
    }else{
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
        [_payedTableView.mj_footer endRefreshing];
    }
}

#pragma mark -- 点击事件
- (IBAction)startTimeOnclick:(UIButton *)sender {
    _choiceTimeType = 1;
    [self createDatePicker];
}

- (IBAction)endTimeOnclick:(UIButton *)sender {
    _choiceTimeType = 2;
    [self createDatePicker];
}

- (void)createDatePicker {
    if(_isShowDatePicker) return;
    CGFloat startX = 10;
    CGFloat width = self.view.frame.size.width - startX * 2;
    CGFloat height = width * 2 / 3;
    CGFloat startY = (ScreenHeight - height) / 2;
    CGFloat buttonHeight = 35;
    CGFloat buttonWidth = 100;
    CGFloat buttonSpan = (width-buttonWidth * 2) / 3;
    /// 添加背景
    _coView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height + buttonHeight + 10)];
    _coView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_coView];
    
    /// 添加确定按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonSpan, height + 5, buttonWidth, buttonHeight)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:YBGreen];
    cancelButton.layer.cornerRadius = 2.0;
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_coView addSubview:cancelButton];
    
    /// 添加确认按钮
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonSpan * 2 + buttonWidth, height + 5, buttonWidth, buttonHeight)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundColor:YBGreen];
    sureButton.layer.cornerRadius = 2.0;
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_coView addSubview:sureButton];
    
    //创建日期选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    //将日期选择器区域设置为中文，则选择器日期显示为中文
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    //设置样式，当前设为同时显示日期和时间
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *minDate = [_formatter dateFromString:@"2014-5-20"];
    datePicker.maximumDate = [[NSDate alloc] init];
    datePicker.minimumDate = minDate;
    // 设置默认时间
    if(_choiceTimeType == 1) {
        datePicker.date = _startDate;
    }else if(_choiceTimeType == 2) {
        datePicker.date = _endDate;
    }
    
    //注意：action里面的方法名后面需要加个冒号“：”
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_coView addSubview:datePicker];
    
    _isShowDatePicker = YES;
}

// 日期选择器响应方法
- (void)dateChanged:(UIDatePicker *)datePicker {
    NSDate *date = datePicker.date;
    if(_choiceTimeType == 1) {
        _startDate = date;
        _startTime = [_formatter stringFromDate:date];
    }else if(_choiceTimeType == 2) {
        _endDate = date;
        NSString *pickerStr = [_formatter stringFromDate:date];
        NSString *endOfDay = @"23:59:59";
        if(pickerStr.length == 19) {
            _endTime = [pickerStr stringByReplacingCharactersInRange:NSMakeRange(11, 8) withString:endOfDay];
        }
    }
}

/// 时间选择器点击取消按钮
- (void)cancelButtonClick:(UIButton *)sender {
    [_coView removeFromSuperview];
    _isShowDatePicker = NO;
}

/// 时间选择器点击了确定按钮
- (void)sureButtonClick:(UIButton *)sender {
    [_coView removeFromSuperview];
    if(_choiceTimeType == 1) {
        [startTimeBtn setTitle:_startTime forState:UIControlStateNormal];
    } else if(_choiceTimeType == 2) {
        [endTimeBtn setTitle:_endTime forState:UIControlStateNormal];
    }
    
    [_payedOrderService getPayedOrderData:_startTime andEndTime:_endTime];
    NSLog(@"startDate:%@, endDate:%@", _startTime, _endTime);
    _isShowDatePicker = NO;
}

#pragma mark -- UITableViewDelegate

/// 设置 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if([tableView isEqual:_notPayTableView]) {
        count = _notPayOrderService.orders.count;
    }else if([tableView isEqual:_payedTableView]) {
        count = _payedOrderService.orders.count;
    }
    return count;
}

/// 设置自定义的 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"NotPayedTableViewCell";
    NotPayedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if([tableView isEqual:_notPayTableView]) {
        cell.order = _notPayOrderService.orders[indexPath.row];
    }else if([tableView isEqual:_payedTableView]) {
        cell.order = _payedOrderService.orders[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckPathViewController *vc = [[CheckPathViewController alloc] init];
    if([tableView isEqual:_notPayTableView]) {
        OrderModel *or = _notPayOrderService.orders[indexPath.row];
        vc.orderIDX = or.ORD_IDX;
        
    }else if([tableView isEqual:_payedTableView]) {
        OrderModel *or = _payedOrderService.orders[indexPath.row];
        vc.orderIDX = or.ORD_IDX;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- CheckNotPayOrderPathServiceDelatate
- (void)successWithNotPay {
    _notPayOrderService.isDropDown = NO;
    [_notPayTableView.mj_footer endRefreshing];
    [_notPayTableView.mj_header endRefreshing];
    if(_notPayOrderService.orders.count > 19) {
        _notPayTableView.mj_footer.hidden = NO;
    }else {
        _notPayTableView.mj_footer.hidden = YES;
    }
    [Tools showAlert:self.view andTitle:@"获取成功"];
    [_notPayTableView reloadData];
}

- (void)failureWithNotPay:(NSString *)msg {
    _notPayOrderService.isDropDown = NO;
    [_notPayTableView.mj_header endRefreshing];
    [_notPayTableView.mj_footer endRefreshing];
    [Tools showAlert:self.view andTitle:msg ? msg : @"获取未交付订单失败！"];
}

#pragma mark -- CheckPayedOrderPathServiceDelegate
- (void)successWithPayed {
    [_payedTableView.mj_header endRefreshing];
    [_payedTableView.mj_footer endRefreshing];
    if(_payedOrderService.orders.count > 19) {
        _payedTableView.mj_footer.hidden = NO;
    }else {
        _payedTableView.mj_footer.hidden = YES;
    }
    [Tools showAlert:self.view andTitle:@"获取成功"];
    [_payedTableView reloadData];
}

- (void)failureWithPayed:(NSString *)msg {
    [_payedTableView.mj_header endRefreshing];
    [_payedTableView.mj_footer endRefreshing];
    [Tools showAlert:self.view andTitle:msg ? msg : @"获取已交付订单失败！"];
    [_payedTableView reloadData];
}

@end
