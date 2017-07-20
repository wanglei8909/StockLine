//
//  MACD.m
//  HNNniu
//
//  Created by wanglei on 2017/7/17.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "MACD.h"
#import "WLLineEntity.h"

#define SHORT_PERIOD 12
#define LONG_PERIOD 26
#define MID_PERIOD 9

@implementation MACD

- (NSArray *)getEXPMA:(NSArray *)klineArray days:(NSInteger)days {
    NSInteger count = klineArray.count;
    
    NSMutableArray *expArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    float k = 2.f / (days + 1.f);
    float ema = [klineArray[0] floatValue];
    
    [expArray addObject:@(ema)];
    
    for (NSInteger i = 1; i < count; i++) {
        ema = [klineArray[i] floatValue] * k + ema * (1.f - k);
        [expArray addObject:@(ema)];
    }
    return [expArray copy];
}

- (NSArray *)getEXPMAFromKline:(NSArray *)kLineArray days:(NSInteger)days {
    NSInteger count = kLineArray.count;
    
    NSMutableArray *expArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    CGFloat k = 2.f / (days + 1.f);
    CGFloat ema = [(WLLineEntity *)kLineArray[0] close];
    [expArray addObject:@(ema)];
    
    for (NSInteger i = 1; i < count; i++) {
        ema = [(WLLineEntity *)kLineArray[i] close] * k + ema * (1.f - k);
        [expArray addObject:@(ema)];
    }
    return [expArray copy];
}

- (void)calculate {
    if (!_linesArray) {
        return;
    }
    NSInteger count = _linesArray.count;
    
    NSArray *shortPeriodArray =
    [self getEXPMAFromKline:_linesArray days:SHORT_PERIOD];
    NSArray *longPeriodArray =
    [self getEXPMAFromKline:_linesArray days:LONG_PERIOD];
    NSMutableArray *diffArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        float dif =
        [shortPeriodArray[i] floatValue] - [longPeriodArray[i] floatValue];
        [diffArray addObject:@(dif)];
    }
    
    NSArray *deaArray = [self getEXPMA:diffArray days:MID_PERIOD];
    
    for (NSInteger i = 0; i < count; i++) {
        float dif = [diffArray[i] floatValue];
        float dea = [deaArray[i] floatValue];
        float macd = (dif - dea) * 2.f;
        
        MACDPoint *point = [[MACDPoint alloc] init];
        point.dif = [KLineUtil roundUp3:dif];
        point.dea = [KLineUtil roundUp3:dea];
        point.macd = [KLineUtil roundUp3:macd];
        point.date = [(WLLineEntity *)_linesArray[i] date];
        [_pointsArray addObject:point];
    }
}

+ (NSArray *)getMACDPoints:(NSArray *)kLineArray {
    MACD *macd = [[MACD alloc] init];
    macd.pointsArray = [[NSMutableArray alloc] initWithCapacity:kLineArray.count];
    macd.linesArray = kLineArray;
    [macd calculate];
    return [macd.pointsArray copy];
}

@end

@implementation MACDPoint

- (CGFloat)getMaxValue{
    CGFloat max = MAX(ABS(self.dea), ABS(self.dif));
    max = MAX(ABS(max), ABS(self.macd));
    return max;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%f,%f,%f",self.dif,self.dea,self.macd];
}

@end



