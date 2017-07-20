//
//  WLKLineView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/12.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLKLineView.h"
#import "WLLineEntity.h"
#import "UIColor+YYAdd.h"
#import "WLHighLightedLayer.h"
#import "WLKLineHighLightedLayer.h"
#import "MACD.h"
#import "KDJ.h"
#import "RSI.h"
#import "BOLL.h"
#import "OBV.h"
#import "WR.h"

@interface WLKLineView ()

@property (nonatomic, assign) NSInteger countOfshowCandle;

@property (nonatomic, assign) NSInteger startDrawIndex;
//@property (nonatomic, assign) NSInteger pinchStartIndex;
@property (nonatomic, strong) UIPinchGestureRecognizer * pinGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, strong) UIColor *riseColor;
@property (nonatomic, strong) UIColor *fallColor;
@property (nonatomic, strong) UIColor *ma5Color;
@property (nonatomic, strong) UIColor *ma10Color;
@property (nonatomic, strong) UIColor *ma20Color;
@property (nonatomic, strong) UIColor *ma30Color;
@property (nonatomic, strong) UIColor *ma60Color;
@property (nonatomic, strong) UIColor *ma120Color;

@property (nonatomic, assign) CGFloat lastPinScale;
@property (nonatomic, assign) CGFloat lastPinCount;

@property (nonatomic, strong) WLKLineHighLightedLayer *highLightedLayer;

@property (nonatomic, assign) CGFloat oldContentOffsetX;
@property (nonatomic, assign) CGFloat oldPinOffsetX;
@property (nonatomic, assign) CGFloat oldCandleWidth;

@property (nonatomic, strong) NSMutableArray *BOLLArray;
@property (nonatomic, strong) NSMutableArray *MACDArray;
@property (nonatomic, strong) NSMutableArray *KDJArray;
@property (nonatomic, strong) NSMutableArray *RSIArray;
@property (nonatomic, strong) NSMutableArray *OBVArray;
@property (nonatomic, strong) NSMutableArray *WRArray;

@property (nonatomic, assign) NSInteger pinCenterIndex;


@end

// 放大缩小  ###
// 加载更多，翻页
// 最大值最小值加间隙
// 指标列表可滑动  ###
@implementation WLKLineView


