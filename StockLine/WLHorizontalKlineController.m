//
//  WLHorizontalKlineController.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLHorizontalKlineController.h"
#import "WLTimeLineView.h"
#import "WLLineEntity.h"
#import "WLKLineView.h"
#import "WLLineEntity.h"
#import "HKLineRightView.h"

#define WeakObj(obj) autoreleasepool{} __weak typeof(obj) weakSelf = obj;

#define StrongObj(obj) autoreleasepool{} __strong typeof(obj) strongSelf = obj;

@interface WLHorizontalKlineController ()<WLLineViewBaseDelegate>

@property (nonatomic, strong) WLTimeLineView *timeLineView;
@property (nonatomic, strong) WLKLineView *klineView;
@property (nonatomic, strong) HKLineRightView *lineRightControl;


@end

@implementation WLHorizontalKlineController

- (HKLineRightView *)lineRightControl{
    if (!_lineRightControl) {
        _lineRightControl = [[HKLineRightView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 60, 70, self.view.frame.size.height - 45)];
        @WeakObj(self);
        _lineRightControl.clickBlock = ^(NSInteger index){
            if (index == 0) {

            }else if (index == 1){

            }else if (index == 2){

            }else if (index == 3){
                [weakSelf.klineView setLineType:KlineBottomType_VOL];
            }else if (index == 4){
                [weakSelf.klineView setLineType:KlineBottomType_BOLL];
            }else if (index == 5){
                [weakSelf.klineView setLineType:KlineBottomType_MACD];
            }else if (index == 6){
                [weakSelf.klineView setLineType:KlineBottomType_KDJ];
            }else if (index == 7){
                [weakSelf.klineView setLineType:KlineBottomType_RSI];
            }else if (index == 8){
                [weakSelf.klineView setLineType:KlineBottomType_OBV];
            }else if (index == 9){
                [weakSelf.klineView setLineType:KlineBottomType_WR];
            }
        };
        [self.view addSubview:_lineRightControl];
    }
    return _lineRightControl;
}

- (void)setLineViewType:(WLShowHightLightViewShowType )lineViewType{
    if (lineViewType == WLShowHightLightView_Time) {
        self.timeLineView.hidden        = NO;
        self.lineRightControl.hidden    = YES;
        [self loadTimeLineData];
    }else{
        self.klineView.hidden           = NO;
        self.lineRightControl.hidden    = NO;
        [self loadKlineStr];
        
    }
    _lineViewType = lineViewType;
}

- (WLKLineView *)klineView{
    if (!_klineView) {
        _klineView = [[WLKLineView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width - 80, self.view.frame.size.height - 30)];
        [_klineView setupChartOffsetWithLeft:60 top:30 right:0 bottom:15];
        _klineView.gridBackgroundColor = [UIColor whiteColor];
        _klineView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
        _klineView.borderWidth = .5;
        _klineView.uperChartHeightScale = 0.65;
        _klineView.xAxisHeitht = 20;
        _klineView.delegate = self;
        _klineView.candleWidth = 8;
        _klineView.candleMaxWidth = 25;
        _klineView.candleMinWidth = 1;
        [self.view addSubview:_klineView];

    }
    return _klineView;
}

- (WLTimeLineView *)timeLineView{
    if (!_timeLineView) {
        _timeLineView = [[WLTimeLineView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width - 80, self.view.frame.size.height - 30)];
        [_timeLineView setupChartOffsetWithLeft:60 top:30 right:0 bottom:10];
        _timeLineView.gridBackgroundColor = [UIColor whiteColor];
        _timeLineView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
        _timeLineView.borderWidth = .5;
        _timeLineView.uperChartHeightScale = 0.7;
        _timeLineView.xAxisHeitht = 27;
        _timeLineView.endPointShowEnabled = YES;
        _timeLineView.delegate = self;
        [self.view addSubview:_timeLineView];
    }
    return _timeLineView;
}
//

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.transform =  CGAffineTransformMakeRotation(M_PI*0.5);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width - 60, 10, 40, 30);
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadKlineStr{
    NSString * path =[[NSBundle mainBundle]pathForResource:@"data.plist" ofType:nil];
    NSArray * sourceArray = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"data"];
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary * dic in sourceArray) {
        
        WLLineEntity * entity = [[WLLineEntity alloc]init];
        entity.high = [dic[@"high_px"] doubleValue];
        entity.open = [dic[@"open_px"] doubleValue];
        
        entity.low = [dic[@"low_px"] doubleValue];
        
        entity.close = [dic[@"close_px"] doubleValue];
        
        entity.date = dic[@"date"];
        entity.ma5 = [dic[@"avg5"] doubleValue];
        entity.ma10 = [dic[@"avg10"] doubleValue];
        entity.ma20 = [dic[@"avg20"] doubleValue];
        entity.volume = [dic[@"total_volume_trade"] doubleValue];
        [array addObject:entity];
        //YTimeLineEntity * entity = [[YTimeLineEntity alloc]init];
    }
    [array addObjectsFromArray:array];
    [self.klineView setMDataArray:[array copy]];
}


-(void)loadTimeLineData{
    NSString * path =[[NSBundle mainBundle]pathForResource:@"data.plist" ofType:nil];
    
    NSArray * sourceArray = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"data3"];
    NSMutableArray * timeArray = [NSMutableArray array];
    for (NSDictionary * dic in sourceArray) {
        WLTimeLineEntity * e = [[WLTimeLineEntity alloc]init];
        e.currtTime = dic[@"curr_time"];
        e.preClosePx = [dic[@"pre_close_px"] doubleValue];
        e.avgPirce = [dic[@"avg_pirce"] doubleValue];
        e.lastPirce = [dic[@"last_px"]doubleValue];
        e.volume = [dic[@"last_volume_trade"]doubleValue];
        [timeArray addObject:e];
    }
    self.timeLineView.dataArray = timeArray;
}

//  lineView dalegate
- (void)chartViewDidSelected:(WLKLineBase *)chartView{
    
}

- (void)chartValueSelected:(WLKLineBase *)chartView entry:(id)entry entryIndex:(NSInteger)entryIndex{

}

- (void)chartViewDidUnselected:(WLKLineBase *)chartView{
    
    
}

- (CGFloat)getMA:(NSArray *)array type:(CGFloat)index{
    CGFloat ma = 0;
    for (int i = 0; i < array.count; i ++) {
        WLLineEntity *entity = [array objectAtIndex:i];
        ma += entity.close;
    }
    return ma/index;
}

- (CGFloat)getVolMA:(NSArray *)array type:(CGFloat)index{
    CGFloat ma = 0;
    for (int i = 0; i < array.count; i ++) {
        WLLineEntity *entity = [array objectAtIndex:i];
        ma += entity.volume;
    }
    return ma/index;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
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
