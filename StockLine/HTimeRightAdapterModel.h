//
//  HTimeRightAdapterModel.h
//  HNNniu
//
//  Created by wanglei on 2017/7/7.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTimeRightAdapterModel : NSObject

@property (nonatomic, copy) NSString *leftValue;
@property (nonatomic, copy) NSString *midValue;
@property (nonatomic, copy) NSString *rightValue;

@property (nonatomic, strong) UIColor *leftColor;
@property (nonatomic, strong) UIColor *midColor;
@property (nonatomic, strong) UIColor *rightColor;

@end
