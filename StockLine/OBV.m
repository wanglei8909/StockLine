//
//  OBV.m
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "OBV.h"
#import "WLLineEntity.h"

#define DEFAULT_PERIOD 30

@implementation OBV

- (NSArray *)calcOBV:(NSArray *)klineArray {
    NSInteger count = klineArray.count;
    NSMutableArray *obvArray = [[NSMutableArray alloc] initWithCapacity:count];
    float preClose = 0.f;
    int64_t obv = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        float close = [(WLLineEntity *)klineArray[i] close];
        int64_t vol = [(WLLineEntity *)klineArray[i] volume];
        
        if (i == 0) {
            obv -= vol;
        } else if (close > preClose) {
            obv += vol;
        } else if (close < preClose) {
            obv -= vol;
        }
        
        preClose = close;
        
        [obvArray addObject:@(obv)];
    }
    
    return [obvArray copy];
}

- (NSArray *)calcMA:(NSArray *)obvArray {
    NSInteger count = obvArray.count;
    
    NSMutableArray *maArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        
        if (i < DEFAULT_PERIOD - 1) {
            
            [maArray addObject:[NSNull null]];
            
        } else {
            
            int from = (int)i - DEFAULT_PERIOD + 1; // 29
            if (from < 0) {
                from = 0;
            }
            
            int64_t sum = 0;
            
            for (NSInteger j = from; j <= i; j++) { // 0
                NSNumber *obv = obvArray[j];
                
                if (![obv isEqual:[NSNull null]]) {
                    sum += obv.longLongValue;
                }
            }
            int64_t ma = sum / DEFAULT_PERIOD;
            [maArray addObject:@(ma)];
        }
    }
    return [maArray copy];
}

- (void)calculate {
    if (!_klineArray) {
        return;
    }
    
    NSInteger count = _klineArray.count;
    
    NSArray *obvArray = [self calcOBV:_klineArray];
    NSArray *maArray = [self calcMA:obvArray];
    
    for (NSInteger i = 0; i < count; i++) {
        CGFloat obv = 0;
        CGFloat ma = 0;
        if (![obvArray[i] isKindOfClass:[NSNull class]]) {
            obv = [obvArray[i] floatValue];
        }
        if (![maArray[i] isKindOfClass:[NSNull class]]) {
            ma = [maArray[i] floatValue];
        }
        OBVPoint *point = [[OBVPoint alloc] initWithObv:obv maObv:ma];
        [_pointsArray addObject:point];
    }
}

+ (NSArray *)getOBVPoints:(NSArray *)klineArray {
    OBV *obv = [[OBV alloc] init];
    obv.pointsArray = [[NSMutableArray alloc] initWithCapacity:klineArray.count];
    obv.klineArray = klineArray;
    [obv calculate];
    return [obv.pointsArray copy];
}

@end

@implementation OBVPoint

- (instancetype)initWithObv:(CGFloat)obv maObv:(CGFloat)maObv {
    if (self = [super init]) {
        self.obv = obv;
        self.maObv = maObv;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%f,%f",self.obv,self.maObv];
}

@end

