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
#import "CheckOrderPathViewController.h"
#import "PayOrderViewController.h"
#import "AppDelegate.h"
#import "CheckPictureViewController.h"
#import <MapKit/MapKit.h>

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *_app;
}

// 订单编号Label
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

// 订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderNO;

// 承运商名
@property (weak, nonatomic) IBOutlet UILabel *orderIssueName;

// 出库时间
@property (weak, nonatomic) IBOutlet UILabel *orderOutTime;

// 交付状态
@property (weak, nonatomic) IBOutlet UILabel *orderPayStae;

// 司机姓名
@property (weak, nonatomic) IBOutlet UILabel *orderDriverName;

// 司机号码
@property (weak, nonatomic) IBOutlet UILabel *orderDriverPhoneNumber;

// 运输方式
@property (weak, nonatomic) IBOutlet UILabel *orderTransWay;

// 车牌号码
@property (weak, nonatomic) IBOutlet UILabel *orderCarNumber;

// 货物总数
@property (weak, nonatomic) IBOutlet UILabel *orderTotalCount;

// 货物总重
@property (weak, nonatomic) IBOutlet UILabel *orderTotalWeight;

// 省份
@property (weak, nonatomic) IBOutlet UILabel *STATE;

// 城市
@property (weak, nonatomic) IBOutlet UILabel *CITY;

// 地区
@property (weak, nonatomic) IBOutlet UILabel *COUNTY;

// 客户名称
@property (weak, nonatomic) IBOutlet UILabel *customerName;

// 目的地点
@property (weak, nonatomic) IBOutlet UILabel *orderToAddress;

// 货物信息
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation OrderDetailViewController

#pragma mark - 生命周期
- (instancetype)init {
    
    NSLog(@"%s", __func__);
    if(self = [super init]) {
        
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - 功能函数

// 注册Cell
- (void)regisCell {
    
    UINib *n = [UINib nibWithNibName:@"OrderDetailsTableViewCell" bundle:nil];
    [_myTableView registerNib:n forCellReuseIdentifier:@"OrderDetailsTableViewCell"];
    _myTableView.separatorStyle = NO;
}


// 更新界面中的数据
- (void)updataUI:(OrderModel *)order {
    
    _orderNO.text = order.ORD_NO;
    _orderIssueName.text = order.TMS_FLEET_NAME;
    _orderOutTime.text = order.TMS_DATE_ISSUE;
    _orderPayStae.text = [Tools getOrderPayState:order.DRIVER_PAY];
    _orderDriverName.text = order.TMS_DRIVER_NAME;
    _orderDriverPhoneNumber.text = order.TMS_DRIVER_TEL;
    _orderTransWay.text = order.TMS_TYPE_TRANSPORT;
    _orderCarNumber.text = order.TMS_PLATE_NUMBER;
    _orderTotalCount.text = [Tools OneDecimal:order.ORD_QTY];
    _orderTotalWeight.text = [NSString stringWithFormat:@"%@吨", order.ORD_WEIGHT];
    _customerName.text = order.ORD_TO_NAME;
    _orderToAddress.text = order.ORD_TO_ADDRESS;
    _STATE.text = order.STATE;
    _CITY.text = order.CITY;
    _COUNTY.text = order.COUNTY;
}

- (void)mapsSheet:(NSMutableArray *)maps {
    
    UIAlertController *actionSheetC = [UIAlertController alertControllerWithTitle:@"选择地图" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheetC addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil])];
    
    for (int i = 0; i < maps.count; i++) {
        
        [actionSheetC addAction:([UIAlertAction actionWithTitle:maps[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self toMaps:maps[i] andAddress:_service.order.ORD_TO_ADDRESS];
        }])];
    }
    [self presentViewController:actionSheetC animated:YES completion:nil];
}

// 实时导航
- (void)toMaps:(NSString *)type andAddress:(NSString *)address {
    
    if([type isEqualToString:@"苹果自带地图"]) {
        
        // 起点
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        // 终点
        CLGeocoder *geo = [[CLGeocoder alloc] init];
        [geo geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark *endMark=placemarks.firstObject;
            MKPlacemark *mkEndMark=[[MKPlacemark alloc]initWithPlacemark:endMark];
            MKMapItem *endItem=[[MKMapItem alloc]initWithPlacemark:mkEndMark];
            NSDictionary *dict=@{
                                 MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),
                                 MKLaunchOptionsShowsTrafficKey:@(YES)
                                 };
            [MKMapItem openMapsWithItems:@[currentLocation,endItem] launchOptions:dict];\
        }];
    } else if([type isEqualToString:@"高德地图"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=配货易(司机)&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dname=%@&dev=0&t=0", address];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else if([type isEqualToString:@"百度地图"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?destination=%@&mode=driving&coord_type=gcj02", address];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else if([type isEqualToString:@"谷歌地图"]) {
        
        [Tools showAlert:self.view andTitle:@"正在建设中..."];
    }
}