#pragma mark setData
- (void)setMDataArray:(NSArray *)mDataArray{
    _mDataArray = [[NSArray alloc] initWithArray:[mDataArray copy]];
    //    self.startDrawIndex = self.dataArray.count - self.countOfshowCandle;
    self.highLightedLayer.frame = CGRectMake(self.contentLeft, self.contentTop, self.contentWidth, self.contentHeight);
    [self.highLightedLayer setContentSize:CGSizeMake(_mDataArray.count * self.candleWidth, 0)];
    [self.highLightedLayer setContentOffset:CGPointMake(_mDataArray.count * self.candleWidth - self.contentWidth, 0)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //    NSLog(@"%@",change);
    if([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat difValue = ABS(self.highLightedLayer.contentOffset.x - self.oldContentOffsetX);
        if(difValue >= self.candleWidth)
        {
            self.oldContentOffsetX = self.highLightedLayer.contentOffset.x;
            [self redrawView];
        }
    }
}

- (void)redrawView{
    //当滑动时 关闭高亮
    if (self.delegate && [self.delegate respondsToSelector:@selector(chartViewDidUnselected:)]) {
        [self.delegate chartViewDidUnselected:self];
    }
    self.highlightLineCurrentEnabled = NO;
    [self setNeedsDisplay];
}

- (WLKLineHighLightedLayer *)highLightedLayer{
    if (!_highLightedLayer) {
        _highLightedLayer = [[WLKLineHighLightedLayer alloc] init];
        [_highLightedLayer addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _highLightedLayer;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        
    }
    return self;
}


#pragma mark Draw
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self setCurrentDataMaxAndMin];
    if (self.lineType == KlineBottomType_BOLL) {
        [self setBOLLMaxAndMin];
    }
    else if (self.lineType == KlineBottomType_MACD){
        [self setMacdMaxAndMin];
    }
    else if (self.lineType == KlineBottomType_KDJ){
        [self setKdjMaxAndMin];
    }
    else if (self.lineType == KlineBottomType_RSI){
        [self setRsiMaxAndMin];
    }
    else if (self.lineType == KlineBottomType_OBV){
        [self setObvMaxAndMin];
    }
    else if (self.lineType == KlineBottomType_WR){
        [self setWRMaxAndMin];
    }
    
    CGContextRef optionalContext = UIGraphicsGetCurrentContext();
 
    [self drawGridBackground:optionalContext rect:rect];
    [self drawTimeLabel:optionalContext];
    if (self.mDataArray.count) {
        [self drawCandle:optionalContext];
    }
    [self drawKLineLabelPrice:optionalContext];
}

- (void)drawCandle:(CGContextRef)context
{
    CGContextSaveGState(context);
    NSInteger idex = self.startDrawIndex;
    self.candleCoordsScale = (self.uperChartHeightScale * self.contentHeight)/(self.maxPrice-self.minPrice);
    
    for (NSInteger i = idex ; i< self.mDataArray.count; i ++) {
        WLLineEntity  * entity  = [self.mDataArray objectAtIndex:i];
        CGFloat open = ((self.maxPrice - entity.open) * self.candleCoordsScale) + self.contentTop;
        CGFloat close = ((self.maxPrice - entity.close) * self.candleCoordsScale) + self.contentTop;
        CGFloat high = ((self.maxPrice - entity.high) * self.candleCoordsScale) + self.contentTop;
        CGFloat low = ((self.maxPrice - entity.low) * self.candleCoordsScale) + self.contentTop;
        CGFloat left = (self.candleWidth * (i - idex) + self.contentLeft) + self.candleWidth / 6.0;
        
        CGFloat candleWidth = self.candleWidth - self.candleWidth / 6.0;
        CGFloat startX = left + candleWidth/2.0 ;
        
        //date
        //日期
        if (i > self.startDrawIndex+5 && i < self.mDataArray.count - 2) {
            if (i % (NSInteger)(180/self.candleWidth) == 0 && startX < self.contentWidth-45&& startX > 105 + self.contentLeft) {
                CGFloat arr[] = {3,1};
                CGContextSetLineDash(context, 0, arr, 2);
                [self drawline:context startPoint:CGPointMake(startX, self.contentTop) stopPoint:CGPointMake(startX,  (self.uperChartHeightScale * self.contentHeight)+ self.contentTop) color:self.borderColor lineWidth:0.5];
                [self drawline:context startPoint:CGPointMake(startX, (self.uperChartHeightScale * self.contentHeight)+ self.xAxisHeitht + self.contentTop) stopPoint:CGPointMake(startX,self.contentBottom) color:self.borderColor lineWidth:0.5];
                CGContextSetLineDash(context, 0, nil, 0);
                NSString * date = entity.date;
                
                NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]};
                NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
                CGSize dateStrAttSize = [dateStrAtt size];
                [self drawLabel:context attributesText:dateStrAtt rect:CGRectMake(startX - dateStrAttSize.width/2,((self.uperChartHeightScale * self.contentHeight)+ self.contentTop), dateStrAttSize.width, dateStrAttSize.height)];
                
            }
        }
        
        UIColor * color = _riseColor;
        if (open < close) {
            color = _fallColor;
            CGFloat hight = close-open < 1.0?1.0:close-open;
            [self drawRect:context rect:CGRectMake(left, open, candleWidth, hight) color:color];
            [self drawline:context startPoint:CGPointMake(startX, high) stopPoint:CGPointMake(startX, low) color:color lineWidth:1];
        }
        else if (open == close) {
            if (i > 1) {
                WLLineEntity * lastEntity = [self.mDataArray objectAtIndex:i-1];
                if (lastEntity.close > entity.close) {
                    color = _fallColor;
                }
            }
            [self drawRect:context rect:CGRectMake(left, open, candleWidth, 1.5) color:color];
            [self drawline:context startPoint:CGPointMake(startX, high) stopPoint:CGPointMake(startX, low) color:color lineWidth:1];
        } else {
            color = _riseColor;
            CGFloat hight = open-close < 1.0?1.0:open-close;
            [self drawRect:context rect:CGRectMake(left, close, candleWidth, hight) color:color];
            [self drawline:context startPoint:CGPointMake(startX, high) stopPoint:CGPointMake(startX, low) color:color lineWidth:1];
        }
        
        
        // 5 10 20 均线
        if (i > 0){
            WLLineEntity * lastEntity = [self.mDataArray objectAtIndex:i -1];
            CGFloat lastX = startX - self.candleWidth;
            
            CGFloat lastY5 = (self.maxPrice - lastEntity.ma5)*self.candleCoordsScale + self.contentTop;
            CGFloat  y5 = (self.maxPrice - entity.ma5)*self.candleCoordsScale  + self.contentTop;
            if (entity.ma5 > 0 && lastEntity.ma5>0) {
                [self drawline:context startPoint:CGPointMake(lastX, lastY5) stopPoint:CGPointMake(startX, y5) color:self.ma5Color lineWidth:1];
            }
            
            CGFloat lastY10 = (self.maxPrice - lastEntity.ma10)*self.candleCoordsScale  + self.contentTop;
            CGFloat  y10 = (self.maxPrice - entity.ma10)*self.candleCoordsScale  + self.contentTop;
            if (entity.ma10 > 0 && lastEntity.ma10 > 0) {
                [self drawline:context startPoint:CGPointMake(lastX, lastY10) stopPoint:CGPointMake(startX, y10) color:self.ma10Color lineWidth:1];
            }
            
            CGFloat lastY20 = (self.maxPrice - lastEntity.ma20)*self.candleCoordsScale  + self.contentTop;
            CGFloat  y20 = (self.maxPrice - entity.ma20)*self.candleCoordsScale  + self.contentTop;
            if (entity.ma20 > 0 && lastEntity.ma20 >0) {
                [self drawline:context startPoint:CGPointMake(lastX, lastY20) stopPoint:CGPointMake(startX, y20) color:self.ma20Color lineWidth:1];
            }
        }
#pragma Mark warning  成交量还有其他颜色，现在不知道怎么算
        //成交量
        if (self.lineType == KlineBottomType_VOL) {
            CGFloat volume = ((entity.volume - 0) * self.volumeCoordsScale);
            [self drawRect:context rect:CGRectMake(left, self.contentBottom - volume , candleWidth, volume) color:color];
            //成交量均线
            if (i > 0){
                WLLineEntity * lastEntity = [self.mDataArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                CGFloat lastY5 = self.contentBottom - lastEntity.volma5*self.volumeCoordsScale;
                CGFloat y5 = self.contentBottom - entity.volma5*self.volumeCoordsScale;
                if (entity.volma5 > 0 && lastEntity.volma5>0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY5) stopPoint:CGPointMake(startX, y5) color:self.ma5Color lineWidth:1];
                }
                
                CGFloat lastY10 = self.contentBottom - lastEntity.volma10*self.volumeCoordsScale;
                CGFloat  y10 = self.contentBottom - entity.volma10*self.volumeCoordsScale;
                if (entity.volma10 > 0 && lastEntity.volma10 > 0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY10) stopPoint:CGPointMake(startX, y10) color:self.ma10Color lineWidth:1];
                }
                
                CGFloat lastY20 = self.contentBottom - lastEntity.volma20*self.volumeCoordsScale;
                CGFloat  y20 = self.contentBottom - entity.volma20*self.volumeCoordsScale;
                if (entity.volma20 > 0 && lastEntity.volma20 >0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY20) stopPoint:CGPointMake(startX, y20) color:self.ma20Color lineWidth:1];
                }
                
                CGFloat lastY30 = self.contentBottom - lastEntity.volma30*self.volumeCoordsScale;
                CGFloat  y30 = self.contentBottom - entity.volma30*self.volumeCoordsScale;
                if (entity.volma30 > 0 && lastEntity.volma30 >0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY30) stopPoint:CGPointMake(startX, y30) color:self.ma30Color lineWidth:1];
                }
                
                CGFloat lastY60 = self.contentBottom - lastEntity.volma60*self.volumeCoordsScale;
                CGFloat y60 = self.contentBottom - entity.volma60*self.volumeCoordsScale;
                if (entity.volma60 > 0 && lastEntity.volma60 >0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY60) stopPoint:CGPointMake(startX, y60) color:self.ma60Color lineWidth:1];
                }
                
                CGFloat lastY120 = self.contentBottom - lastEntity.volma120*self.volumeCoordsScale;
                CGFloat  y120 = self.contentBottom - entity.volma120*self.volumeCoordsScale;            if (entity.volma120 > 0 && lastEntity.volma120 >0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY120) stopPoint:CGPointMake(startX, y120) color:self.ma120Color lineWidth:1];
                }
            }
        }
        else if (self.lineType == KlineBottomType_BOLL){
            BOLLPoint *point = [self.BOLLArray objectAtIndex:i];
            if (i > 0){
                BOLLPoint * lastPoint = [self.BOLLArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                if (point.mid > 0 && lastPoint.mid>0) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.mid  - self.minBOLLValue)*self.bollCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.mid - self.minBOLLValue)*self.bollCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma5Color lineWidth:1];
                }
                if (point.upper > 0 && lastPoint.upper > 0) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.upper  - self.minBOLLValue)*self.bollCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.upper - self.minBOLLValue)*self.bollCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma10Color lineWidth:1];
                }
                if (point.lower > 0 && lastPoint.lower > 0) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.lower  - self.minBOLLValue)*self.bollCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.lower - self.minBOLLValue)*self.bollCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma20Color lineWidth:1];
                }
            }
        }
        else if (self.lineType == KlineBottomType_MACD){
//            self.MACDArray
            MACDPoint *point = [self.MACDArray objectAtIndex:i];
            if (point.macd >= 0) {
                color = _riseColor;
            }else{
                color = _fallColor;
            }
            
            CGFloat macd = ((point.macd - 0) * self.macdCoordsScale);
            CGFloat bottomY = self.contentBottom - (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/2.f;
            [self drawRect:context rect:CGRectMake(left, bottomY - macd , candleWidth, macd) color:color];
            
            if (i > 0){
                MACDPoint * lastPoint = [self.MACDArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                CGFloat lastYDif = bottomY - lastPoint.dif*self.macdCoordsScale;
                CGFloat  yDif = bottomY - point.dif*self.macdCoordsScale;
                [self drawline:context startPoint:CGPointMake(lastX, lastYDif) stopPoint:CGPointMake(startX, yDif) color:self.ma5Color lineWidth:1];
                
                CGFloat lastYDea = bottomY - lastPoint.dea*self.macdCoordsScale;
                CGFloat yDea = bottomY - point.dea*self.macdCoordsScale;
                [self drawline:context startPoint:CGPointMake(lastX, lastYDea) stopPoint:CGPointMake(startX, yDea) color:self.ma10Color lineWidth:1];
            }
        }
        else if (self.lineType == KlineBottomType_KDJ){
            KDJPoint *point = [self.KDJArray objectAtIndex:i];
            if (i > 0){
                KDJPoint * lastPoint = [self.KDJArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                CGFloat lastYK = self.contentBottom - (lastPoint.k - self.minKDJValue)*self.kdjCoordsScale;
                CGFloat yK = self.contentBottom - (point.k - self.minKDJValue)*self.kdjCoordsScale;
                [self drawline:context startPoint:CGPointMake(lastX, lastYK) stopPoint:CGPointMake(startX, yK) color:self.ma5Color lineWidth:1];
                
                CGFloat lastYD = self.contentBottom - (lastPoint.d - self.minKDJValue)*self.kdjCoordsScale;
                CGFloat yD = self.contentBottom - (point.d - self.minKDJValue)*self.kdjCoordsScale;
                [self drawline:context startPoint:CGPointMake(lastX, lastYD) stopPoint:CGPointMake(startX, yD) color:self.ma10Color lineWidth:1];
                
                CGFloat lastYJ = self.contentBottom - (lastPoint.j - self.minKDJValue)*self.kdjCoordsScale;
                CGFloat yJ = self.contentBottom - (point.j - self.minKDJValue)*self.kdjCoordsScale;
                [self drawline:context startPoint:CGPointMake(lastX, lastYJ) stopPoint:CGPointMake(startX, yJ) color:self.ma120Color lineWidth:1];
            }
            
        }
        else if (self.lineType == KlineBottomType_RSI){
            RSIPoint *point = [self.RSIArray objectAtIndex:i];
            if (i > 0){
                RSIPoint * lastPoint = [self.RSIArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                if (point.sixValue > 0 && lastPoint.sixValue) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.sixValue  - self.minRSIValue)*self.rsiCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.sixValue - self.minRSIValue)*self.rsiCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma5Color lineWidth:1];
                }
                if (point.twelveValue > 0 && lastPoint.twelveValue) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.twelveValue  - self.minRSIValue)*self.rsiCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.twelveValue - self.minRSIValue)*self.rsiCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma10Color lineWidth:1];
                }
                if (point.twentyfourValue > 0 && lastPoint.twentyfourValue) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.twentyfourValue  - self.minRSIValue)*self.rsiCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.twentyfourValue - self.minRSIValue)*self.rsiCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma20Color lineWidth:1];
                }
            }
        }
        else if (self.lineType == KlineBottomType_OBV){
            OBVPoint *point = [self.OBVArray objectAtIndex:i];
            if (i > 0){
                OBVPoint * lastPoint = [self.OBVArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                if (point.obv > 0 && lastPoint.obv) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.obv  - self.minOBVValue)*self.obvCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.obv - self.minOBVValue)*self.obvCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma5Color lineWidth:1];
                }
                //                if (point.maObv > 0 && lastPoint.maObv) {
                //                    CGFloat lastYsix = self.contentBottom - (lastPoint.maObv  - self.minOBVValue)*self.obvCoordsScale;
                //                    CGFloat ysix = self.contentBottom - (point.maObv - self.minOBVValue)*self.obvCoordsScale;
                //                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma10Color lineWidth:1];
                //                }
            }
        }
        else if (self.lineType == KlineBottomType_WR){
            WRPoint *point = [self.WRArray objectAtIndex:i];
            if (i > 0){
                WRPoint * lastPoint = [self.WRArray objectAtIndex:i -1];
                CGFloat lastX = startX - self.candleWidth;
                
                if (point.wr1 >= 0 && lastPoint.wr1 >= 0) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.wr1  - self.minWRValue)*self.wrCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.wr1 - self.minWRValue)*self.wrCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma5Color lineWidth:1];
                }
                if (point.wr2 >= 0 && lastPoint.wr2 >= 0) {
                    CGFloat lastYsix = self.contentBottom - (lastPoint.wr2  - self.minWRValue)*self.wrCoordsScale;
                    CGFloat ysix = self.contentBottom - (point.wr2 - self.minWRValue)*self.wrCoordsScale;
                    [self drawline:context startPoint:CGPointMake(lastX, lastYsix) stopPoint:CGPointMake(startX, ysix) color:self.ma10Color lineWidth:1];
                }
            }
        }
    }
    
    for (NSInteger i = idex ; i< self.mDataArray.count; i ++) {
        WLLineEntity  * entity  = [self.mDataArray objectAtIndex:i];
        
        CGFloat close = ((self.maxPrice - entity.close) * self.candleCoordsScale) + self.contentTop;
        CGFloat left = (self.candleWidth * (i - idex) + self.contentLeft) + self.candleWidth / 6.0;
        CGFloat candleWidth = self.candleWidth - self.candleWidth / 6.0;
        CGFloat startX = left + candleWidth/2.0 ;
        //十字线
        if (self.highlightLineCurrentEnabled) {
            if (i == self.highlightLineCurrentIndex) {
                
                WLLineEntity * entity;
                if (i < self.mDataArray.count) {
                    entity = [self.mDataArray objectAtIndex:i];
                }
                [self drawHighlighted:context point:CGPointMake(startX, close)idex:idex value:entity color:[UIColor colorWithRGB:0x888888] lineWidth:1];
                
//                BOOL isDrawRight = startX < (self.contentRight)/2.0;
                // ma5 ma10 ma20 label
                [self drawAvgMarker:context idex:i];
                if ([self.delegate respondsToSelector:@selector(chartValueSelected:entry:entryIndex:) ]) {
                    [self.delegate chartValueSelected:self entry:entity entryIndex:i];
                }
            }
        }
    }
    // ma5 ma10 ma20 label
    if (!self.highlightLineCurrentEnabled) {
        [self drawAvgMarker:context idex:0];;
    }
    CGContextRestoreGState(context);
}

