//
//  HKLineRightView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HKLineRightViewBlock)(NSInteger index);

@interface HKLineRightView : UIScrollView

@property (nonatomic, copy) HKLineRightViewBlock clickBlock;
@property (nonatomic, assign) BOOL canClick;

@end
