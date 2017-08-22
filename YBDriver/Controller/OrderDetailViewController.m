//
//  OrderDetailViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/6.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailsTableViewCell.h"
#import "Tools.h"
#import "OrderModel.h"
#import <MBProgressHUD.h>
#import "CheckPathViewController.h"
#import "PayOrderViewController.h"
#import "AppDelegate.h"
#import "CheckPictureViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *_app;
}

/// 订单编号Label
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

/// 订单详情业务类
//@property (strong, nonatomic)OrderDetailService *service;

/// 订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderNO;

/// 承运商名
@property (weak, nonatomic) IBOutlet UILabel *orderIssueName;

/// 出库时间
@property (weak, nonatomic) IBOutlet UILabel *orderOutTime;

/// 交付状态
@property (weak, nonatomic) IBOutlet UILabel *orderPayStae;

/// 司机姓名
@property (weak, nonatomic) IBOutlet UILabel *orderDriverName;

/// 司机号码
@property (weak, nonatomic) IBOutlet UILabel *orderDriverPhoneNumber;

/// 运输方式
@property (weak, nonatomic) IBOutlet UILabel *orderTransWay;

/// 车牌号码
@property (weak, nonatomic) IBOutlet UILabel *orderCarNumber;

/// 货物总数
@property (weak, nonatomic) IBOutlet UILabel *orderTotalCount;

/// 货物总重
@property (weak, nonatomic) IBOutlet UILabel *orderTotalWeight;

/// 客户名称
@property (weak, nonatomic) IBOutlet UILabel *customerName;

/// 目的地点
@property (weak, nonatomic) IBOutlet UILabel *orderToAddress;

/// 货物信息
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//这两个按钮改为手写
//@property (weak, nonatomic) IBOutlet UIButton *showOrderPathBtn;
//@property (weak, nonatomic) IBOutlet UIButton *orderPayedBtn;

///// 查看路线
//- (IBAction)showOrderPathOnclick:(UIButton *)sender;
//
///// 到达交付
//- (IBAction)orderPayedOnclick:(UIButton *)sender;

@end

@implementation OrderDetailViewController

#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        _app = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    self.title = @"物流信息";
    [self regisCell];
    
    OrderModel *order = _service.order;
    if(order) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updataUI:order];
            [self addBottomBtn];
            [_myTableView reloadData];
        });
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
    OrderModel *order = _service.order;
    if(order) {
        [self updataUI:order];
    }
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

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 功能函数
/// 注册Cell
- (void)regisCell {
    UINib *n = [UINib nibWithNibName:@"OrderDetailsTableViewCell" bundle:nil];
    [_myTableView registerNib:n forCellReuseIdentifier:@"OrderDetailsTableViewCell"];
    _myTableView.separatorStyle = NO;
}

/// 更新界面中的数据
- (void)updataUI:(OrderModel *)order {
    _orderNO.text = order.ORD_NO;
    _orderIssueName.text = order.TMS_FLEET_NAME;
    _orderOutTime.text = order.TMS_DATE_ISSUE;
    _orderPayStae.text = [Tools getOrderPayState:order.DRIVER_PAY];
    _orderDriverName.text = order.TMS_DRIVER_NAME;
    _orderDriverPhoneNumber.text = order.TMS_DRIVER_TEL;
    _orderTransWay.text = order.TMS_TYPE_TRANSPORT;
    _orderCarNumber.text = order.TMS_PLATE_NUMBER;
    _orderTotalCount.text = [NSString stringWithFormat:@"%@件", order.ORD_QTY];
    _orderTotalWeight.text = [NSString stringWithFormat:@"%@吨", order.ORD_WEIGHT];
    _customerName.text = order.ORD_TO_NAME;
    _orderToAddress.text = order.ORD_TO_ADDRESS;
}

