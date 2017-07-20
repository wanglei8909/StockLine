//
//  WLTabbarView.h
//  HNNniu
//
//  Created by wanglei on 2017/7/10.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WLTabbarViewBlock)(NSInteger index);

@interface WLTabbarView : UIView

@property (nonatomic, copy)WLTabbarViewBlock clickBlock;


@end
