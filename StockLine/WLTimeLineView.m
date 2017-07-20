//
//  WLTimeLineView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLTimeLineView.h"
#import "WLLineEntity.h"
#import "UIColor+YYAdd.h"
#import "WLHighLightedLayer.h"

@interface WLTimeLineView ()

@property (nonatomic, assign) CGFloat volumeWidth;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) CALayer *breathingPoint;
@property (nonatomic, strong) WLHighLightedLayer *highLightLayer;
@property (nonatomic, strong) UIColor *riseColor;
@property (nonatomic, strong) UIColor *fallColor;
@property (nonatomic, strong) UIColor *timeLineColor;
@property (nonatomic, strong) UIColor *avgLineColor;

@end

@implementation WLTimeLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self setCurrentDataMaxAndMin];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGridBackground:context rect:rect];
    [self drawTimeLabel:context];
    if (self.dataArray.count>0) {
        [self drawTimeLine:context];
    }
    [self drawLabelPrice:context];
}

- (void)drawGridBackground:(CGContextRef)context rect:(CGRect)rect
{
    [super drawGridBackground:context rect:rect];
    [self drawline:context startPoint:CGPointMake(self.contentWidth * 0.5 + self.contentLeft - self.borderWidth, self.contentTop) stopPoint:CGPointMake(self.contentWidth * 0.5 + self.contentLeft - self.borderWidth, self.uperChartHeightScale * self.contentHeight + self.contentTop) color:self.borderColor  lineWidth:self.borderWidth/2.0];
    
    [self drawline:context startPoint:CGPointMake(self.contentWidth * 0.5 + self.contentLeft, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht+self.contentTop) stopPoint:CGPointMake(self.contentWidth * 0.5 + self.contentLeft, self.contentBottom) color:self.borderColor  lineWidth:self.borderWidth/2.0];
    CGContextSetLineDash(context, 0, nil, 0);
}

- (void)drawTimeLine:(CGContextRef)context
{
    CGContextSaveGState(context);
    
    self.candleCoordsScale = (self.uperChartHeightScale * self.contentHeight)/(self.maxPrice-self.minPrice);
    self.volumeCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxVolume - 0);
    
    CGMutablePathRef fillPath = CGPathCreateMutable();
    
    for (NSInteger i = 0 ; i< self.dataArray.count; i ++) {
        
        WLTimeLineEntity  * entity  = [self.dataArray objectAtIndex:i];
        
        CGFloat left = (self.volumeWidth * i + self.contentLeft) + self.volumeWidth / 6.0;
        
        CGFloat candleWidth = self.volumeWidth - self.volumeWidth / 6.0;
        CGFloat startX = left + candleWidth/2.0 ;
        CGFloat  yPrice = 0;
        
        UIColor * color;
        if (entity.lastPirce >= entity.preClosePx) {
            color = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
        }else{
            color = [UIColor colorWithRed:233/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
        }
        
        if (i > 0){
            WLTimeLineEntity * lastEntity = [self.dataArray objectAtIndex:i -1];
            CGFloat lastX = startX - self.volumeWidth;
            
            CGFloat lastYPrice = (self.maxPrice - lastEntity.lastPirce)*self.candleCoordsScale + self.contentTop;
            
            yPrice = (self.maxPrice - entity.lastPirce)*self.candleCoordsScale  + self.contentTop;
            //曲线
            [self drawline:context startPoint:CGPointMake(lastX, lastYPrice) stopPoint:CGPointMake(startX, yPrice) color:self.timeLineColor lineWidth:1];
            
            //均线
            if (lastEntity.avgPirce > 0 && entity.avgPirce > 0) {
                CGFloat lastYAvg = (self.maxPrice - lastEntity.avgPirce)*self.candleCoordsScale  + self.contentTop;
                CGFloat  yAvg = (self.maxPrice - entity.avgPirce)*self.candleCoordsScale  + self.contentTop;
                
                [self drawline:context startPoint:CGPointMake(lastX, lastYAvg) stopPoint:CGPointMake(startX, yAvg) color:self.avgLineColor lineWidth:1];
            }
            
            
            if (entity.lastPirce > lastEntity.lastPirce) {
                color = self.riseColor;
            }else if (entity.lastPirce <= lastEntity.lastPirce){
                color = self.fallColor;
            }
            if (1 == i) {
                CGPathMoveToPoint(fillPath, NULL, self.contentLeft, (self.uperChartHeightScale * self.contentHeight) + self.contentTop);
                CGPathAddLineToPoint(fillPath, NULL, self.contentLeft,lastYPrice);
                CGPathAddLineToPoint(fillPath, NULL, lastX, lastYPrice);
            }else{
                CGPathAddLineToPoint(fillPath, NULL, startX, yPrice);
            }
            if ((self.dataArray.count - 1) == i) {
                CGPathAddLineToPoint(fillPath, NULL, startX, yPrice);
                CGPathAddLineToPoint(fillPath, NULL, startX, (self.uperChartHeightScale * self.contentHeight) + self.contentTop);
                CGPathCloseSubpath(fillPath);
            }
        }
#pragma warning 成交量还有其他颜色，现在不知道怎么算
        //成交量
        CGFloat volume = ((entity.volume - 0) * self.volumeCoordsScale);
        [self drawRect:context rect:CGRectMake(left, self.contentBottom - volume , candleWidth, volume) color:color];
        
//        //十字线
        if (self.highlightLineCurrentEnabled) {
            if (i == self.highlightLineCurrentIndex) {
//                if (i == 0) {
//                    yPrice = (self.maxPrice - entity.lastPirce)*self.candleCoordsScale  + self.contentTop;
//                }
//                WLTimeLineEntity * entity;
//                if (i < self.dataArray.count) {
//                    entity = [self.dataArray objectAtIndex:i];
//                }
//                [self drawHighlighted:context point:CGPointMake(startX, yPrice) idex:i value:entity color:[UIColor colorWithRGB:0x888888] lineWidth:1];
//                if ([self.delegate respondsToSelector:@selector(chartValueSelected:entry:entryIndex:) ]) {
//                    [self.delegate chartValueSelected:self entry:entity entryIndex:i];
//                }
            }
        }
        
        if (self.endPointShowEnabled) {
            if (i == self.dataArray.count - 1 && i != self.countOfTimes-1) {
                self.breathingPoint.frame = CGRectMake(startX-4/2, yPrice-4/2,4,4);
            }
        }
        
    }
    
    if ( self.dataArray.count > 0) {
        [self drawLinearGradient:context path:fillPath alpha:0.3 startColor:self.timeLineColor.CGColor endColor:[UIColor whiteColor].CGColor];
    }
    CGPathRelease(fillPath);
    
    CGContextRestoreGState(context);
}

