//
//  TimeRightViewModel.m
//  HNNniu
//
//  Created by wanglei on 2017/7/7.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "TimeRightViewModel.h"
#import "HTimeRightAdapterModel.h"
#import "UIColor+YYAdd.h"

@interface TimeRightViewModel()

@property (nonatomic, strong) NSString *stockCode;

@end

@implementation TimeRightViewModel


- (instancetype)initWithCode:(NSString *)code{
    self = [super init];
    if (self) {
        self.stockCode = code;
    }
    return self;
}

-(void)loadFiveDayCapitalWithSucceed:(void(^)(NSArray *array))succeBlock  andFaild:(void(^)()) faildBlock{
    [JCLStockDataManager JCLGetStockFiveInfo:JCLMarketURL code:self.stockCode success:^(NSArray *obj) {
        NSArray *buyArr = [JCLHttpsManage splitArrayM:obj begin:3 end:5];
        NSArray *sellArr = [JCLHttpsManage splitArrayM:obj begin:8 end:5];
        sellArr = [[sellArr reverseObjectEnumerator] allObjects];
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        [mArray addObjectsFromArray:sellArr];
        [mArray addObjectsFromArray:buyArr];
        NSMutableArray *adapterArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < mArray.count; i++) {
            NSArray *sArray = [mArray objectAtIndex:i];
            NSLog(@"%@",sArray);
            HTimeRightAdapterModel *model = [[HTimeRightAdapterModel alloc] init];
            model.midValue = [sArray objectAtIndex:0];
            model.rightValue = [sArray objectAtIndex:1];
            model.rightColor = [UIColor colorWithRGB:0xFFC638];
            NSString *left = @"";
            if (i < 5) {
                left = [NSString stringWithFormat:@"卖%d",5-i];
                model.midColor = [UIColor colorWithRGB:0xE84050];
            }else{
                left = [NSString stringWithFormat:@"买%d",i-4];
                model.midColor = [UIColor colorWithRGB:0x2FA874];
            }
            model.leftValue = left;
            model.leftColor = [UIColor colorWithRGB:0xA8A8A8];
            [adapterArray addObject:model];
        }
        succeBlock(adapterArray);
    } failure:^(NSError *error) {
        faildBlock();
    }];
}

-(void)loadDetailDataWithSucceed:(void(^)(NSArray *array))succeBlock  andFaild:(void(^)()) faildBlock{
    if (self.stockCode.length) {
        [JCLStockDataManager JCLGetStockDetailInfo:JCLMarketURL code:self.stockCode page:[NSString stringWithFormat:@"%d", 0] number:@"40" success:^(id obj) {
            NSArray *array = [obj objectForKey:@"data"];
            NSMutableArray *adapterArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in array) {
                HTimeRightAdapterModel *model = [[HTimeRightAdapterModel alloc] init];
                model.midValue = [NSString stringWithFormat:@"%@",[dict objectForKey:@"now"]];
                model.midColor = [UIColor colorWithRGB:0xE84050];
                
                model.rightValue = [NSString stringWithFormat:@"%@",[dict objectForKey:@"nowvol"]];
                model.rightColor = [UIColor colorWithRGB:0x2FA874];
                
                model.leftValue = [self getTime:[NSString stringWithFormat:@"%@",[dict objectForKey:@"minute"]]];
                model.leftColor = [UIColor colorWithRGB:0xA8A8A8];
                [adapterArray addObject:model];
            }
            succeBlock(adapterArray);
        } failure:^(NSError *error) {
            faildBlock();
        }];
    }
}

- (NSString *)getTime:(NSString *)time{
    NSInteger shi = [time integerValue] / 60;
    NSInteger fen = [time integerValue] - shi*60;
    if (fen < 10) {
        return [NSString stringWithFormat:@"%ld:0%ld", (long)shi, (long)fen];
    } else {
        return [NSString stringWithFormat:@"%ld:%ld", (long)shi, (long)fen];
    }
}

@end
