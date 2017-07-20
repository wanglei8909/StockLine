//
//  HorizTimeRightTableView.m
//  HNNniu
//
//  Created by wanglei on 2017/7/7.
//  Copyright © 2017年 HaiNa. All rights reserved.
//

#import "HorizTimeRightTableView.h"
#import "HTimeRightCell.h"
#import "UIColor+YYAdd.h"

@interface HorizTimeRightTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TimeRightViewModel *viewModel;

@end

@implementation HorizTimeRightTableView

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame andStockCode:@""];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andStockCode:(NSString *)code{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate   = self;
        self.dataSource = self;
        self.footerHeight = 22;
        self.viewModel = [[TimeRightViewModel alloc] initWithCode:code];
        self.showType = HorizTimeRightShowType_Five;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
//        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, _footerHeight, self.contentInset.right);
        [self loadData];
    }
    return self;
}

- (void)changeIndex:(NSInteger)index{
    if (index == 0) {
        self.showType = HorizTimeRightShowType_Five;
        self.scrollEnabled = NO;
    }else if(index == 1){
        self.showType = HorizTimeRightShowType_Detail;
        self.scrollEnabled = YES;
    }
    [self.dataArray removeAllObjects];
    [self reloadData];
    [self loadData];
}

- (void)loadData{
    @WeakObj(self);
    if (self.showType == HorizTimeRightShowType_Five) {
        [self.viewModel loadFiveDayCapitalWithSucceed:^(NSArray *array) {
            @StrongObj(weakSelf);
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.dataArray addObjectsFromArray:array];
            [strongSelf reloadData];
        } andFaild:^{
            
        }];
    }else if(self.showType == HorizTimeRightShowType_Detail){
        [self.viewModel loadDetailDataWithSucceed:^(NSArray *array) {
            @StrongObj(weakSelf);
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.dataArray addObjectsFromArray:array];
            [strongSelf reloadData];
        } andFaild:^{
            
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"HTimeRightCell";
    HTimeRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HTimeRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell loadContent:[self.dataArray objectAtIndex:indexPath.row]];
    if (self.showType == HorizTimeRightShowType_Detail) {
        if (indexPath.row%2==0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            cell.contentView.backgroundColor = [UIColor colorWithRGB:0xF5FAFF];
        }
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (self.height)/10;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
