//
//  ViewController.m
//  AliPayDemo
//
//  Created by guoyutao on 2017/6/26.
//  Copyright © 2017年 guoyutao. All rights reserved.
//

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define functionHeaderViewHeight 95
#define singleAppHeaderViewHeight 60

#import "ViewController.h"
#import "UIButton+Align.h"
#import "IndexTableView.h"
#import <MJRefresh/MJRefresh.h>


@interface ViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UIView *mainNavView;
@property (nonatomic,strong) UIView *coverNavView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *functionHeaderView;
@property (nonatomic,strong) UIView *appHeaderView;
@property (nonatomic,strong) IndexTableView *mainTableView;
@property (nonatomic,assign) CGFloat topOffsetY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topOffsetY = functionHeaderViewHeight + singleAppHeaderViewHeight;
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainNavView];
    [self.view addSubview:self.coverNavView];
    
    
    [self.mainScrollView addSubview:self.headerView];
    [self.headerView addSubview:self.functionHeaderView];
    [self.headerView addSubview:self.appHeaderView];
    [self.mainScrollView addSubview:self.mainTableView];
    
    __weak ViewController *weakSelf = self;
    _mainTableView.changeContentSize = ^(CGSize contentSize) {
        [weakSelf updateContentSize:contentSize];
    };
    
    weakSelf.mainScrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateContentSize:self.mainTableView.contentSize];
}

- (void)updateContentSize:(CGSize)size {
    CGSize contentSize = size;
    contentSize.height = contentSize.height + _topOffsetY;
    _mainScrollView.contentSize = contentSize;
    CGRect newframe = _mainTableView.frame;
    newframe.size.height = size.height;
    _mainTableView.frame = newframe;
}

- (void)functionViewAnimationWithOffsetY:(CGFloat)offsetY{
    if (offsetY > functionHeaderViewHeight / 2.0) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 95) animated:YES];
    }else {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < - 65) {
        [self.mainTableView.mj_header beginRefreshing];
    }else if(y > 0 && y <= functionHeaderViewHeight) {
        [self functionViewAnimationWithOffsetY:y];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",y);
    if (y <= 0) {
        _functionHeaderView.alpha = 1;
        CGRect newFrame = self.headerView.frame;
        newFrame.origin.y = y;
        self.headerView.frame = newFrame;
        newFrame = self.mainTableView.frame;
        newFrame.origin.y = y + _topOffsetY;
        self.mainTableView.frame = newFrame;
        
        //偏移量给到tableview，tableview自己来滑动
        [self.mainTableView setScrollViewContentOffSetWithPoint:CGPointMake(0, y)];
        
        //功能区状态回归
        newFrame = self.functionHeaderView.frame;
        newFrame.origin.y = 0;
        self.functionHeaderView.frame = newFrame;
    }else if(y < functionHeaderViewHeight && y > 0) {
        CGRect newFrame = self.headerView.frame;
        newFrame.origin.y = y/2;
        self.functionHeaderView.frame = newFrame;
        
        //处理透明度
        CGFloat alpha = (1 - y/functionHeaderViewHeight*2.5 ) > 0 ? (1 - y/functionHeaderViewHeight*2.5 ) : 0;
        _functionHeaderView.alpha = alpha;
        if (alpha > 0.5) {
            CGFloat newAlpha = alpha * 2 - 1;
            _mainNavView.alpha = newAlpha;
            _coverNavView.alpha = 0;
        }else {
            CGFloat newAlpha = alpha * 2;
            _mainNavView.alpha = 0;
            _coverNavView.alpha = 1 - newAlpha;
        }
    }
}

#pragma mark - privite

//mainScrollView
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
        _mainScrollView.delegate = self;
        _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(155, 0, 0, 0);
    }
    return _mainScrollView;
}

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        _navView.backgroundColor = [UIColor colorWithRed:65/255.0 green:128/255.0 blue:255.0/255.0 alpha:1];
    }
    return _navView;
}

- (UIView *)mainNavView{
    if(!_mainNavView){
        _mainNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        _mainNavView.backgroundColor = [UIColor clearColor];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [payButton setImage:[UIImage imageNamed:@"home_bill"] forState:UIControlStateNormal];
        [payButton setTitle:@"账单" forState:UIControlStateNormal];
        payButton.titleLabel.font = [UIFont systemFontOfSize:13];
        payButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [payButton sizeToFit];
        
        CGRect newFrame = payButton.frame;
        newFrame.origin.y = 20 + 10;
        newFrame.origin.x = 10;
        newFrame.size.width = newFrame.size.width + 10;
        payButton.frame = newFrame;
        [_mainNavView addSubview:payButton];
    }
    return _mainNavView;
}

