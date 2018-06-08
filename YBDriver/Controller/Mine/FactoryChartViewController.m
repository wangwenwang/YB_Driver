//
//  FactoryChartViewController.m
//  YBDriver
//
//  Created by KDYMACBOOK on 2018/6/1.
//  Copyright © 2018年 凯东源. All rights reserved.
//

#import "FactoryChartViewController.h"
#import "FactoryChartService.h"
#import "FactoryChartModel.h"
#import <MBProgressHUD.h>
#import "LMPickerView.h"
#import "AppDelegate.h"
#import "PNPieChart.h"
#import "PNBarChart.h"
#import "Tools.h"

@interface FactoryChartViewController ()<FactoryChartServiceDelegate, LMPickerViewDelegate>{
    
    NSDateFormatter *_formatter;
    AppDelegate *_app;
}

// 日期
@property (strong, nonatomic)LMPickerView *LM;
// 时间格式 yyyy-MM-dd
@property (strong, nonatomic) NSDateFormatter *formatter_ss;
// 选择日期Button
@property (weak, nonatomic) IBOutlet UIButton *selectDate;
// 选择日期
- (IBAction)selectDateOnclick:(UIButton *)sender;
// 用户选择的时间,默认为当天
@property (copy, nonatomic) NSDate *startDate;
// 用户是否选择了日期
@property (assign, nonatomic) BOOL isSelectedDate;
// 时间筛选容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectDateViewHeight;

// 页面高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeight;
@property (strong, nonatomic) FactoryChartService *service;
@property (strong, nonatomic) NSArray *factorys;

// 饼状图
@property (weak, nonatomic) IBOutlet UIView *PieChartSuperView;
// 容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PieChartSuperViewHeight;
// 饼状图文字高度
@property (assign, nonatomic) NSUInteger pieTextHeight;


// 承运商发货数量条形图
@property (weak, nonatomic) IBOutlet UIView *BarChartView;
// 条形图宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barChartScrollContentWidth;
// 条形图 最大栏宽
@property (assign, nonatomic) CGFloat barItemMaxWidth;
// 条形图底部Lable
@property (strong, nonatomic) NSMutableArray *arrXLabels;
// 条形图要显示的数据
@property (strong, nonatomic) NSMutableArray *arrYValues;
// 条形图汇总发货总数
@property (assign, nonatomic) long long qtyTotal;
// 汇总发货总数
@property (weak, nonatomic) IBOutlet UILabel *qtyTotalLabel;
// 条形图容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barChartViewHeight;

@end


// 承运商饼图长宽
#define kGCPieChartWH 200
// 顶部文字高度
#define kGCPieChartTopText 40

@implementation FactoryChartViewController

#pragma mark - 生命周期
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.tabBarItem.image = [UIImage imageNamed:@"menu_manangeInformation_unselected"];
        
        _isSelectedDate = NO;
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _service = [[FactoryChartService alloc] init];
        _service.delegate = self;
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
        
        _arrXLabels = [[NSMutableArray alloc] init];
        _arrYValues = [[NSMutableArray alloc] init];
        
        _startDate = [NSDate date];
        _formatter_ss = [[NSDateFormatter alloc] init];
        [_formatter_ss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _LM = [[LMPickerView alloc] init];
        _LM.delegate = self;
        [_LM initDatePicker];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"工厂管理信息";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if([Tools isConnectionAvailable]) {
        
        [_service getFactoryChart:@""];
    }else {
        [Tools showAlert:self.view andTitle:@"网络不可用"];
    }
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];

    _scrollContentViewHeight.constant = _selectDateViewHeight.constant + _PieChartSuperViewHeight.constant + _barChartViewHeight.constant;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - 功能函数

