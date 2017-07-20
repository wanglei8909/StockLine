//
//  HorizTimeRightTableView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/7.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeRightViewModel.h"

typedef NS_ENUM(NSInteger, HorizTimeRightShowType) {
    HorizTimeRightShowType_Five,
    HorizTimeRightShowType_Detail,
};

@interface HorizTimeRightTableView : UITableView

@property (nonatomic, assign) HorizTimeRightShowType showType;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat footerHeight;


- (instancetype)initWithFrame:(CGRect)frame andStockCode:(NSString *)code;

- (void)changeIndex:(NSInteger)index;

@end
