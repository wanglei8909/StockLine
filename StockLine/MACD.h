//
//  MACD.h
//  HNNniu
//
//  Created by wanglei on 2017/7/17.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"
#import <CoreGraphics/CoreGraphics.h>
/*
 * MACD 指标线计算类
 */
@interface MACD : NSObject

@property(nonatomic, strong) NSArray *linesArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回MACD点数组
+ (NSArray *)getMACDPoints:(NSArray *)kLineArray;

@end

/*
 * MACD 点
 */
@interface MACDPoint : NSObject

@property(nonatomic) float dif;
@property(nonatomic) float dea;
@property(nonatomic) float macd;
@property(nonatomic, copy) NSString *date;

- (CGFloat)getMaxValue;

@end