- (void)addPieChart {
    
    //移除GCPieChartSuperView里的UIView视图
    NSArray *GCPieChartSuperViewArr = self.PieChartSuperView.subviews;
    
    for (int i = 0; i < GCPieChartSuperViewArr.count; i++) {
        UIView *v = GCPieChartSuperViewArr[i];
        [v removeFromSuperview];
    }
    
    NSArray *colors = [Tools getChartColor];
    NSMutableArray *muArrM = [[NSMutableArray alloc] init];
    for(int i = 0; i < _factorys.count; i++) {
        
        FactoryChartModel *m = _factorys[i];
        // 除数不能为0
        long long qtyTotal = _qtyTotal ? _qtyTotal : 1;
        NSString *desc = [NSString stringWithFormat:@"%@  数量:%lld  占比:%.1f%%", m.ship_from_name, m.QtyTotal, (m.QtyTotal * 1.0 / qtyTotal) * 100];
        [muArrM addObject:[PNPieChartDataItem dataItemWithValue:m.QtyTotal color:colors[i] description:desc]];
    
        // 计算所有物流商名称高度
        CGFloat tmsFlletNameWidth = [Tools getHeightOfString:desc andFont:[UIFont fontWithName:@"Avenir-Medium" size:12.0] andWidth:(ScreenWidth - 12)];
        tmsFlletNameWidth ? tmsFlletNameWidth : [Tools getHeightOfString:@"fds" andFont:[UIFont fontWithName:@"Avenir-Medium" size:12.0] andWidth:(ScreenWidth - 12)]; // 防止 tms_fllet_name 为空时，tmsFlletNameWidth 为 0
        self.pieTextHeight += tmsFlletNameWidth;
    }
    self.pieTextHeight += 30;
    [self updateViewConstraints];
    NSArray *items = [muArrM copy];
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((ScreenWidth - kGCPieChartWH) / 2, kGCPieChartTopText, kGCPieChartWH, kGCPieChartWH) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.showOnlyValues = YES;
    [pieChart strokeChart];
    
    pieChart.legendStyle = PNLegendItemStyleStacked;
    pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [pieChart getLegendWithMaxWidth:(ScreenWidth - (ScreenWidth - kGCPieChartWH) / 2)];
    [legend setFrame:CGRectMake((ScreenWidth - kGCPieChartWH) / 2, kGCPieChartTopText + kGCPieChartWH + 12, legend.frame.size.width, legend.frame.size.height)];
    [self.PieChartSuperView addSubview:legend];
    
    [self.PieChartSuperView addSubview:pieChart];
}


// 处理数据
- (void)dealData {
    
    @try {
        [_arrXLabels removeAllObjects];
        [_arrYValues removeAllObjects];
        _qtyTotal = 0;
        for (int i = 0; i < _factorys.count; i++) {
            
            FactoryChartModel *m = _factorys[i];
            [_arrXLabels addObject:m.ship_from_name];
            [_arrYValues addObject:@(m.QtyTotal)];
            _qtyTotal += m.QtyTotal;
        }
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    } @finally {
        
        NSLog(@"@finally");
    }
}


- (void)addBarChart {
    
    //如果_arrYValues.count == 0，程序会崩溃
    if(_arrYValues.count == 0) {
        [Tools showAlert:self.view andTitle:@"没有数据"];
        return;
    }
    
    [_BarChartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.view layoutIfNeeded];
    
    // For BarC hart
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:_BarChartView.bounds];
    barChart.yChartLabelWidth = 35.0;
    barChart.chartMarginLeft = 45.0;
    barChart.chartMarginRight = 10.0;
    barChart.chartMarginTop = 7.0;
    barChart.chartMarginBottom = 17.0;
    barChart.barWidth = _barItemMaxWidth;
    
    barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%zi", (NSUInteger)value];
    };
    
    barChart.showChartBorder = YES;
    
    [barChart setXLabels:_arrXLabels];
    //    [barChart setYLabels:@[@"500" ,@"1000" ,@"1500"]];
    [barChart setYValues:_arrYValues];
    
    [barChart strokeChart];
    [_BarChartView addSubview:barChart];
}


#pragma mark - 点击事件

- (IBAction)selectDateOnclick:(UIButton *)sender {
    
    NSDate *maxDate = [_formatter_ss dateFromString:[Tools getCurrentBeforeDate_Second:0]];
    
    [self createDatePicker:maxDate];
}


#pragma mark - 时间模块

- (void)PickerViewComplete:(NSDate *)date {
    
    _startDate = date;
    
    NSString *time = [_formatter stringFromDate:date];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([Tools isConnectionAvailable]) {
        
        _barItemMaxWidth = 0;
        [_service getFactoryChart:time];
    } else {
        
        [Tools showAlert:self.view andTitle:@"网络不可用"];
    }
    _isSelectedDate = YES;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_startDate];
    
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    
    if(_isSelectedDate) {
        
        NSString *showTime = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)year, (long)month, (long)day];
        [_selectDate setTitle:showTime forState:UIControlStateNormal];
    }
}


- (void)createDatePicker:maxDate {
    
    _LM.maximumDate = maxDate;
    [_LM showDatePicker];
}


#pragma mark - FactoryChartServiceDelegate
- (void)successOfFactoryChart:(NSArray *)factorys {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _factorys = factorys;
    // 处理数据
    [self dealData];
    // 添加饼状图
    [self addPieChart];
    // 添加条形图
    [self addBarChart];
    // 更新汇总数量
    _qtyTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%lld", _qtyTotal];
}

- (void)failureOfFactoryChart:(NSString *)msg {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg ? msg : @"请求失败"];
}

@end