// ma5 ma10 ma20 label
- (void)drawAvgMarker:(CGContextRef)context
                 idex:(NSInteger)idex{
    WLLineEntity  * entry;
    if (0 == idex) {
        entry = [self.mDataArray lastObject];
    }else{
        entry = self.mDataArray[idex];
    }
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:self.ma5Color};
    NSMutableAttributedString * startTimeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"MA5: %.2f",entry.ma5] attributes:drawAttributes];
    CGSize sizeStartTimeAttStr = [startTimeAttStr size];
    CGFloat top = 5;
    CGFloat left = self.contentLeft;
    [self drawLabel:context attributesText:startTimeAttStr rect:CGRectMake(left, top, sizeStartTimeAttStr.width, sizeStartTimeAttStr.height)];
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:self.ma10Color};
    startTimeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"MA10: %.2f",entry.ma10] attributes:drawAttributes];
    sizeStartTimeAttStr = [startTimeAttStr size];
    left += sizeStartTimeAttStr.width + 8;
    [self drawLabel:context attributesText:startTimeAttStr rect:CGRectMake(left, top, sizeStartTimeAttStr.width, sizeStartTimeAttStr.height)];
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:self.ma20Color};
    startTimeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"MA20: %.2f",entry.ma20] attributes:drawAttributes];
    sizeStartTimeAttStr = [startTimeAttStr size];
    left += sizeStartTimeAttStr.width + 8;
    [self drawLabel:context attributesText:startTimeAttStr rect:CGRectMake(left, top, sizeStartTimeAttStr.width, sizeStartTimeAttStr.height)];
    
}

