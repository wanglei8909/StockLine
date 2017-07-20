//
//  WLShowHightLightView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/11.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLShowHightLightView.h"
#import "UIColor+YYAdd.h"

@implementation WLShowHightLightView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xF9F9F9];
    }
    return self;
}

- (void)setUpData:(id)entry{
    if ([entry isKindOfClass:[WLTimeLineEntity class]]) {
        self.showType = WLShowHightLightView_Time;
    }else if ([entry isKindOfClass:[WLLineEntity class]]){
        self.showType = WLShowHightLightView_KLine;
    }
    self.entry = entry;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.showType == WLShowHightLightView_Time) {
        [self drawTimeHighLighted:context];
    }else if (self.showType == WLShowHightLightView_KLine){
        [self drawKLineHighLighted:context];
    }
}

- (void)drawKLineHighLighted:(CGContextRef)context{
    WLLineEntity *entry = (WLLineEntity *)self.entry;
    self.kline_kai          = [NSString stringWithFormat:@"%.2f",entry.open];
    self.kline_gao          = [NSString stringWithFormat:@"%.2f",entry.high];
    CGFloat fu = (entry.close - entry.open)/entry.open * 100;
    self.kline_fu           = [NSString stringWithFormat:@"%.2f%%",fu];
    self.kline_chengjiao    = [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entry.volume],[self handleShowWithVolume:entry.volume]];
    self.kline_shou         = [NSString stringWithFormat:@"%.2f",entry.close];
    self.kline_di           = [NSString stringWithFormat:@"%.2f",entry.low];
    self.kline_e            = [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entry.volueRate],[self handleShowWithVolume:entry.volueRate]];
    self.kline_huanshou     = [NSString stringWithFormat:@"%.2f",entry.high];
    if (!self.kline_kai || !self.kline_gao || !self.kline_fu || !self.kline_chengjiao || !self.kline_di || !self.kline_e || !self.kline_huanshou || !self.kline_shou) {
        return;
    }
    //--------------- 开收 ----------------------
    CGFloat iTop = 0;
    CGFloat iLeft = 35;
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    NSAttributedString *attributesText = [[NSAttributedString alloc] initWithString:@"开" attributes:drawAttributes];
    CGSize size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iTop += 15;
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"收" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iLeft += size.width + 10;
    iTop -= 15;
    UIColor *textColor = [UIColor colorWithRGB:0xE84050];
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:textColor};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_kai attributes:drawAttributes];
    CGSize size1 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size1.width, size1.height)];
    
    iTop += 15;
    textColor = [UIColor colorWithRGB:0xE84050];
    if (entry.close < entry.open) {
        textColor = [UIColor colorWithRGB:0x2FA874];
    }
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:textColor};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_shou attributes:drawAttributes];
    CGSize size2 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size2.width, size2.height)];
    
    //--------------- 高低 ----------------------
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    iTop -= 15;
    iLeft += size1.width > size2.width?size1.width + 20:size2.width + 20;
    attributesText = [[NSAttributedString alloc] initWithString:@"高" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iTop += 15;
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"低" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iLeft += size.width + 10;
    iTop -= 15;
    textColor = [UIColor colorWithRGB:0xE84050];
    if (entry.high < entry.open) {
        textColor = [UIColor colorWithRGB:0x2FA874];
    }
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:textColor};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_gao attributes:drawAttributes];
    size1 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size1.width, size1.height)];
    
    iTop += 15;
    textColor = [UIColor colorWithRGB:0xE84050];
    if (entry.low < entry.open) {
        textColor = [UIColor colorWithRGB:0x2FA874];
    }
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:textColor};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_di attributes:drawAttributes];
    size2 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size2.width, size2.height)];
    
    iTop -= 15;
    iLeft += size1.width > size2.width?size1.width + 20:size2.width + 20;
    
    //--------------- 幅额 ----------------------
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"幅" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iTop += 15;
    
    attributesText = [[NSAttributedString alloc] initWithString:@"额" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iLeft += size.width + 10;
    iTop -= 15;
    textColor = [UIColor colorWithRGB:0xE84050];
    if (entry.close < entry.open) {
        textColor = [UIColor colorWithRGB:0x2FA874];
    }
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:textColor};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_fu attributes:drawAttributes];
    size1 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size1.width, size1.height)];
    
    iTop += 15;
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x444444]};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_e attributes:drawAttributes];
    size2 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size2.width, size2.height)];
    
    iTop -= 15;
    iLeft += size1.width > size2.width?size1.width + 20:size2.width + 20;
    
    //--------------- 成交换手 ----------------------
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"成交" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iTop += 15;
//    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
//    attributesText = [[NSAttributedString alloc] initWithString:@"换手" attributes:drawAttributes];
//    size = [attributesText size];
//    [attributesText drawInRect:CGRectMake(iLeft, iTop, size.width, size.height)];
    
    iLeft += size.width + 10;
    iTop -= 15;
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x444444]};
    attributesText = [[NSAttributedString alloc] initWithString:self.kline_chengjiao attributes:drawAttributes];
    size1 = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iTop, size1.width, size1.height)];
    
//    iTop += 15;
//    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
//    attributesText = [[NSAttributedString alloc] initWithString:self.kline_huanshou attributes:drawAttributes];
//    size2 = [attributesText size];
//    [attributesText drawInRect:CGRectMake(iLeft, iTop, size2.width, size2.height)];
}

- (void)drawTimeHighLighted:(CGContextRef)context{
    WLTimeLineEntity *entry = (WLTimeLineEntity *)self.entry;
    self.time_time          = entry.currtTime;
    self.time_gao           = [NSString stringWithFormat:@"%.2f",entry.lastPirce];
    CGFloat fu              = (entry.lastPirce - entry.open)/entry.open * 100;
    self.time_fu            = [NSString stringWithFormat:@"%.2f%%",fu];
    self.time_e             =  [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entry.volueRate],[self handleShowWithVolume:entry.volueRate]];
    self.time_liang         = [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entry.volume],[self handleShowWithVolume:entry.volume]];
    //|| self.time_gao == nil || self.time_liang == nil ||self.time_e==nil || self.time_fu ==  nil
    if (self.time_time == nil ) {
        return;
    }
    CGFloat iH = 8;
    CGFloat iLeft = 35;
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x444444]};
    NSAttributedString *attributesText = [[NSAttributedString alloc] initWithString:self.time_time attributes:drawAttributes];
    CGSize size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 20;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"价" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 7;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xE84050]};
    attributesText = [[NSAttributedString alloc] initWithString:self.time_gao attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 15;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"幅" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 7;
    
    UIColor *textColor = [UIColor colorWithRGB:0xE84050];
    if (entry.lastPirce < entry.open) {
        textColor = [UIColor colorWithRGB:0x2FA874];
    }
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:textColor};
    attributesText = [[NSAttributedString alloc] initWithString:self.time_fu attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 15;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"额" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 7;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x444444]};
    attributesText = [[NSAttributedString alloc] initWithString:self.time_e attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 15;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0xA8A8A8]};
    attributesText = [[NSAttributedString alloc] initWithString:@"量" attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
    iLeft += size.width + 7;
    
    drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRGB:0x444444]};
    attributesText = [[NSAttributedString alloc] initWithString:self.time_liang attributes:drawAttributes];
    size = [attributesText size];
    [attributesText drawInRect:CGRectMake(iLeft, iH, size.width, self.frame.size.height)];
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