- (void)drawTimeLabel:(CGContextRef)context
{
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]};
    
    NSMutableAttributedString * startTimeAttStr = [[NSMutableAttributedString alloc]initWithString:@"09:30" attributes:drawAttributes];
    CGSize sizeStartTimeAttStr = [startTimeAttStr size];
    CGFloat top = self.uperChartHeightScale * self.contentHeight+self.contentTop + self.xAxisHeitht - 13;
    [self drawLabel:context attributesText:startTimeAttStr rect:CGRectMake(self.contentLeft, top, sizeStartTimeAttStr.width, sizeStartTimeAttStr.height)];
    
    NSMutableAttributedString * midTimeAttStr = [[NSMutableAttributedString alloc]initWithString:@"11:30/13:00" attributes:drawAttributes];
    CGSize sizeMidTimeAttStr = [midTimeAttStr size];
    [self drawLabel:context attributesText:midTimeAttStr rect:CGRectMake(self.contentWidth/2.0 + self.contentLeft - sizeMidTimeAttStr.width/2.0, top, sizeMidTimeAttStr.width, sizeMidTimeAttStr.height)];
    
    NSMutableAttributedString * stopTimeAttStr = [[NSMutableAttributedString alloc]initWithString:@"15:00" attributes:drawAttributes];
    CGSize sizeStopTimeAttStr = [stopTimeAttStr size];
    [self drawLabel:context attributesText:stopTimeAttStr rect:CGRectMake(self.contentRight -sizeStopTimeAttStr.width, top, sizeStopTimeAttStr.width, sizeStopTimeAttStr.height)];
}

- (CGFloat)volumeWidth
{
    return self.contentWidth/241;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}

- (void)setCurrentDataMaxAndMin
{
    if (self.dataArray.count > 0) {
        self.maxPrice = CGFLOAT_MIN;
        self.minPrice = CGFLOAT_MAX;
        self.maxVolume = CGFLOAT_MIN;
        self.offsetMaxPrice = CGFLOAT_MIN;
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            WLTimeLineEntity  * entity = [self.dataArray objectAtIndex:i];
            
            self.offsetMaxPrice = self.offsetMaxPrice >fabs(entity.lastPirce-entity.preClosePx)?self.offsetMaxPrice:fabs(entity.lastPirce-entity.preClosePx);
            if (entity.avgPirce) {
                self.offsetMaxPrice = self.offsetMaxPrice > fabs(entity.avgPirce - entity.preClosePx)?self.offsetMaxPrice:fabs(entity.avgPirce - entity.preClosePx);
            }
            self.maxVolume = self.maxVolume >entity.volume ? self.maxVolume : entity.volume;
        }
        self.maxPrice =((WLTimeLineEntity *)[self.dataArray firstObject]).preClosePx + self.offsetMaxPrice;
        self.minPrice =((WLTimeLineEntity *)[self.dataArray firstObject]).preClosePx - self.offsetMaxPrice;
        
        if (self.maxPrice == self.minPrice) {
            self.maxPrice = self.maxPrice + 0.01;
            self.minPrice = self.minPrice - 0.01;
        }
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            WLTimeLineEntity  * entity = [self.dataArray objectAtIndex:i];
            if (entity.avgPirce != 0) {
                entity.avgPirce = entity.avgPirce < self.minPrice ? self.minPrice :entity.avgPirce;
                entity.avgPirce = entity.avgPirce > self.maxPrice ? self.maxPrice :entity.avgPirce;
            }
        }
    }
}



