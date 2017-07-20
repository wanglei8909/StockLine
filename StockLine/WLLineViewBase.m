//
//  WLLineViewBase.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLLineViewBase.h"
#import "WLLineEntity.h"
#import "UIColor+YYAdd.h"

@implementation WLLineViewBase

- (void)setLineType:(KlineBottomType)lineType{
    _lineType = lineType;
    [self setNeedsDisplay];
}

- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect;
{
    UIColor * backgroundColor = self.gridBackgroundColor?:[UIColor whiteColor];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    //画边框
    CGContextSetLineWidth(context, self.borderWidth);
    CGFloat arr[] = {3,1};
    CGContextSetLineDash(context, 0, arr, 2);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, self.contentTop, self.contentWidth, (self.uperChartHeightScale * self.contentHeight)));
    
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, (self.uperChartHeightScale * self.contentHeight +self.xAxisHeitht + self.contentTop), self.contentWidth, (self.contentBottom - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht - self.contentTop)));
    
    //画中间的线
    [self drawline:context startPoint:CGPointMake(self.contentLeft,(self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop) stopPoint:CGPointMake(self.contentRight, (self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop) color:self.borderColor lineWidth:self.borderWidth/2.0];
    CGContextSaveGState(context);
    CGContextSetLineDash(context, 0, nil, 0);
}

- (void)drawKLineLabelPrice:(CGContextRef)context
{
    UIColor * labelBGColor = [UIColor colorWithWhite:1.0 alpha:0.3];
//    labelBGColor = [UIColor redColor];
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]};
    
    NSString * maxPriceStr = [self handleStrWithPrice:self.maxPrice];
    NSMutableAttributedString * maxPriceAttStr = [[NSMutableAttributedString alloc]initWithString:maxPriceStr attributes:drawAttributes];
    CGSize sizeMaxPriceAttStr = [maxPriceAttStr size];
    CGRect maxPriceRect = CGRectMake(self.contentLeft - (sizeMaxPriceAttStr.width+2), self.contentTop, sizeMaxPriceAttStr.width, sizeMaxPriceAttStr.height);
    [self drawRect:context rect:maxPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:maxPriceAttStr rect:maxPriceRect];
    
    NSString * midPriceStr = [self handleStrWithPrice:(self.maxPrice+self.minPrice)/2.0];
    NSMutableAttributedString * midPriceAttStr = [[NSMutableAttributedString alloc]initWithString:midPriceStr attributes:drawAttributes];
    CGSize sizeMidPriceAttStr = [midPriceAttStr size];
    CGRect midPriceRect = CGRectMake(self.contentLeft - (sizeMidPriceAttStr.width+2), ((self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop)-sizeMidPriceAttStr.height/2.0, sizeMidPriceAttStr.width, sizeMidPriceAttStr.height);
    [self drawRect:context rect:midPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:midPriceAttStr rect:midPriceRect];
    
    NSString * minPriceStr = [self handleStrWithPrice:self.minPrice];
    NSMutableAttributedString * minPriceAttStr = [[NSMutableAttributedString alloc]initWithString:minPriceStr attributes:drawAttributes];
    CGSize sizeMinPriceAttStr = [minPriceAttStr size];
    CGRect minPriceRect = CGRectMake(self.contentLeft - (sizeMinPriceAttStr.width+2), ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinPriceAttStr.height ), sizeMinPriceAttStr.width, sizeMinPriceAttStr.height);
    [self drawRect:context rect:minPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:minPriceAttStr rect:minPriceRect];
    
    if (self.lineType == KlineBottomType_VOL){
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[self handleShowWithVolume:self.maxVolume] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [self handleShowNumWithVolume:self.maxVolume];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }else if (self.lineType == KlineBottomType_BOLL){
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.minBOLLValue] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [NSString stringWithFormat:@"%.2f",self.maxBOLLValue];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }
    else if (self.lineType == KlineBottomType_MACD){
        CGFloat bottomY = self.contentBottom - (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/2.f;
        NSMutableAttributedString * midMacdAttStr = [[NSMutableAttributedString alloc]initWithString:@"0" attributes:drawAttributes];
        CGSize midMacdAttStrSize = [midMacdAttStr size];
        CGRect midMacdAttStrRect = CGRectMake(self.contentLeft - (midMacdAttStrSize.width+2), bottomY - midMacdAttStrSize.height * 0.5, midMacdAttStrSize.width, midMacdAttStrSize.height);
        [self drawRect:context rect:midMacdAttStrRect color:labelBGColor];
        [self drawLabel:context attributesText:midMacdAttStr rect:midMacdAttStrRect];
        
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",-(self.maxMACDValue)] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [NSString stringWithFormat:@"%.2f",self.maxMACDValue];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }
    else if (self.lineType == KlineBottomType_KDJ){
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.minKDJValue] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [NSString stringWithFormat:@"%.2f",self.maxKDJValue];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }
    else if (self.lineType == KlineBottomType_RSI){
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.minRSIValue] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [NSString stringWithFormat:@"%.2f",self.maxRSIValue];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }
    else if (self.lineType == KlineBottomType_WR){
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.minWRValue] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [NSString stringWithFormat:@"%.2f",self.maxWRValue];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }
    else if (self.lineType == KlineBottomType_OBV){
        NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:[self handleShowWithVolume:self.maxOBVValue] attributes:drawAttributes];
        CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
        CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
        [self drawRect:context rect:zeroVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:zeroVolumeAttStr rect:zeroVolumeRect];
        
        NSString * maxVolumeStr = [self handleShowNumWithVolume:self.maxOBVValue];
        NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
        CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
        CGRect maxVolumeRect = CGRectMake(self.contentLeft - (maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht + self.contentTop, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
        [self drawRect:context rect:maxVolumeRect color:labelBGColor];
        [self drawLabel:context attributesText:maxVolumeAttStr rect:maxVolumeRect];
    }
}

