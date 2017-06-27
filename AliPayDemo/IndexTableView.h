//
//  IndexTableView.h
//  AliPayDemo
//
//  Created by guoyutao on 2017/6/26.
//  Copyright © 2017年 guoyutao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChangeContentSize)(CGSize contentSize);

@interface IndexTableView : UITableView
@property (nonatomic,copy) ChangeContentSize changeContentSize;



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)loadMoreData;

- (void)setScrollViewContentOffSetWithPoint:(CGPoint) point;


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
@end
