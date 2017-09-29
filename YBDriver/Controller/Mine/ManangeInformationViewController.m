//
//  ManangeInformationViewController.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/11.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "ManangeInformationViewController.h"
#import "MyPNPieChart.h"
#import "ManangeInformationService.h"
#import "ManangeInformationModel.h"
#import "Tools.h"
#import "ManangeInformationService.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "LMPickerView.h"

@interface ManangeInformationViewController ()<ManangeInformationServiceDelegate, PNChartDelegate, LMPickerViewDelegate> {
    
    NSDateFormatter *_formatter;
    AppDelegate *_app;
}

// 日期
@property (strong, nonatomic)LMPickerView *LM;

// 时间格式 yyyy-MM-dd
@property (strong, nonatomic) NSDateFormatter *formatter_ss;

// 条形图
@property (weak, nonatomic) IBOutlet UIView *barChartView;

// 条形图Scroll
@property (weak, nonatomic) IBOutlet UIScrollView *barChartScrollView;

// 条形图宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barChartScrollContentWidth;

// 条形图 最大栏宽
@property (assign, nonatomic) CGFloat barItemMaxWidth;

// 饼状图
@property (weak, nonatomic) IBOutlet UIView *picChartView;

// 汇总发货总数
@property (weak, nonatomic) IBOutlet UILabel *outGoodsTotalLabel;

// 条形图底部Lable
@property (strong, nonatomic) NSMutableArray *arrXLabels;

// 选择日期Button
@property (weak, nonatomic) IBOutlet UIButton *selectDate;

// 选择日期
- (IBAction)selectDateOnclick:(UIButton *)sender;

// 饼图标题
@property (weak, nonatomic) IBOutlet UILabel *pieChartTitleLabel;

// 条形图要显示的数据
@property (strong, nonatomic) NSMutableArray *arrYValues;

// 饼状图的颜色
@property (strong, nonatomic) NSArray *pieChartColors;

@property (assign, nonatomic) int outGoodsTotal;

// 饼状图要显示柱状图的哪条柱
@property (assign, nonatomic) int pieChartDataIndex;

@property (strong, nonatomic) NSMutableArray *pieItems;

// 用户选择的时间,默认为当天
@property (copy, nonatomic) NSDate *startDate;

// 用户是否选择了日期
@property (assign, nonatomic) BOOL isSelectedDate;

//
@property (strong, nonatomic) ManangeInformationService *service;

//
@property (strong, nonatomic) MyPNPieChart *pieChartView;

@end

@implementation ManangeInformationViewController

#pragma mark - 生命周期

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.title = @"信息管理";
        self.tabBarItem.image = [UIImage imageNamed:@"menu_manangeInformation_unselected"];
        
        _isSelectedDate = NO;
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _service = [[ManangeInformationService alloc] init];
        _service.delegate = self;
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
        
        _arrXLabels = [[NSMutableArray alloc] init];
        _arrYValues = [[NSMutableArray alloc] init];
        _pieChartColors = [[NSMutableArray alloc] init];
        _pieItems = [[NSMutableArray alloc] init];
        
        UIColor *color1 = [UIColor colorWithRed:239 / 255.0 green:189 / 255.0 blue:20 / 255.0 alpha:1.0];
        UIColor *color2 = [UIColor colorWithRed:190 / 255.0 green:50 / 255.0 blue:44 / 255.0 alpha:1.0];
        UIColor *color3 = [UIColor colorWithRed:244 / 255.0 green:120 / 255.0 blue:49 / 255.0 alpha:1.0];
        _pieChartColors = [NSArray arrayWithObjects:color1, color2, color3, nil];
        
        _pieChartDataIndex = 0;
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
    
    if([Tools isADMINorWLS]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_service.arrM removeAllObjects];
        [_service getManangeInformationData:@""];
    } else {
        
        [self dealData];
    }
    
    _outGoodsTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%d", _outGoodsTotal];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"信息管理";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    _outGoodsTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%d", _outGoodsTotal];
    
    
    [self calculateBarWidth];
    
    
    if([Tools isADMINorWLS]) {
        
    } else {
        
        [self addBarChart];
        [self addPieChartView];
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - 功能函数

- (void)hiddenView {
    
    _barChartView.hidden = YES;
    _picChartView.hidden = YES;
    _outGoodsTotalLabel.hidden = YES;
    _pieChartTitleLabel.hidden = YES;
}


- (void)showView {
    
    _barChartView.hidden = NO;
    _picChartView.hidden = NO;
    _outGoodsTotalLabel.hidden = NO;
    _pieChartTitleLabel.hidden = NO;
}


- (void)calculateBarWidth {
    
    // 根据最大数字计算出条形图，栏的最大宽度
    for (int i = 0; i < _arrM.count; i++) {
        
        ManangeInformationModel *m = _arrM[i];
        
        NSString *qty = [NSString stringWithFormat:@"%d", m.QtyTotal];
        CGFloat width = [Tools getWidthOfString:qty fontSize:11.0];
        if(width > _barItemMaxWidth) {
            
            _barItemMaxWidth = width + 8;
        }
    }
    _barChartScrollContentWidth.constant = (_barItemMaxWidth + 40) * _arrM.count;
    if(_barChartScrollContentWidth.constant < ScreenWidth) {
        
        _barChartScrollContentWidth.constant = ScreenWidth;
    }
}


- (void)addPieChartView {
    
    NSString *centerTitle = [self getPieChartDataWithIndex:_pieChartDataIndex];
    NSArray *items = [_pieItems copy];
    int total = [_arrYValues[_pieChartDataIndex] intValue];
    
    [self addPieChart:items andCenterTitle:[NSString stringWithFormat:@"%@发贷总数：%d", centerTitle, total]];
}


- (NSString *)getPieChartDataWithIndex:(int)index {
    
    [_pieItems removeAllObjects];
    NSString *centerTitle = @"";
    @try {
    ManangeInformationModel *m = _arrM[index];
    centerTitle = m.tms_fllet_name;
        for (int i = 0; i < 3; i++) {
            int value = 0;
            NSString *des = @"";
            if(i == 0) {
                value = m.Ndeliver;
                des = [NSString stringWithFormat:@"未交付:%d", m.Ndeliver];
            }else if(i == 1) {
                value = m.Adeliver;
                des = [NSString stringWithFormat:@"已交付:%d", m.Adeliver];
            }else if(i == 2) {
                value = m.Arrive;
                des = [NSString stringWithFormat:@"已到达:%d", m.Arrive];
            }
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value color:_pieChartColors[i] description:des];
            [_pieItems addObject:item];
        }
    } @catch (NSException *exception) {
        
        [Tools showAlert:self.view andTitle:@"服务器数据异常"];
    }
    
    return centerTitle;
}


