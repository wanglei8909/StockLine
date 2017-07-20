//
//  TupleValue.h
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * RSI 用到的基本数据类型
 */
@interface TupleValue : NSObject

@property(nonatomic, strong) NSNumber *firstNumber;
@property(nonatomic, strong) NSNumber *secondNumber;

- (instancetype)initWithFirst:(NSNumber *)first second:(NSNumber *)second;

@end
