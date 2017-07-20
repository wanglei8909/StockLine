//
//  YYAdd.m
//  StockLine
//
//  Created by wanglei on 2017/7/19.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "UIColor+YYAdd.h"

@implementation UIColor (YYAdd)

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

@end
