//
//  HTimeRightSegmentedControl.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTimeRightSegmentedControlBlock)(NSInteger index);

@interface HTimeRightSegmentedControl : UIView

@property (nonatomic, copy)HTimeRightSegmentedControlBlock clickBlock;


- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)items;

@end
