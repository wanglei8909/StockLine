//
//  KDJ.h
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"
#import <CoreGraphics/CoreGraphics.h>

/*
 * KDJ 指标线计算类
 */
@interface KDJ : NSObject

@property(nonatomic, strong) NSArray *linesArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回KDJ点数组
+ (NSArray *)getKDJPoints:(NSArray *)kLineArray;

@end

/*
 * KDJ 点
 */
@interface KDJPoint : NSObject

@property(nonatomic) float k;
@property(nonatomic) float d;
@property(nonatomic) float j;
@property(nonatomic, copy) NSString *date;

- (CGFloat)getMaxValue;
- (CGFloat)getMinValue;

@end







