//
//  RSI.h
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"
#import <CoreGraphics/CoreGraphics.h>
/*
 * RSI 指标线计算类
 */
@interface RSI : NSObject

@property(nonatomic, strong) NSArray *kLineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回RSI点数组
+ (NSArray *)getRSIPoints:(NSArray *)kLineArray;

@end

/*
 * RSI 点
 */
@interface RSIPoint : NSObject

@property(nonatomic, strong) NSMutableDictionary *valueDic;
@property(nonatomic, assign, readonly) CGFloat sixValue;
@property(nonatomic, assign, readonly) CGFloat twelveValue;
@property(nonatomic, assign, readonly) CGFloat twentyfourValue;
@property(nonatomic, copy) NSString *date;

- (CGFloat)getMaxValue;
- (CGFloat)getMinValue;

@end


