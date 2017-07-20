//
//  WLLineEntity.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface WLLineEntity : NSObject

@property (nonatomic, assign) CGFloat open;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat low;
@property (nonatomic, assign) CGFloat close;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat volueRate;//成交额
@property (nonatomic, assign) CGFloat ma5;
@property (nonatomic, assign) CGFloat ma10;
@property (nonatomic, assign) CGFloat ma20;
@property (nonatomic, assign) CGFloat ma30;
@property (nonatomic, assign) CGFloat ma60;
@property (nonatomic, assign) CGFloat ma120;

@property (nonatomic, assign) CGFloat volma5;
@property (nonatomic, assign) CGFloat volma10;
@property (nonatomic, assign) CGFloat volma20;
@property (nonatomic, assign) CGFloat volma30;
@property (nonatomic, assign) CGFloat volma60;
@property (nonatomic, assign) CGFloat volma120;


- (instancetype)initWithArray:(NSArray *)array;

//+ (CGFloat)getMA:(NSArray *)array type:(CGFloat)index;


@end

@interface WLTimeLineEntity : NSObject

@property (nonatomic, copy) NSString * currtTime;
@property (nonatomic, assign) CGFloat preClosePx;//昨收
@property (nonatomic, assign) CGFloat open;
@property (nonatomic, assign) CGFloat avgPirce;
@property (nonatomic, assign) CGFloat lastPirce; //当前价
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat volueRate;


- (instancetype)initWithArray:(NSArray *)array;

@end