- (void)drawTimeLabel:(CGContextRef)context
{
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]};
    WLLineEntity * entry = [self.mDataArray objectAtIndex:self.startDrawIndex];
    NSInteger stopIndex = self.startDrawIndex + self.countOfshowCandle >= self.mDataArray.count?self.mDataArray.count - 1: self.startDrawIndex + self.countOfshowCandle;
    WLLineEntity * stopEntry = [self.mDataArray objectAtIndex:stopIndex];
    if (entry && stopEntry) {
        NSMutableAttributedString * startTimeAttStr = [[NSMutableAttributedString alloc]initWithString:entry.date attributes:drawAttributes];
        CGSize sizeStartTimeAttStr = [startTimeAttStr size];
        CGFloat top = self.uperChartHeightScale * self.contentHeight+self.contentTop;
        [self drawLabel:context attributesText:startTimeAttStr rect:CGRectMake(self.contentLeft, top, sizeStartTimeAttStr.width, sizeStartTimeAttStr.height)];
        NSMutableAttributedString * stopTimeAttStr = [[NSMutableAttributedString alloc]initWithString:stopEntry.date attributes:drawAttributes];
        CGSize sizeStopTimeAttStr = [stopTimeAttStr size];
        [self drawLabel:context attributesText:stopTimeAttStr rect:CGRectMake(self.contentRight -sizeStopTimeAttStr.width, top, sizeStopTimeAttStr.width, sizeStopTimeAttStr.height)];
    }
}