/// 猪多重复代码，下个版本修改
/// 添加底部按钮，司机有两个按钮（查看路线 到达交付），其它用户只能查看路线
- (void)addBottomBtn {
    if(_service.order.OrderDetails.count > 0) {
        if([_app.user.USER_TYPE isEqualToString:@"司机"]) {
            //两个按钮之间的距离
            CGFloat btnToBtnSpace = 15;
            
            //添加查看路线按钮
            UIButton *showOrderPathBtn = [[UIButton alloc] init];
            CGFloat showOrderPathX = CGRectGetMinX(_orderNoLabel.frame);
            CGFloat showOrderPathY = CGRectGetMaxY(_myTableView.frame);
            CGFloat showOrderPathW = (ScreenWidth - 8 - btnToBtnSpace - 8) / 2;
            CGFloat showOrderPathH = 35;
            [showOrderPathBtn setFrame:CGRectMake(showOrderPathX, showOrderPathY, showOrderPathW, showOrderPathH)];
            showOrderPathBtn.backgroundColor = YBGreen;
            showOrderPathBtn.layer.cornerRadius = 2.0f;
            [showOrderPathBtn setTitle:@"查看路线" forState:UIControlStateNormal];
            [showOrderPathBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [showOrderPathBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            [showOrderPathBtn addTarget:self action:@selector(showOrderPathOnclick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:showOrderPathBtn];
            
            //添加到达交付按钮
            UIButton *orderPayedBtn = [[UIButton alloc] init];
            CGFloat orderPayedX = CGRectGetMaxX(showOrderPathBtn.frame) + btnToBtnSpace;
            CGFloat orderPayedY = CGRectGetMinY(showOrderPathBtn.frame);
            CGFloat orderPayedW = CGRectGetWidth(showOrderPathBtn.frame);
            CGFloat orderPayedH = CGRectGetHeight(showOrderPathBtn.frame);
            [orderPayedBtn setFrame:CGRectMake(orderPayedX, orderPayedY, orderPayedW, orderPayedH)];
            orderPayedBtn.backgroundColor = YBGreen;
            orderPayedBtn.layer.cornerRadius = 2.0f;
            NSString *orderPayedBtnTitle = @"";
            if([_service.order.DRIVER_PAY isEqualToString:@"Y"]) {
                orderPayedBtnTitle = @"查看签名、图片";
                [orderPayedBtn addTarget:self action:@selector(checkAutographAndPicture:) forControlEvents:UIControlEventTouchUpInside];
                
            }else {
                if([_service.order.DRIVER_PAY isEqualToString:@"N"]) {
                    orderPayedBtnTitle = @"到达交付";
                }else {
                    orderPayedBtnTitle = @"最终交付";
                }
                [orderPayedBtn addTarget:self action:@selector(orderPayedOnclick) forControlEvents:UIControlEventTouchUpInside];
            }
            [orderPayedBtn setTitle:orderPayedBtnTitle forState:UIControlStateNormal];
            [orderPayedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [orderPayedBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
            
            [self.view addSubview:orderPayedBtn];
        }else {
            if([_service.order.DRIVER_PAY isEqualToString:@"Y"]) {
                //两个按钮之间的距离
                CGFloat btnToBtnSpace = 15;
                
                //添加查看路线按钮
                UIButton *showOrderPathBtn = [[UIButton alloc] init];
                CGFloat showOrderPathX = CGRectGetMinX(_orderNoLabel.frame);
                CGFloat showOrderPathY = CGRectGetMaxY(_myTableView.frame);
                CGFloat showOrderPathW = (ScreenWidth - 8 - btnToBtnSpace - 8) / 2;
                CGFloat showOrderPathH = 35;
                [showOrderPathBtn setFrame:CGRectMake(showOrderPathX, showOrderPathY, showOrderPathW, showOrderPathH)];
                showOrderPathBtn.backgroundColor = YBGreen;
                showOrderPathBtn.layer.cornerRadius = 2.0f;
                [showOrderPathBtn setTitle:@"查看路线" forState:UIControlStateNormal];
                [showOrderPathBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [showOrderPathBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [showOrderPathBtn addTarget:self action:@selector(showOrderPathOnclick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:showOrderPathBtn];
                
                //添加到达交付按钮
                UIButton *orderPayedBtn = [[UIButton alloc] init];
                CGFloat orderPayedX = CGRectGetMaxX(showOrderPathBtn.frame) + btnToBtnSpace;
                CGFloat orderPayedY = CGRectGetMinY(showOrderPathBtn.frame);
                CGFloat orderPayedW = CGRectGetWidth(showOrderPathBtn.frame);
                CGFloat orderPayedH = CGRectGetHeight(showOrderPathBtn.frame);
                [orderPayedBtn setFrame:CGRectMake(orderPayedX, orderPayedY, orderPayedW, orderPayedH)];
                orderPayedBtn.backgroundColor = YBGreen;
                orderPayedBtn.layer.cornerRadius = 2.0f;
                NSString *orderPayedBtnTitle = @"";
                if([_service.order.DRIVER_PAY isEqualToString:@"Y"]) {
                    orderPayedBtnTitle = @"查看签名、图片";
                    [orderPayedBtn addTarget:self action:@selector(checkAutographAndPicture:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else {
                    if([_service.order.DRIVER_PAY isEqualToString:@"N"]) {
                        orderPayedBtnTitle = @"到达交付";
                    }else {
                        orderPayedBtnTitle = @"最终交付";
                    }
                    [orderPayedBtn addTarget:self action:@selector(orderPayedOnclick) forControlEvents:UIControlEventTouchUpInside];
                }
                [orderPayedBtn setTitle:orderPayedBtnTitle forState:UIControlStateNormal];
                [orderPayedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [orderPayedBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                
                [self.view addSubview:orderPayedBtn];
            }else {
                //添加查看路线按钮
                UIButton *showOrderPathBtn = [[UIButton alloc] init];
                CGFloat showOrderPathX = CGRectGetMinX(_orderNoLabel.frame);
                CGFloat showOrderPathY = CGRectGetMaxY(_myTableView.frame);
                CGFloat showOrderPathW = (ScreenWidth - 8 - 8);
                CGFloat showOrderPathH = 35;
                [showOrderPathBtn setFrame:CGRectMake(showOrderPathX, showOrderPathY, showOrderPathW, showOrderPathH)];
                showOrderPathBtn.backgroundColor = YBGreen;
                showOrderPathBtn.layer.cornerRadius = 2.0f;
                [showOrderPathBtn setTitle:@"查看路线" forState:UIControlStateNormal];
                [showOrderPathBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [showOrderPathBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [showOrderPathBtn addTarget:self action:@selector(showOrderPathOnclick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:showOrderPathBtn];
            }
        }
    }else {
        nil;
    }
}

- (void)checkAutographAndPicture:(UIButton *)sender {
    CheckPictureViewController *vc = [[CheckPictureViewController alloc] init];
    vc.orderIDX = _service.order.IDX;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 点击事件
/// 跳转到查看订单线路界面
- (void)showOrderPathOnclick {
    CheckPathViewController *vc = [[CheckPathViewController alloc] init];
    vc.orderIDX = _service.order.IDX;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 跳转到交付订单界面
- (void)orderPayedOnclick {
    PayOrderViewController *vc = [[PayOrderViewController alloc] init];
    vc.orderIDX = _service.order.IDX;
    vc.orderPayState = _service.order.DRIVER_PAY;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    OrderModel *order = _service.order;
    if(order) {
        NSMutableArray *details = order.OrderDetails;
        count = details.count;
    }
    return count;
}

/// 设置 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

/// 设置自定义的 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"OrderDetailsTableViewCell";
    OrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.orderDetail = _service.order.OrderDetails[indexPath.section];
    return cell;
}

@end
