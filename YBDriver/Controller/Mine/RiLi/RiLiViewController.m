//
//  RiLiViewController.m
//  ChuangYunClientProject
//
//  Created by Eric on 2017/5/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "RiLiViewController.h"
#import "ZYCalendarView.h"
#import "UIColor+NotRGB.h"
#import "Tools.h"
@interface RiLiViewController ()
@property(nonatomic,retain)NSString *startTime;
@property(nonatomic,retain)NSString *endTime;

@end

@implementation RiLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)setUI{
    
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame = CGRectMake(0, 0, 70, 30);
    butt.titleLabel.font = [UIFont systemFontOfSize:14];
    [butt setTitle:@"取消选择" forState:UIControlStateNormal];
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:butt];
    self.navigationItem.rightBarButtonItem = right;

    self.navigationItem.leftBarButtonItem.image =
    [[UIImage imageNamed:@"关闭2"]imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.title = @"选择日期";
    UIView *weekTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self.view addSubview:weekTitlesView];
    CGFloat weekW = ScreenWidth/7;
    NSArray *titles = @[@"日", @"一", @"二", @"三",
                        @"四", @"五", @"六"];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(i*weekW, 20, weekW, 44)];
        week.textAlignment = NSTextAlignmentCenter;
        if (i == 0 || i==6) {
            week.textColor = ZYHEXCOLOR(0x4562e9);
        }else{
        week.textColor = ZYHEXCOLOR(0x666666);
        }
        [weekTitlesView addSubview:week];
        week.text = titles[i];
    }
    
    
    ZYCalendarView *view = [[ZYCalendarView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-76-64)];
    
    // 不可以点击以后的日期
    view.manager.canSelectPastDays = false;
    // 可以选择时间段
    view.manager.selectionType = ZYCalendarSelectionTypeRange;
    // 设置当前日期
    view.date = [NSDate date];
    
    view.dayViewBlock = ^(ZYCalendarManager *manager, NSDate *dayDate) {
        // NSLog(@"%@", dayDate);
        for (NSDate *date in manager.selectedDateArray) {
            NSLog(@"%@", [manager.dateFormatter stringFromDate:date]);
        }
        NSDate *start = manager.selectedDateArray[0];
        self.startTime =  [manager.dateFormatter stringFromDate:start];
        if (manager.selectedDateArray.count > 1) {
            NSDate *end = manager.selectedDateArray[1];
            self.endTime =  [manager.dateFormatter stringFromDate:end];
        }
        printf("\n");
    };
    [self.view addSubview:view];

}
-(void)handleCancel{
    self.selectDate(nil,nil);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)handleConfirm:(id)sender {
    if (self.startTime == nil && self.endTime == nil) {
        [Tools showAlert:self.view andTitle:@"请选择时间"];
        return;
    }
    if (self.startTime == nil) {
        self.startTime = self.endTime;
    }
    if (self.endTime == nil) {
        self.endTime = self.startTime;
    }
    if (self.selectDate != nil) {
        self.selectDate(self.startTime,self.endTime);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