- (void)drawGridBackground:(CGContextRef)context rect:(CGRect)rect
{
    [super drawGridBackground:context rect:rect];
}

- (NSInteger)countOfshowCandle{
    return self.contentWidth/(self.candleWidth);
}

- (NSInteger)startDrawIndex{
    CGFloat scrollViewOffsetX = self.highLightedLayer.contentOffset.x <= 0 ? 0 : self.highLightedLayer.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - self.candleWidth/6) / (self.candleWidth);
    _startDrawIndex = leftArrCount + 1;
    return _startDrawIndex;
}

- (void)commonInit {
    self.layer.drawsAsynchronously = YES;
    self.riseColor = [UIColor colorWithRGB:0xFB5457];
    self.fallColor = [UIColor colorWithRGB:0x35C484];
    
    self.ma5Color  = [UIColor colorWithRGB:0x91CAF7];
    self.ma10Color = [UIColor colorWithRGB:0xFFB43E];
    self.ma20Color = [UIColor colorWithRGB:0x67B3FF];
    self.ma30Color = [UIColor colorWithRGB:0x9E96FC];
    self.ma60Color = [UIColor colorWithRGB:0xFFA59F];
    self.ma120Color = [UIColor colorWithRGB:0x52FDB9];
    
    self.candleCoordsScale = 0.f;
    [self addSubview:self.highLightedLayer];
    
    [self addGestureRecognizer:self.pinGesture];
    [self addGestureRecognizer:self.longPressGesture];
    [self addGestureRecognizer:self.tapGesture];
}

