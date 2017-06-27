//
//  IndexTableView.m
//  AliPayDemo
//
//  Created by guoyutao on 2017/6/26.
//  Copyright © 2017年 guoyutao. All rights reserved.
//

#import "IndexTableView.h"
#import <MJRefresh/MJRefresh.h>
@interface IndexTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) int numberRows;
@end

@implementation IndexTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        _numberRows = 50;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = (1000 - 140) / 20;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    }
    return self;
}

- (void)refreshHeader{
    __block IndexTableView/*主控制器*/ *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.mj_header endRefreshing];
        [weakSelf reloadData];
    });
}

- (void)loadMoreData{
    self.numberRows += 10;
    [self reloadData];
    self.changeContentSize(self.contentSize);
}

- (void)setScrollViewContentOffSetWithPoint:(CGPoint) point {
    if (!self.mj_header.isRefreshing) {
        self.contentOffset = point;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld - reusablecell",(long)indexPath.row];
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberRows;
}



@end