- (void)drawLabelPrice:(CGContextRef)context
{
    UIColor * labelBGColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x888888]};

    NSString * maxPriceStr = [self handleStrWithPrice:self.maxPrice];
    NSMutableAttributedString * maxPriceAttStr = [[NSMutableAttributedString alloc]initWithString:maxPriceStr attributes:drawAttributes];
    CGSize sizeMaxPriceAttStr = [maxPriceAttStr size];
    CGRect maxPriceRect = CGRectMake(self.contentLeft, self.contentTop - 13, sizeMaxPriceAttStr.width, sizeMaxPriceAttStr.height);
    [self drawRect:context rect:maxPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:maxPriceAttStr rect:maxPriceRect];
    
    NSString * midPriceStr = [self handleStrWithPrice:(self.maxPrice+self.minPrice)/2.0];
    NSMutableAttributedString * midPriceAttStr = [[NSMutableAttributedString alloc]initWithString:midPriceStr attributes:drawAttributes];
    CGSize sizeMidPriceAttStr = [midPriceAttStr size];
    CGRect midPriceRect = CGRectMake(self.contentLeft, ((self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop)-sizeMidPriceAttStr.height/2.0, sizeMidPriceAttStr.width, sizeMidPriceAttStr.height);
    [self drawRect:context rect:midPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:midPriceAttStr rect:midPriceRect];
    
    NSString * minPriceStr = [self handleStrWithPrice:self.minPrice];
    NSMutableAttributedString * minPriceAttStr = [[NSMutableAttributedString alloc]initWithString:minPriceStr attributes:drawAttributes];
    CGSize sizeMinPriceAttStr = [minPriceAttStr size];
    CGRect minPriceRect = CGRectMake(self.contentLeft, ((self.uperChartHeightScale * self.contentHeight) + self.contentTop), sizeMinPriceAttStr.width, sizeMinPriceAttStr.height);
    [self drawRect:context rect:minPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:minPriceAttStr rect:minPriceRect];
}


- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth
{
    
    NSString * leftMarkerStr = @"";
    NSString * bottomMarkerStr = @"";
    NSString * volumeMarkerStr = @"";
    
    
    if ([value isKindOfClass:[WLTimeLineEntity class]]) {
        WLTimeLineEntity * entity = value;
        leftMarkerStr = [self handleStrWithPrice:entity.lastPirce];
        bottomMarkerStr = entity.currtTime;
        
    }else if([value isKindOfClass:[WLLineEntity class]]){
        WLLineEntity * entity = value;
        leftMarkerStr = [self handleStrWithPrice:entity.close];
        bottomMarkerStr = entity.date;
        volumeMarkerStr = [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entity.volume],[self handleShowWithVolume:entity.volume]];
    }else{
        return;
    }
    
    if (nil == leftMarkerStr || nil == bottomMarkerStr) {
        return;
    }
    bottomMarkerStr = [[@" " stringByAppendingString:bottomMarkerStr] stringByAppendingString:@" "];
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point.x, self.contentTop);
    CGContextAddLineToPoint(context, point.x, self.contentBottom);
    CGContextStrokePath(context);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.contentLeft, point.y);
    CGContextAddLineToPoint(context, self.contentRight, point.y);
    CGContextStrokePath(context);
    
    CGFloat radius = 3.0;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(point.x-(radius/2.0), point.y-(radius/2.0), radius, radius));
    
    
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor colorWithRGB:0x888888],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NSMutableAttributedString * leftMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:leftMarkerStr attributes:drawAttributes];
    
    CGSize leftMarkerStrAttSize = [leftMarkerStrAtt size];
    [self drawLabel:context attributesText:leftMarkerStrAtt rect:CGRectMake(self.contentLeft,point.y - leftMarkerStrAttSize.height/2.0, leftMarkerStrAttSize.width, leftMarkerStrAttSize.height)];
    
    NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:bottomMarkerStr attributes:drawAttributes];
    
    CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
    CGRect rect = CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0,  ((self.uperChartHeightScale * self.contentHeight) + self.contentTop), bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height);
    if (rect.size.width + rect.origin.x > self.contentRight) {
        rect.origin.x = self.contentRight -rect.size.width;
    }
    if (rect.origin.x < self.contentLeft) {
        rect.origin.x = self.contentLeft;
    }
    [self drawLabel:context attributesText:bottomMarkerStrAtt rect:rect];
    
    
//    NSMutableAttributedString * volumeMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:volumeMarkerStr attributes:drawAttributes];
//    CGSize volumeMarkerStrAttSize = [volumeMarkerStrAtt size];
//    [self drawLabel:context attributesText:volumeMarkerStrAtt rect:CGRectMake(self.contentLeft,  self.contentHeight * self.uperChartHeightScale+self.xAxisHeitht, volumeMarkerStrAttSize.width, volumeMarkerStrAttSize.height)];
}

- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect
{
    [attributesText drawInRect:rect];
}

- (void)drawRect:(CGContextRef)context
            rect:(CGRect)rect
           color:(UIColor*)color
{
    if ((rect.origin.x + rect.size.width) > self.contentRight) {
        return;
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}
-(void)drawCiclyPoint:(CGContextRef)context
                point:(CGPoint)point
               radius:(CGFloat)radius
                color:(UIColor*)color{
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth
{
    if (startPoint.x < self.contentLeft ||stopPoint.x >self.contentRight || startPoint.y <self.contentTop || stopPoint.y < self.contentTop) {
        return;
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}

- (NSString *)handleStrWithPrice:(CGFloat)price
{
    return [NSString stringWithFormat:@"%.2f ",price];
}

- (NSString *)handleShowNumWithVolume:(CGFloat)volume
{
    volume = volume;
    if (volume < 10000.0) {
        return [NSString stringWithFormat:@"%.0f ",volume];
    }else if (volume > 10000.0 && volume < 100000000.0){
        return [NSString stringWithFormat:@"%.2f ",volume/10000.0];
    }else{
        return [NSString stringWithFormat:@"%.2f ",volume/100000000.0];
    }
}

- (NSString *)handleShowWithVolume:(CGFloat)volume
{
    volume = volume;
    
    if (volume < 10000.0) {
        return @"手 ";
    }else if (volume > 10000.0 && volume < 100000000.0){
        return @"万手 ";
    }else{
        return @"亿手 ";
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