#pragma mark 处理手势
- (UIPinchGestureRecognizer *)pinGesture
{
    if (!_pinGesture) {
        _pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGestureAction:)];
    }
    return _pinGesture;
}


- (void)handlePinGestureAction:(UIPinchGestureRecognizer *)recognizer
{
    self.highlightLineCurrentEnabled = NO;
    
    CGPoint p1, p2, centerPoint;
    
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        if(recognizer.numberOfTouches == 2 ) {
            self.lastPinCount = self.countOfshowCandle;
            self.lastPinScale = 1;
            //中间点的坐标
            p1 = [recognizer locationOfTouch:0 inView:self];
            p2 = [recognizer locationOfTouch:1 inView:self];
            centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            NSLog(@"%f",centerPoint.x);
            //中间点是第多少个数据
            self.pinCenterIndex = (NSInteger)(centerPoint.x + self.highLightedLayer.contentOffset.x)/self.candleWidth;
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        if(recognizer.numberOfTouches == 2 ) {
            recognizer.scale= recognizer.scale-self.lastPinScale + 1;
            
            self.candleWidth = recognizer.scale * self.candleWidth;
            
            if(self.candleWidth > self.candleMaxWidth){
                self.candleWidth = self.candleMaxWidth;
            }
            if(self.candleWidth < self.candleMinWidth){
                self.candleWidth = self.candleMinWidth;
            }
            
            //中间点的坐标
            p1 = [recognizer locationOfTouch:0 inView:self];
            p2 = [recognizer locationOfTouch:1 inView:self];
            centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            
            NSInteger offset = (NSInteger)((self.lastPinCount -self.countOfshowCandle));
            
            if (labs(offset) && labs(offset)%2==0) {
                NSLog(@"index:%ld",self.pinCenterIndex);
                self.lastPinCount = self.countOfshowCandle;
                [self.highLightedLayer setContentSize:CGSizeMake(_mDataArray.count * self.candleWidth, 0)];
                //          中间点点坐标
                [self.highLightedLayer setContentOffset:CGPointMake((self.pinCenterIndex * self.candleWidth - centerPoint.x), 0)];
                
            }
            self.lastPinScale = recognizer.scale;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ) {
        [self.highLightedLayer setContentSize:CGSizeMake(_mDataArray.count * self.candleWidth, 0)];
    }
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureAction:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return _longPressGesture;
}
- (void)handleLongPressGestureAction:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint  point = [recognizer locationInView:self];
        
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(chartViewDidSelected:)]) {
                [self.delegate chartViewDidSelected:self];
            }
            [self getHighlightByTouchPoint:point];
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint  point = [recognizer locationInView:self];
        
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
    }
}

- (void)getHighlightByTouchPoint:(CGPoint) point
{
    self.highlightLineCurrentIndex = self.startDrawIndex + (NSInteger)((point.x - self.contentLeft)/self.candleWidth);
    [self setNeedsDisplay];
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureAction:)];
    }
    return _tapGesture;
}
- (void)handleTapGestureAction:(UITapGestureRecognizer *)recognizer
{
    if (self.highlightLineCurrentEnabled) {
        self.highlightLineCurrentEnabled = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chartViewDidUnselected:)]) {
            [self.delegate chartViewDidUnselected:self];
        }
    }
    [self setNeedsDisplay];
}




