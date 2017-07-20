//
//  WLLineEntity.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLLineEntity.h"

@implementation WLLineEntity



- (instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.date       = [self getTime:[array[0] integerValue]];
        self.open       = [array[2] floatValue];
        self.high       = [array[3] floatValue];
        self.low        = [array[4] floatValue];
        self.close      = [array[5] floatValue];
        self.volume     = [array[6] floatValue];
        self.volueRate  = [array[7] floatValue];
    }
    return self;
}

- (NSString *)getTime:(NSInteger )time{
    NSString *tString = [NSString stringWithFormat:@"%ld",time];
    NSString *year, *day, *month;
    year = [tString substringToIndex:4];
    day = [tString substringWithRange:NSMakeRange(tString.length - 2, 2)];
    month = [tString substringWithRange:NSMakeRange(4, tString.length - 2 - 4)];
    if (time > 9999999) {
        
    }else{
        
    }
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

@end

@implementation WLTimeLineEntity

- (instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.currtTime = [self getTime:[array[0] integerValue]];
        self.avgPirce = [array[2] floatValue];
        self.lastPirce = [array[1] floatValue];
        self.volume = [array[3] floatValue];
        self.volueRate = [array[4] floatValue];
    }
    return self;
}

- (NSString *)getTime:(NSInteger )time{
    NSInteger fen = time%100;
    NSInteger shi = time/100;
    if (fen < 10) {
        return [NSString stringWithFormat:@"%ld:0%ld", (long)shi, (long)fen];
    } else {
        return [NSString stringWithFormat:@"%ld:%ld", (long)shi, (long)fen];
    }
}

@end
