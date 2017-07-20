//
//  WLKLineHighLightedLayer.m
//  HNNniu
//
//  Created by wanglei on 2017/7/12.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLKLineHighLightedLayer.h"
#import "WLLineEntity.h"
#import "UIColor+YYAdd.h"

@interface WLKLineHighLightedLayer ()

@property (nonatomic, assign) CGPoint iPoint;
@property (nonatomic, weak) id iEntry;

@end

@implementation WLKLineHighLightedLayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.decelerationRate = 0.9938;
        self.bounces = NO;
    }
    return self;
}

//- (void)setValue:(id) entry andPoint:(CGPoint) point{
//    NSLog(@"%f,%f",point.x,point.y);
//    self.iPoint = point;
//    self.iEntry = entry;
//    [self setNeedsDisplay];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSLog(@"%@",change);
//    if([keyPath isEqualToString:@"candleWidth"])
//    {
//        CGFloat candleWidth = [[change objectForKey:@"new"] floatValue];
//        [self setContentSize:CGSizeMake(self.totalNum * candleWidth - self.width, 0)];
//    }
//}


//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self drawHighlighted:context point:self.iPoint value:self.iEntry color:[UIColor colorWithRGB:0x888888] lineWidth:1];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