#pragma mark 计算最大值最小值 指标最大值最小值
- (void)setWRMaxAndMin{
    if (self.WRArray.count>0) {
        self.maxWRValue = CGFLOAT_MIN;
        self.minWRValue = CGFLOAT_MAX;
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.WRArray.count; i++) {
            WRPoint *entity = [self.WRArray objectAtIndex:i];
            
            if(entity.wr1>=0){
                self.minWRValue = self.minWRValue < entity.wr1 ? self.minWRValue:entity.wr1;
                self.maxWRValue = self.maxWRValue > entity.wr1 ? self.maxWRValue:entity.wr1;
            }
            if(entity.wr2>=0){
                self.minWRValue = self.minWRValue < entity.wr2 ? self.minWRValue:entity.wr2;
                self.maxWRValue = self.maxWRValue > entity.wr2 ? self.maxWRValue:entity.wr2;
            }
        }
        self.wrCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxWRValue - self.minWRValue);
    }
}

- (void)setObvMaxAndMin{
    if (self.OBVArray.count>0) {
        self.maxOBVValue = CGFLOAT_MIN;
        self.minOBVValue = CGFLOAT_MAX;
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.OBVArray.count; i++) {
            OBVPoint *entity = [self.OBVArray objectAtIndex:i];
            
            if(entity.obv>0){
                self.minOBVValue = self.minOBVValue < entity.obv ? self.minOBVValue:entity.obv;
                self.maxOBVValue = self.maxOBVValue > entity.obv ? self.maxOBVValue:entity.obv;
            }
            //            if(entity.maObv>0){
            //                self.minOBVValue = self.minOBVValue < entity.maObv ? self.minOBVValue:entity.maObv;
            //                self.maxOBVValue = self.maxOBVValue > entity.maObv ? self.maxOBVValue:entity.maObv;
            //            }
        }
        self.obvCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxOBVValue - self.minOBVValue);
    }
}

- (void)setBOLLMaxAndMin{
    if (self.BOLLArray.count>0) {
        self.maxBOLLValue = CGFLOAT_MIN;
        self.minBOLLValue = CGFLOAT_MAX;
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.BOLLArray.count; i++) {
            BOLLPoint *entity = [self.BOLLArray objectAtIndex:i];
            
            if(entity.mid>0){
                self.minBOLLValue = self.minBOLLValue < entity.mid ? self.minBOLLValue:entity.mid;
                self.maxBOLLValue = self.maxBOLLValue > entity.mid ? self.maxBOLLValue:entity.mid;
            }
            if(entity.upper>0){
                self.minBOLLValue = self.minBOLLValue < entity.upper ? self.minBOLLValue:entity.upper;
                self.maxBOLLValue = self.maxBOLLValue > entity.upper ? self.maxBOLLValue:entity.upper;
            }
            if(entity.lower>0){
                self.minBOLLValue = self.minBOLLValue < entity.lower ? self.minBOLLValue:entity.lower;
                self.maxBOLLValue = self.maxBOLLValue > entity.lower ? self.maxBOLLValue:entity.lower;
            }
        }
        self.bollCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxBOLLValue - self.minBOLLValue);
    }
}

- (void)setRsiMaxAndMin{
    if (self.RSIArray.count > 0) {
        self.maxRSIValue = CGFLOAT_MIN;
        self.minRSIValue = CGFLOAT_MAX;
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.RSIArray.count; i++) {
            RSIPoint *entity = [self.RSIArray objectAtIndex:i];
            if(entity.sixValue>0){
                self.minRSIValue = self.minRSIValue < entity.sixValue ? self.minRSIValue:entity.sixValue;
                self.maxRSIValue = self.maxRSIValue > entity.sixValue ? self.maxRSIValue:entity.sixValue;
            }
            if(entity.twelveValue>0){
                self.minRSIValue = self.minRSIValue < entity.twelveValue ? self.minRSIValue:entity.twelveValue;
                self.maxRSIValue = self.maxRSIValue > entity.twelveValue ? self.maxRSIValue:entity.twelveValue;
            }
            if(entity.twentyfourValue>0){
                self.minRSIValue = self.minRSIValue < entity.twentyfourValue ? self.minRSIValue:entity.twentyfourValue;
                self.maxRSIValue = self.maxRSIValue > entity.twentyfourValue ? self.maxRSIValue:entity.twentyfourValue;
            }
        }
        self.rsiCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxRSIValue - self.minRSIValue);
    }
}

- (void)setKdjMaxAndMin{
    if (self.KDJArray.count > 0) {
        self.maxKDJValue = CGFLOAT_MIN;
        self.minKDJValue = CGFLOAT_MAX;
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.KDJArray.count; i++) {
            KDJPoint *entity = [self.KDJArray objectAtIndex:i];
            self.maxKDJValue = self.maxKDJValue > [entity getMaxValue]?self.maxKDJValue:[entity getMaxValue];
            self.minKDJValue = self.minKDJValue < [entity getMinValue]?self.minKDJValue:[entity getMinValue];
        }
        self.kdjCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxKDJValue - self.minKDJValue);
    }
}