- (UIView *)coverNavView{
    if(!_coverNavView){
        _coverNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        _coverNavView.backgroundColor = [UIColor clearColor];
        UIButton *payButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [payButton2 setImage:[UIImage imageNamed:@"pay_mini"] forState:UIControlStateNormal];
        [payButton2 sizeToFit];
        CGRect newFrame2 = payButton2.frame;
        newFrame2.origin.y = 20 + 10;
        newFrame2.origin.x = 10;
        newFrame2.size.width = newFrame2.size.width + 10;
        payButton2.frame = newFrame2;
        
        UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton setImage:[UIImage imageNamed:@"scan_mini"] forState:UIControlStateNormal];
        [scanButton sizeToFit];
        newFrame2.origin.x = newFrame2.origin.x + 40 + newFrame2.size.width;
        scanButton.frame = newFrame2;
        
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:[UIImage imageNamed:@"camera_mini"] forState:UIControlStateNormal];
        [searchButton sizeToFit];
        newFrame2.origin.x = newFrame2.origin.x + 40 + newFrame2.size.width;
        searchButton.frame = newFrame2;
        [_coverNavView addSubview:payButton2];
        [_coverNavView addSubview:scanButton];
        [_coverNavView addSubview:searchButton];
        _coverNavView.alpha = 0;
    }
    return _coverNavView;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, functionHeaderViewHeight + singleAppHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor colorWithRed:65/255.0 green:128/255.0 blue:255.0/255.0 alpha:1];
    }
    return _headerView;
}

- (UIView *)functionHeaderView {
    if(!_functionHeaderView){
        _functionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, functionHeaderViewHeight)];
        _functionHeaderView.backgroundColor = [UIColor clearColor];
        
        CGFloat padding = 5.0;
        CGFloat buttonWidth = kScreen_Width / 4.0 - padding * 2.0;
        UIButton *scanButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton2 setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
        [scanButton2 setTitle:@"扫一扫" forState:UIControlStateNormal];
        scanButton2.frame = CGRectMake(padding, padding, buttonWidth, buttonWidth);
        scanButton2.titleLabel.font = [UIFont systemFontOfSize:14];
        [scanButton2 alignImageAndTitleVertically];
        
        
        UIButton *payButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [payButton3 setImage:[UIImage imageNamed:@"home_pay"] forState:UIControlStateNormal];
        [payButton3 setTitle:@"付款" forState:UIControlStateNormal];
        payButton3.frame = CGRectMake(padding + kScreen_Width / 4.0, padding, buttonWidth, buttonWidth);
        payButton3.titleLabel.font = [UIFont systemFontOfSize:14];
        [payButton3 alignImageAndTitleVertically];
        
        
        UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cardButton setImage:[UIImage imageNamed:@"home_card"] forState:UIControlStateNormal];
        [cardButton setTitle:@"卡券" forState:UIControlStateNormal];
        cardButton.frame = CGRectMake(padding + kScreen_Width / 4.0*2.0, padding, buttonWidth, buttonWidth);
        cardButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cardButton alignImageAndTitleVertically];
        
        UIButton *xiuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xiuButton setImage:[UIImage imageNamed:@"home_xiu"] forState:UIControlStateNormal];
        [xiuButton setTitle:@"到位" forState:UIControlStateNormal];
        xiuButton.frame = CGRectMake(padding + kScreen_Width / 4.0*3.0, padding, buttonWidth, buttonWidth);
        xiuButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [xiuButton alignImageAndTitleVertically];
        [_functionHeaderView addSubview:scanButton2];
        [_functionHeaderView addSubview:payButton3];
        [_functionHeaderView addSubview:cardButton];
        [_functionHeaderView addSubview:xiuButton];
    }
    return _functionHeaderView;
}

- (UIView *)appHeaderView{
    if(!_appHeaderView){
        _appHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, functionHeaderViewHeight, kScreen_Width, singleAppHeaderViewHeight)];
        _appHeaderView.backgroundColor = [UIColor cyanColor];
    }
    return _appHeaderView;
}

- (IndexTableView *)mainTableView {
    if (!_mainTableView) {
        CGFloat orginY = singleAppHeaderViewHeight + functionHeaderViewHeight;
        CGFloat tableviewHeight = kScreen_Height - orginY - 64;
        _mainTableView = [[IndexTableView alloc]initWithFrame:CGRectMake(0, orginY, kScreen_Width, tableviewHeight) style:UITableViewStylePlain];
        _mainTableView.scrollEnabled = NO;
    }
    return _mainTableView;
}

- (void)refreshFooter{
    __block ViewController/*主控制器*/ *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.mainScrollView.mj_footer endRefreshing];
        [weakSelf.mainTableView loadMoreData];
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