// 处理数据
- (void)dealData {
    
    [_arrXLabels removeAllObjects];
    [_arrYValues removeAllObjects];
    _outGoodsTotal = 0;
    for (int i = 0; i < _arrM.count; i++) {
        
        ManangeInformationModel *model = _arrM[i];
        [_arrXLabels addObject:model.tms_fllet_name];
        [_arrYValues addObject:@(model.QtyTotal)];
        _outGoodsTotal += model.QtyTotal;
    }
}


- (void)addBarChart {
    
    //如果_arrYValues.count == 0，程序会崩溃
    if(_arrYValues.count == 0) {
        [Tools showAlert:self.view andTitle:@"没有数据"];
        return;
    }
    
    [_barChartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.view layoutIfNeeded];
    
    // For BarC hart
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:_barChartView.bounds];
    barChart.delegate = self;
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
    [_barChartView addSubview:barChart];
}

- (void)addPieChart:(NSArray *)items andCenterTitle:(NSString *)centerTitle {
    
    [_pieChartView removeFromSuperview];
    
    // 中心Label
    UILabel *centerLabel = nil;
    
    // For Pie Chart
    _pieChartView = [[MyPNPieChart alloc] initWithFrame:_picChartView.bounds items:items];
    
    centerLabel = [[UILabel alloc] init];
    centerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    centerLabel.numberOfLines = 0;
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.font = [UIFont systemFontOfSize:11];
    [centerLabel setBounds:CGRectMake(0, 0, _pieChartView.innerCircleRadius * 2 - 8, _pieChartView.innerCircleRadius * 2)];
    [centerLabel setCenter:CGPointMake(CGRectGetWidth(_picChartView.frame) / 2, CGRectGetHeight(_picChartView.frame) / 2)];
    centerLabel.text = centerTitle;
    
    _pieChartView.descriptionTextColor = [UIColor whiteColor];
    _pieChartView.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    _pieChartView.duration = 2.0;
    _pieChartView.showOnlyValues = YES;
    [_pieChartView strokeChart];
    [_pieChartView addSubview:centerLabel];
    [_picChartView addSubview:_pieChartView];
    
    //移除_picChartView里的UIView视图
    NSArray *picChartViewArr = _picChartView.subviews;
    
    for (int i = 0; i < picChartViewArr.count; i++) {
        UIView *v = picChartViewArr[i];
        if([v isMemberOfClass:[UIView class]]) {
            [v removeFromSuperview];
        }
    }
    
    _pieChartView.legendStyle = PNLegendItemStyleStacked;
    UIView *legend = [_pieChartView getLegendWithMaxWidth:200];
    CGFloat legendW = CGRectGetWidth(legend.frame);
    CGFloat legendX = CGRectGetWidth(_picChartView.frame) - legendW + CGRectGetMinX(_picChartView.frame) - 3;
    [legend setFrame:CGRectMake(legendX, 0, legendW, CGRectGetHeight(legend.frame))];
    [_picChartView addSubview:legend];
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
        [_service.arrM removeAllObjects];
        [_service getManangeInformationData:time];
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


#pragma mark - ManangeInformationServiceDelegate

- (void)success {
    
    [self showView];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _arrM = _service.arrM;
    
    [self calculateBarWidth];
    
    _pieChartDataIndex = 0;
    [self dealData];
    
    [self addBarChart];
    [self addPieChartView];
    _outGoodsTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%d", _outGoodsTotal];
}


- (void)failure:(NSString *)msg {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg ? msg : @"请求失败"];
    [self hiddenView];
}


#pragma mark - PNChartDelegate

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex {
    
    _pieChartDataIndex = (int)barIndex;
    [self addPieChartView];
}

@end