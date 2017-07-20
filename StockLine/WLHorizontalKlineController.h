//
//  WLHorizontalKlineController.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WLShowHightLightViewShowType) {
    WLShowHightLightView_Time,
    WLShowHightLightView_KLine,
};

@interface WLHorizontalKlineController : UIViewController

@property (nonatomic, assign) WLShowHightLightViewShowType lineViewType;//分时 ， kline

@end
