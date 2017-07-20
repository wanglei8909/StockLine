//
//  WLHighLightedLayer.h
//  HNNniu
//
//  Created by wanglei on 2017/7/11.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WLHighLightedLayer : UIView

@property (nonatomic, assign) CGFloat uperChartHeightScale;//上下的比例
@property (nonatomic, assign) CGFloat xAxisHeitht; // 上下之间的空隙


- (void)setValue:(id) entry andPoint:(CGPoint) point;

@end
