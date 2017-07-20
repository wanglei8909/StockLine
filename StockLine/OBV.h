//
//  OBV.h
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"
#import <CoreGraphics/CoreGraphics.h>

/*
 * OBV 指标线计算类
 */
@interface OBV : NSObject

@property (nonatomic,strong) NSArray *klineArray;
@property (nonatomic,strong) NSMutableArray *pointsArray;

///传入k线数据，返回OBV点数组
+ (NSArray *)getOBVPoints:(NSArray *)klineArray;

@end


/*
 * OBV 点
 */
@interface OBVPoint : NSObject

@property (nonatomic,assign) CGFloat obv;
@property (nonatomic,assign) CGFloat maObv;

- (instancetype)initWithObv:(CGFloat)obv maObv:(CGFloat)maObv;

@end


