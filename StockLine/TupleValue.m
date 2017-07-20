//
//  TupleValue.m
//  HNNniu
//
//  Created by wanglei on 2017/7/18.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "TupleValue.h"

@implementation TupleValue


- (instancetype)initWithFirst:(NSNumber *)firstNumber
                       second:(NSNumber *)secondNumber {
    if (self = [super init]) {
        self.firstNumber = firstNumber;
        self.secondNumber = secondNumber;
    }
    return self;
}

@end
