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

@interface ManangeInformationViewController ()<ManangeInformationServiceDelegate, PNChartDelegate> {
    NSDateFormatter *_formatter;
    AppDelegate *_app;
}

//条形图
@property (weak, nonatomic) IBOutlet UIView *barChartView;

//饼状图
@property (weak, nonatomic) IBOutlet UIView *picChartView;

//汇总发货总数
@property (weak, nonatomic) IBOutlet UILabel *outGoodsTotalLabel;

//条形图底部Lable
@property (strong, nonatomic) NSMutableArray *arrXLabels;

/// 选择日期Button
@property (weak, nonatomic) IBOutlet UIButton *selectDate;

//选择日期
- (IBAction)selectDateOnclick:(UIButton *)sender;

//饼图标题
@property (weak, nonatomic) IBOutlet UILabel *pieChartTitleLabel;

//条形图要显示的数据
@property (strong, nonatomic) NSMutableArray *arrYValues;

//饼状图的颜色
@property (strong, nonatomic) NSArray *pieChartColors;

@property (assign, nonatomic) int outGoodsTotal;

//饼状图要显示柱状图的哪条柱
@property (assign, nonatomic) int pieChartDataIndex;

@property (strong, nonatomic) NSMutableArray *pieItems;

/// 显示时间选择器控件
@property (strong, nonatomic) UIView *coView;

/// 用户选择的时间,默认为当天
@property (copy, nonatomic) NSDate *startDate;

/// 用户是否选择了日期
@property (assign, nonatomic) BOOL isSelectedDate;

///
@property (strong, nonatomic) ManangeInformationService *service;

///
@property (strong, nonatomic) MyPNPieChart *pieChartView;

///时间选择器是否弹出
@property (assign, nonatomic) BOOL isShowDatePicker;

@end

@implementation ManangeInformationViewController

#pragma mark -- 生命周期
- (instancetype)init {
    NSLog(@"%s", __func__);
    self = [super init];
    if (self) {
        self.title = @"信息管理";
        self.tabBarItem.image = [UIImage imageNamed:@"menu_manangeInformation_unselected"];
        
        _isShowDatePicker = NO;
        _isSelectedDate = NO;
        _app = [[UIApplication sharedApplication] delegate];
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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    if([Tools isADMINorWLS]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_service.arrM removeAllObjects];
        [_service getManangeInformationData:@""];
    }else {
        [self dealData];
    }
    
    _outGoodsTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%d", _outGoodsTotal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
    
    self.navigationController.navigationBar.topItem.title = @"信息管理";
    UIColor *color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    if([Tools isADMINorWLS]) {
        
    }else {
        [self addBarChart];
        [self addPieChartView];
    }

    _outGoodsTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%d", _outGoodsTotal];
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
    } @finally {
        nil;
    }
    
    return centerTitle;
}

/// 处理数据
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
    
    NSLog(@"");
    
    
}

- (void)addBarChart {
    //For BarC hart
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:_barChartView.bounds];
    barChart.delegate = self;
    barChart.yChartLabelWidth = 35.0;
    barChart.chartMarginLeft = 45.0;
    barChart.chartMarginRight = 10.0;
    barChart.chartMarginTop = 7.0;
    barChart.chartMarginBottom = 17.0;
    
    barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%zi", (NSUInteger)value];
    };
    
    
    
    //    /*
    //     *画实线
    //     */
    //    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    //    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    //    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    //    [solidShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    //    solidShapeLayer.lineWidth = 2.0f ;
    //    CGPathMoveToPoint(solidShapePath, NULL, 20, 265);
    //    CGPathAddLineToPoint(solidShapePath, NULL, 300,265);
    //    CGPathAddLineToPoint(solidShapePath, NULL, 300,50);
    //    [solidShapeLayer setPath:solidShapePath];
    //    CGPathRelease(solidShapePath);
    
    barChart.showChartBorder = YES;
    
    [barChart setXLabels:_arrXLabels];
    //    [barChart setYLabels:@[@"500" ,@"1000" ,@"1500"]];
    [barChart setYValues:_arrYValues];
    
    [barChart strokeChart];
    [_barChartView addSubview:barChart];
}

- (void)addPieChart:(NSArray *)items andCenterTitle:(NSString *)centerTitle {
    
    [_pieChartView removeFromSuperview];
    
    //中心Label
    UILabel *centerLabel = nil;
    
    //For Pie Chart
    //    if(!_pieChartView) {
    _pieChartView = [[MyPNPieChart alloc] initWithFrame:_picChartView.bounds items:items];
//    _pieChartView.delegate = self;
    
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
        NSLog(@"_____:%@", [v class]);
    }
    
    _pieChartView.legendStyle = PNLegendItemStyleStacked;
    UIView *legend = [_pieChartView getLegendWithMaxWidth:200];
    CGFloat legendW = CGRectGetWidth(legend.frame);
    CGFloat legendX = CGRectGetWidth(_picChartView.frame) - legendW + CGRectGetMinX(_picChartView.frame) - 3;
    [legend setFrame:CGRectMake(legendX, 0, legendW, CGRectGetHeight(legend.frame))];
    [_picChartView addSubview:legend];
    //    }else {
    //        [_pieChartView updateChartData:items];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            centerLabel.text = centerTitle;
    //        });
    //    }
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
    datePicker.date = _startDate;
    
    //注意：action里面的方法名后面需要加个冒号“：”
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_coView addSubview:datePicker];
    _isShowDatePicker = YES;
}

#pragma mark -- 点击事件
- (IBAction)selectDateOnclick:(UIButton *)sender {
    [self createDatePicker];
}

/// 时间选择器点击取消按钮
- (void)cancelButtonClick:(UIButton *)sender {
    [_coView removeFromSuperview];
    _isShowDatePicker = NO;
}

// 日期选择器响应方法
- (void)dateChanged:(UIDatePicker *)datePicker {
    _startDate = datePicker.date;
}

/// 时间选择器点击了确定按钮
- (void)sureButtonClick:(UIButton *)sender {
    NSString *time = [_formatter stringFromDate:_startDate];
    [_coView removeFromSuperview];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if([Tools isConnectionAvailable]) {
        [_service.arrM removeAllObjects];
        [_service getManangeInformationData:time];
    }else {
        [Tools showAlert:self.view andTitle:@"网络不可用"];
    }
    NSLog(@"startDate:%@", _startDate);
    _isShowDatePicker = NO;
    _isSelectedDate = YES;
}

#pragma mark -- ManangeInformationServiceDelegate
- (void)success {
    [self showView];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _arrM = _service.arrM;
    _pieChartDataIndex = 0;
    [self dealData];
    
    [self addBarChart];
    [self addPieChartView];
    _outGoodsTotalLabel.text = [NSString stringWithFormat:@"汇总发货总数：%d", _outGoodsTotal];
    
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

- (void)failure:(NSString *)msg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Tools showAlert:self.view andTitle:msg ? msg : @"请求失败"];
    [self hiddenView];
}

#pragma mark -- PNChartDelegate
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex {
    NSLog(@"userClickedOnBarAtIndex%ld", (long)barIndex);
    _pieChartDataIndex = (int)barIndex;
    [self addPieChartView];
}

@end