- (void)commonInit {
    self.riseColor = [UIColor colorWithRGB:0xFB5457];
    self.fallColor = [UIColor colorWithRGB:0x35C484];
    self.timeLineColor = [UIColor colorWithRGB:0x646EEB];
    self.avgLineColor = [UIColor colorWithRGB:0xFED74F];
    self.borderWidth = 1.f;
    self.borderColor = [UIColor colorWithRGB:0x888888];
    self.endPointShowEnabled = YES;
    [self addGestureRecognizer:self.longPressGesture];
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.panGesture];
}

- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanPressGestureAction:)];
    }
    return _panGesture;
}

- (void)handlePanPressGestureAction:(UIPanGestureRecognizer *)recognizer{
    if (!self.highlightLineCurrentEnabled) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint  point = [recognizer locationInView:self];
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
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

- (void)handleLongPressGestureAction:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint  point = [recognizer locationInView:self];
        [self addSubview:self.highLightLayer];
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(chartViewDidSelected:)]) {
                [self.delegate chartViewDidSelected:self];
            }
            self.highlightLineCurrentEnabled = YES;
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
    
    self.highlightLineCurrentIndex = (NSInteger)((point.x - self.contentLeft)/self.volumeWidth);
//    [self setNeedsDisplay];
    WLTimeLineEntity  * entity;
    if (self.highlightLineCurrentIndex < self.dataArray.count) {
        entity = [self.dataArray objectAtIndex:self.highlightLineCurrentIndex];
    }else{
        return;
    }
    CGFloat  yPrice = (self.maxPrice - entity.lastPirce)*self.candleCoordsScale;
    CGFloat left = (self.volumeWidth * self.highlightLineCurrentIndex) + self.volumeWidth / 6.0;
    
    CGFloat candleWidth = self.volumeWidth - self.volumeWidth / 6.0;
    CGFloat startX = left + candleWidth/2.0 ;
//    [self drawHighlighted:context point:CGPointMake(startX, yPrice) idex:i value:entity color:[UIColor colorWithRGB:0x888888] lineWidth:1];
    
    [self.highLightLayer setValue:entity andPoint:CGPointMake(startX, yPrice)];
    if ([self.delegate respondsToSelector:@selector(chartValueSelected:entry:entryIndex:) ]) {
        [self.delegate chartValueSelected:self entry:entity entryIndex:self.highlightLineCurrentIndex];
    }
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
//    [self setNeedsDisplay];
    [self.highLightLayer removeFromSuperview];
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                     alpha:(CGFloat)alpha
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

- (CALayer *)breathingPoint
{
    if (!_breathingPoint) {
        _breathingPoint = [CAScrollLayer layer];
        [self.layer addSublayer:_breathingPoint];
        _breathingPoint.backgroundColor = [UIColor whiteColor].CGColor;
        _breathingPoint.cornerRadius = 2;
        _breathingPoint.masksToBounds = YES;
        _breathingPoint.borderWidth = 1;
        _breathingPoint.borderColor = [UIColor colorWithRGB:0x646EEB].CGColor;
        [_breathingPoint addAnimation:[self groupAnimationDurTimes:1.5f] forKey:@"breathingPoint"];
    }
    return _breathingPoint;
}
-(CABasicAnimation *)breathingLight:(float)time
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.3f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}
-(CAAnimationGroup *)groupAnimationDurTimes:(float)time;
{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    
    NSArray * array = @[[self breathingLight:time],scaleAnim];
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations= array;
    animation.duration=time;
    animation.repeatCount=MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

- (WLHighLightedLayer *)highLightLayer{
    if (!_highLightLayer) {
        _highLightLayer = [WLHighLightedLayer new];
        _highLightLayer.frame = CGRectMake(self.contentLeft, self.contentTop, self.contentWidth, self.contentHeight);
        _highLightLayer.uperChartHeightScale = self.uperChartHeightScale;
        _highLightLayer.xAxisHeitht = self.xAxisHeitht;
    }
    return _highLightLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
