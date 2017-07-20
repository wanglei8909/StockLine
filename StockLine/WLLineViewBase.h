//
//  WLLineViewBase.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLKLineBase.h"

//指数类型
typedef NS_ENUM(NSInteger, KlineBottomType) {
    KlineBottomType_VOL,
    KlineBottomType_BOLL,
    KlineBottomType_MACD,
    KlineBottomType_KDJ,
    KlineBottomType_RSI,
    KlineBottomType_OBV,
    KlineBottomType_WR,
};

@protocol WLLineViewBaseDelegate <NSObject>

@optional

- (void)chartViewDidSelected:(WLKLineBase *)chartView;
- (void)chartValueSelected:(WLKLineBase *)chartView entry:(id)entry entryIndex:(NSInteger)entryIndex;
- (void)chartViewDidUnselected:(WLKLineBase *)chartView;

@end


@interface WLLineViewBase : WLKLineBase

@property (nonatomic, assign) KlineBottomType lineType;//指数类型

@property (nonatomic, weak) id<WLLineViewBaseDelegate> delegate;

@property (nonatomic,assign) CGFloat uperChartHeightScale;//上下的比例
@property (nonatomic,assign) CGFloat xAxisHeitht; // 上下之间的空隙

@property (nonatomic, strong) UIColor *gridBackgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic,assign)CGFloat maxPrice;
@property (nonatomic,assign)CGFloat minPrice;
@property (nonatomic,assign)CGFloat maxVolume;
@property (nonatomic,assign)CGFloat candleCoordsScale;
@property (nonatomic,assign)CGFloat volumeCoordsScale;

//指数值
@property (nonatomic,assign)CGFloat maxBOLLValue;
@property (nonatomic,assign)CGFloat minBOLLValue;
@property (nonatomic,assign)CGFloat bollCoordsScale;
@property (nonatomic,assign)CGFloat maxMACDValue;
@property (nonatomic,assign)CGFloat macdCoordsScale;
@property (nonatomic,assign)CGFloat maxKDJValue;
@property (nonatomic,assign)CGFloat minKDJValue;
@property (nonatomic,assign)CGFloat kdjCoordsScale;
@property (nonatomic,assign)CGFloat maxRSIValue;
@property (nonatomic,assign)CGFloat minRSIValue;
@property (nonatomic,assign)CGFloat rsiCoordsScale;
@property (nonatomic,assign)CGFloat maxOBVValue;
@property (nonatomic,assign)CGFloat minOBVValue;
@property (nonatomic,assign)CGFloat obvCoordsScale;
@property (nonatomic,assign)CGFloat maxWRValue;
@property (nonatomic,assign)CGFloat minWRValue;
@property (nonatomic,assign)CGFloat wrCoordsScale;

@property (nonatomic,assign)NSInteger highlightLineCurrentIndex;
@property (nonatomic,assign)CGPoint highlightLineCurrentPoint;
@property (nonatomic,assign)BOOL highlightLineCurrentEnabled;


- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth;

- (void)drawLabelPrice:(CGContextRef)context;
- (void)drawKLineLabelPrice:(CGContextRef)context;

//圆点
-(void)drawCiclyPoint:(CGContextRef)context
                point:(CGPoint)point
               radius:(CGFloat)radius
                color:(UIColor*)color;
- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth;

- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect;

- (void)drawRect:(CGContextRef)context
            rect:(CGRect)rect
           color:(UIColor*)color;


- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect;


@end
