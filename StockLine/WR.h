//
//  WR.h
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreGraphics/CGBase.h>
/*
 * WR 指标线计算类
 */
@interface WR : NSObject

@property(nonatomic, strong) NSArray *klineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回WR点数组
+ (NSArray *)getWRPoints:(NSArray *)klineArray;

@end

/*
 * WR 点
 */
@interface WRPoint : NSObject

@property(nonatomic, assign) CGFloat wr1;
@property(nonatomic, assign) CGFloat wr2;

- (instancetype)initWithWr1:(CGFloat )wr1
                        wr2:(CGFloat )wr2;

@end
