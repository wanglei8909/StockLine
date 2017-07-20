//
//  WLShowHightLightView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/11.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLLineEntity.h"

typedef NS_ENUM(NSInteger, WLShowHightLightViewShowType) {
    WLShowHightLightView_Time,
    WLShowHightLightView_KLine,
};

@interface WLShowHightLightView : UIView

@property (nonatomic, assign) WLShowHightLightViewShowType showType;
@property (nonatomic, assign) id entry;
//time
@property (nonatomic, copy) NSString *time_time;
@property (nonatomic, copy) NSString *time_gao;
@property (nonatomic, copy) NSString *time_fu;
@property (nonatomic, copy) NSString *time_e;
@property (nonatomic, copy) NSString *time_liang;

//Kline
@property (nonatomic, copy) NSString *kline_kai;
@property (nonatomic, copy) NSString *kline_gao;
@property (nonatomic, copy) NSString *kline_fu;
@property (nonatomic, copy) NSString *kline_chengjiao;
@property (nonatomic, copy) NSString *kline_shou;
@property (nonatomic, copy) NSString *kline_di;
@property (nonatomic, copy) NSString *kline_e;
@property (nonatomic, copy) NSString *kline_huanshou;

- (void)setUpData:(id)entry;

@end





