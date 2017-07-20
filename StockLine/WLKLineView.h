//
//  WLKLineView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/12.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLLineViewBase.h"

@interface WLKLineView : WLLineViewBase

@property (nonatomic, assign) CGFloat candleWidth;
@property (nonatomic, assign) CGFloat candleMaxWidth;
@property (nonatomic, assign) CGFloat candleMinWidth;

@property (nonatomic, copy) NSArray *mDataArray;

@end
