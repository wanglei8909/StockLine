//
//  TimeRightViewModel.h
//  HNNniu
//
//  Created by wanglei on 2017/7/7.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeRightViewModel : NSObject


- (instancetype)initWithCode:(NSString *)code;

-(void)loadFiveDayCapitalWithSucceed:(void(^)(NSArray *array))succeBlock  andFaild:(void(^)()) faildBlock;
-(void)loadDetailDataWithSucceed:(void(^)(NSArray *array))succeBlock  andFaild:(void(^)()) faildBlock;


@end
