//
//  WLHighLightedLayer.m
//  HNNniu
//
//  Created by wanglei on 2017/7/11.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLHighLightedLayer.h"
#import "WLLineEntity.h"
#import "UIColor+YYAdd.h"

@interface WLHighLightedLayer ()

@property (nonatomic, assign) CGPoint iPoint;
@property (nonatomic, weak) id iEntry;

@end

@implementation WLHighLightedLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setValue:(id) entry andPoint:(CGPoint) point{
    NSLog(@"%f,%f",point.x,point.y);
    self.iPoint = point;
    self.iEntry = entry;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawHighlighted:context point:self.iPoint value:self.iEntry color:[UIColor colorWithRGB:0x888888] lineWidth:1];
}

- (void)drawInContext:(CGContextRef)ctx{
//    [self drawHighlighted:ctx point:self.iPoint value:self.iEntry color:[UIColor colorWithRGB:0x888888] lineWidth:1];
}

- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
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
    CGContextMoveToPoint(context, point.x, 0);
    CGContextAddLineToPoint(context, point.x, self.frame.size.height);
    CGContextStrokePath(context);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, point.y);
    CGContextAddLineToPoint(context, self.frame.size.width, point.y);
    CGContextStrokePath(context);
    
    CGFloat radius = 3.0;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(point.x-(radius/2.0), point.y-(radius/2.0), radius, radius));
    
    
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSBackgroundColorAttributeName:[UIColor colorWithRGB:0x888888],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NSMutableAttributedString * leftMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:leftMarkerStr attributes:drawAttributes];
    
    CGSize leftMarkerStrAttSize = [leftMarkerStrAtt size];
    [self drawLabel:context attributesText:leftMarkerStrAtt rect:CGRectMake(0,point.y - leftMarkerStrAttSize.height/2.0, leftMarkerStrAttSize.width, leftMarkerStrAttSize.height)];
    
    NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:bottomMarkerStr attributes:drawAttributes];
    
    CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
    CGRect rect = CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0,  ((self.uperChartHeightScale * self.frame.size.height)), bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height);
    if (rect.size.width + rect.origin.x > self.frame.size.width) {
        rect.origin.x = self.frame.size.width -rect.size.width;
    }
    if (rect.origin.x < 0) {
        rect.origin.x = 0;
    }
    [self drawLabel:context attributesText:bottomMarkerStrAtt rect:rect];
    
    
    NSMutableAttributedString * volumeMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:volumeMarkerStr attributes:drawAttributes];
    CGSize volumeMarkerStrAttSize = [volumeMarkerStrAtt size];
    [self drawLabel:context attributesText:volumeMarkerStrAtt rect:CGRectMake(0,  self.frame.size.height * self.uperChartHeightScale+self.xAxisHeitht, volumeMarkerStrAttSize.width, volumeMarkerStrAttSize.height)];
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
    if ((rect.origin.x + rect.size.width) > self.frame.size.width) {
        return;
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

- (NSString *)handleStrWithPrice:(CGFloat)price
{
    return [NSString stringWithFormat:@"%.2f ",price];
}

- (NSString *)handleShowNumWithVolume:(CGFloat)volume
{
    volume = volume/100.0;
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
    volume = volume/100.0;
    
    if (volume < 10000.0) {
        return @"手 ";
    }else if (volume > 10000.0 && volume < 100000000.0){
        return @"万手 ";
    }else{
        return @"亿手 ";
    }
}

@end















