//
//  BOLL.h
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"
#import <CoreGraphics/CoreGraphics.h>

/*
 * BOLL 指标线计算类
 */
@interface BOLL : NSObject

@property(nonatomic, strong) NSArray *kLineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回BOLL点数组
+ (NSArray *)getBOLLPoints:(NSArray *)klineArray;

@end

/*
 * BOLL 点
 */
@interface BOLLPoint : NSObject

@property(nonatomic, assign) CGFloat mid;
@property(nonatomic, assign) CGFloat upper;
@property(nonatomic, assign) CGFloat lower;

- (instancetype)initWithMid:(CGFloat )mid
                      upper:(CGFloat )upper
                      lower:(CGFloat )lower;

@end