// 猪多重复代码，下个版本修改
// 添加底部按钮，司机有两个按钮（查看路线 到达交付），其它用户只能查看路线
- (void)addBottomBtn {
    
    // 两个按钮之间的距离
    CGFloat btnToBtnSpace = 15;
    
    // 添加查看路线按钮
    UIButton *showOrderPathBtn = [[UIButton alloc] init];
    CGFloat showOrderPathX = CGRectGetMinX(_orderNoLabel.frame);
    CGFloat showOrderPathY = CGRectGetMaxY(_myTableView.frame);
    CGFloat showOrderPathW = (ScreenWidth - 8 - btnToBtnSpace - 8) / 2;
    CGFloat showOrderPathH = 35;
    [showOrderPathBtn setFrame:CGRectMake(showOrderPathX, showOrderPathY, showOrderPathW, showOrderPathH)];
    showOrderPathBtn.backgroundColor = YBGreen;
    showOrderPathBtn.layer.cornerRadius = 2.0f;
    [showOrderPathBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showOrderPathBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:showOrderPathBtn];
    if([_service.order.DRIVER_PAY isEqualToString:@"Y"]) {
        
        [showOrderPathBtn setTitle:@"查看路线" forState:UIControlStateNormal];
        [showOrderPathBtn addTarget:self action:@selector(showOrderPathOnclick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        
        [showOrderPathBtn setTitle:@"实时导航" forState:UIControlStateNormal];
        [showOrderPathBtn addTarget:self action:@selector(navigationOnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
    } else {
        
        if([_service.order.DRIVER_PAY isEqualToString:@"N"]) {
            
            orderPayedBtnTitle = @"到达交付";
        } else if([_service.order.DRIVER_PAY isEqualToString:@"S"]){
            
            orderPayedBtnTitle = @"最终交付";
        }
        [orderPayedBtn addTarget:self action:@selector(orderPayedOnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    [orderPayedBtn setTitle:orderPayedBtnTitle forState:UIControlStateNormal];
    [orderPayedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderPayedBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    [self.view addSubview:orderPayedBtn];
}

- (void)checkAutographAndPicture:(UIButton *)sender {
    CheckPictureViewController *vc = [[CheckPictureViewController alloc] init];
    vc.orderIDX = _service.order.IDX;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 点击事件

// 查看路线
- (void)showOrderPathOnclick {
    
    CheckOrderPathViewController *vc = [[CheckOrderPathViewController alloc] init];
    vc.orderIDX = _service.order.IDX;
    [self.navigationController pushViewController:vc animated:YES];
}


// 交付
- (void)orderPayedOnclick {
    
    if([_app.user.USER_TYPE isEqualToString:@"司机"]) {
        
        PayOrderViewController *vc = [[PayOrderViewController alloc] init];
        vc.orderIDX = _service.order.IDX;
        vc.orderPayState = _service.order.DRIVER_PAY;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        [Tools showAlert:self.view andTitle:@"此功能仅开放于司机"];
    }
}


// 导航
- (void)navigationOnclick {
    
    if([_app.user.USER_TYPE isEqualToString:@"司机"]) {
        
        NSMutableArray *maps = [[NSMutableArray alloc] init];
        [maps addObject:@"苹果自带地图"];
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [maps addObject:@"高德地图"];
        }
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            
            [maps addObject:@"百度地图"];
        }
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"icomgooglemaps://"]]) {
            
            [maps addObject:@"谷歌地图"];
        }
        [self mapsSheet:maps];
    } else {
        
        [Tools showAlert:self.view andTitle:@"此功能仅开放于司机"];
    }
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


// 设置 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}


// 设置自定义的 cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"OrderDetailsTableViewCell";
    OrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.orderDetail = _service.order.OrderDetails[indexPath.section];
    return cell;
}

@end
