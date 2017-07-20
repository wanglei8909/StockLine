//
//  WLMinuteSelectionView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/13.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WLMinuteSelectionViewClick)(NSInteger index);

@interface WLMinuteSelectionView : UIView

@property (nonatomic, copy) WLMinuteSelectionViewClick clickBlock;


- (instancetype)initWithFrame:(CGRect)frame;

@end
