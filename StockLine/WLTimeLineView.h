//
//  WLTimeLineView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "WLLineViewBase.h"

@interface WLTimeLineView : WLLineViewBase

@property (nonatomic, assign)CGFloat offsetMaxPrice;
@property (nonatomic, assign)NSInteger countOfTimes;

@property (nonatomic, assign)BOOL endPointShowEnabled;

@property (nonatomic, copy) NSArray *dataArray;

@end