- (void)setMacdMaxAndMin{
    if (self.MACDArray.count > 0) {
        self.maxMACDValue = CGFLOAT_MIN;
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.MACDArray.count; i++) {
            MACDPoint  * entity = [self.MACDArray objectAtIndex:i];
            self.maxMACDValue = self.maxMACDValue > [entity getMaxValue]?self.maxMACDValue:[entity getMaxValue];
        }
    }
    self.macdCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxMACDValue - 0)/2.f;
}

- (void)setCurrentDataMaxAndMin{
    if (self.mDataArray.count > 0) {
        self.maxPrice = CGFLOAT_MIN;
        self.minPrice = CGFLOAT_MAX;
        self.maxVolume = CGFLOAT_MIN;
        
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.mDataArray.count; i++) {
            WLLineEntity  * entity = [self.mDataArray objectAtIndex:i];
            self.minPrice = self.minPrice < entity.low ? self.minPrice : entity.low;
            self.maxPrice = self.maxPrice > entity.high ? self.maxPrice : entity.high;
            self.maxVolume = self.maxVolume >entity.volume ? self.maxVolume : entity.volume;
            if(entity.ma5>0){
                self.minPrice = self.minPrice < entity.ma5 ? self.minPrice:entity.ma5;
                self.maxPrice = self.maxPrice > entity.ma5 ? self.maxPrice:entity.ma5;
            }
            if (entity.ma10 >0) {
                self.minPrice = self.minPrice < entity.ma10 ? self.minPrice:entity.ma10;
                self.maxPrice = self.maxPrice > entity.ma10 ? self.maxPrice:entity.ma10;
            }
            if (entity.ma20>0) {
                self.minPrice = self.minPrice < entity.ma20 ? self.minPrice:entity.ma20;
                self.maxPrice = self.maxPrice > entity.ma20 ? self.maxPrice:entity.ma20;
            }
            if (entity.ma30>0) {
                self.minPrice = self.minPrice < entity.ma30 ? self.minPrice:entity.ma30;
                self.maxPrice = self.maxPrice > entity.ma30 ? self.maxPrice:entity.ma30;
            }
            if (entity.ma60>0) {
                self.minPrice = self.minPrice < entity.ma60 ? self.minPrice:entity.ma60;
                self.maxPrice = self.maxPrice > entity.ma60 ? self.maxPrice:entity.ma60;
            }
            if (entity.ma120>0) {
                self.minPrice = self.minPrice < entity.ma120 ? self.minPrice:entity.ma120;
                self.maxPrice = self.maxPrice > entity.ma120 ? self.maxPrice:entity.ma120;
            }
        }
        
        if (self.maxPrice - self.minPrice < 0.3) {
            self.maxPrice +=0.5;
            self.minPrice -=0.5;
        }
        self.volumeCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxVolume - 0);
    }
}

- (NSMutableArray *)BOLLArray{
    if (!_BOLLArray) {
        _BOLLArray = [[NSMutableArray alloc] initWithCapacity:self.mDataArray.count];
        [_BOLLArray addObjectsFromArray:[BOLL getBOLLPoints:self.mDataArray]];
    }
    return _BOLLArray;
}

- (NSMutableArray *)MACDArray{
    if (!_MACDArray) {
        _MACDArray = [[NSMutableArray alloc] initWithCapacity:self.mDataArray.count];
        [_MACDArray addObjectsFromArray:[MACD getMACDPoints:self.mDataArray]];
    }
    return _MACDArray;
}

- (NSMutableArray *)KDJArray{
    if (!_KDJArray) {
        _KDJArray = [[NSMutableArray alloc] initWithCapacity:self.mDataArray.count];
        [_KDJArray addObjectsFromArray:[KDJ getKDJPoints:self.mDataArray]];
    }
    return _KDJArray;
}

- (NSMutableArray *)RSIArray{
    if (!_RSIArray) {
        _RSIArray = [[NSMutableArray alloc] initWithCapacity:self.mDataArray.count];
        [_RSIArray addObjectsFromArray:[RSI getRSIPoints:self.mDataArray]];
    }
    return _RSIArray;
}

- (NSMutableArray *)OBVArray{
    if (!_OBVArray) {
        _OBVArray = [[NSMutableArray alloc] initWithCapacity:self.mDataArray.count];
        [_OBVArray addObjectsFromArray:[OBV getOBVPoints:self.mDataArray]];
    }
    return _OBVArray;
}

- (NSMutableArray *)WRArray{
    if (!_WRArray) {
        _WRArray = [[NSMutableArray alloc] initWithCapacity:self.mDataArray.count];
        [_WRArray addObjectsFromArray:[WR getWRPoints:self.mDataArray]];
    }
    return _WRArray;
}

- (void) dealloc{
    [_highLightedLayer removeObserver:self forKeyPath:@"contentOffset"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
