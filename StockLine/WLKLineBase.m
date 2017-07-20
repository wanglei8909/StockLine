//
//  WLKLineBase.m
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLKLineBase.h"

@interface WLKLineBase()
@property (nonatomic,assign)CGFloat offsetLeft;
@property (nonatomic,assign)CGFloat offsetTop;
@property (nonatomic,assign)CGFloat offsetRight;
@property (nonatomic,assign)CGFloat offsetBottom;
@end

@implementation WLKLineBase

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect  bounds = self.bounds;
        if ((bounds.size.width != self.chartWidth ||
             bounds.size.height != self.chartHeight))
        {
            [self setChartDimens:bounds.size.width height:bounds.size.height];
            [self notifyDataSetChanged];
            
        }
    }
    return self;
}

-(void)layoutSubviews{

    CGRect  bounds = self.bounds;
    if ((bounds.size.width != self.chartWidth ||
         bounds.size.height != self.chartHeight))
    {
        [self setChartDimens:bounds.size.width height:bounds.size.height];
        [self notifyDataSetChanged];
        
    }
}

- (void)notifyDataSetChanged
{
    [self setNeedsDisplay];
}

- (void)setupChartOffsetWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    self.offsetLeft = left;
    self.offsetRight = right;
    self.offsetTop = top;
    self.offsetBottom = bottom;
    [self restrainViewPort:left top:top right:right bottom:bottom];
    
}
- (void)setChartDimens:(CGFloat)width
                height:(CGFloat)height
{
    CGFloat offsetLeft = self.offsetLeft;
    CGFloat offsetTop = self.offsetTop;
    CGFloat offsetRight = self.offsetRight;
    CGFloat offsetBottom = self.offsetBottom;
    self.chartHeight = height;
    self.chartWidth = width;
    [self restrainViewPort:offsetLeft top:offsetTop right:offsetRight bottom:offsetBottom];
}
- (void)restrainViewPort:(CGFloat)offsetLeft
                     top:(CGFloat)offsetTop
                   right:(CGFloat)offsetRight
                  bottom:(CGFloat)offsetBottom
{
    _contentRect.origin.x = offsetLeft;
    _contentRect.origin.y = offsetTop;
    _contentRect.size.width = self.chartWidth - offsetLeft - offsetRight;
    _contentRect.size.height = self.chartHeight - offsetBottom - offsetTop;
}


- (BOOL)isInBoundsX:(CGFloat)x
{
    if ([self isInBoundsLeft:x] && [self isInBoundsRight:x])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)isInBoundsY:(CGFloat)y
{
    if ([self isInBoundsTop:y] &&[self isInBoundsBottom:y])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isInBoundsX:(CGFloat)x y:(CGFloat)y
{
    if ([ self isInBoundsX:x] && [self isInBoundsY:y])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)isInBoundsLeft:(CGFloat)x
{
    return _contentRect.origin.x <= x ? YES : NO;
}
- (BOOL)isInBoundsRight:(CGFloat)x
{
    CGFloat normalizedX = ((NSInteger)(x * 100.f))/100.f;
    return (_contentRect.origin.x + _contentRect.size.width) >= normalizedX ? YES : NO;
}
- (BOOL)isInBoundsTop:(CGFloat)y
{
    return _contentRect.origin.y <= y ? YES : NO;
}
- (BOOL)isInBoundsBottom:(CGFloat)y
{
    CGFloat normalizedY = ((NSInteger)(y * 100.f))/100.f;
    return (_contentRect.origin.y + _contentRect.size.height) >= normalizedY ? YES : NO;
    
}
- (CGFloat)contentTop
{
    return _contentRect.origin.y;
}

- (CGFloat)contentLeft
{
    return _contentRect.origin.x;
}
- (CGFloat)contentRight
{
    return _contentRect.origin.x + _contentRect.size.width;
}
- (CGFloat)contentBottom
{
    return _contentRect.origin.y + _contentRect.size.height;
}
- (CGFloat)contentWidth
{
    return _contentRect.size.width;
}
- (CGFloat)contentHeight
{
    return _contentRect.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
