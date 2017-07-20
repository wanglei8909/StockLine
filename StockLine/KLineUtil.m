//
//  KLineUtil.m
//  HNNniu
//
//  Created by wanglei on 2017/7/17.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "KLineUtil.h"

@implementation KLineUtil


+ (float)roundUp:(float)value {
    return floorf(value * 100.f + 0.5) / 100.f;
}

+ (float)roundUp3:(float)value {
    return floorf(value * 1000.f + 0.5) / 1000.f;
}


@end
