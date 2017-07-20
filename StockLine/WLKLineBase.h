//
//  WLKLineBase.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLKLineBase : UIView
@property (nonatomic,assign) CGRect contentRect;
@property (nonatomic,assign) CGFloat chartHeight;
@property (nonatomic,assign) CGFloat chartWidth;

- (void)setupChartOffsetWithLeft:(CGFloat)left
                             top:(CGFloat)topx
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom;
- (BOOL)isInBoundsX:(CGFloat)x;
- (BOOL)isInBoundsY:(CGFloat)y;
- (BOOL)isInBoundsX:(CGFloat)x
                  y:(CGFloat)y;

- (BOOL)isInBoundsLeft:(CGFloat)x;
- (BOOL)isInBoundsRight:(CGFloat)x;
- (BOOL)isInBoundsTop:(CGFloat)y;
- (BOOL)isInBoundsBottom:(CGFloat)y;

- (CGFloat)contentTop;
- (CGFloat)contentLeft;
- (CGFloat)contentRight;
- (CGFloat)contentBottom;
- (CGFloat)contentWidth;
- (CGFloat)contentHeight;

@end
