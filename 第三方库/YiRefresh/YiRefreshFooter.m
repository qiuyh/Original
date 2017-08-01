
//
//  YiRefreshFooter.m
//  YiRefresh
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//
//YiRefresh is a simple way to use pull-to-refresh.下拉刷新，大道至简，最简单的网络刷新控件
//项目地址在：https://github.com/coderyi/YiRefresh
//

#import "YiRefreshFooter.h"
@interface YiRefreshFooter (){
    
    float contentHeight;
    float scrollFrameHeight;
    float footerHeight;
    float scrollWidth;
    BOOL isAdd;//是否添加了footer,默认是NO
    BOOL isRefresh;//是否正在刷新,默认是NO
    
    UIView *footerView;
    UIActivityIndicatorView *activityView;
    
    UILabel *tipLabel ;
    
}
@end

@implementation YiRefreshFooter


-(void)setScrollView:(UIScrollView *)scrollView
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    _scrollView  = scrollView;

    scrollWidth=_scrollView.frame.size.width;
    footerHeight=350;
    scrollFrameHeight=_scrollView.frame.size.height;
    isAdd=NO;
    isRefresh=NO;
    footerView=[[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithWhite:0.793 alpha:1.000];
    //    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    tipLabel = [[UILabel alloc]init];
    
    tipLabel.text = @"上拉查看图文详情";
    tipLabel.font = [UIFont systemFontOfSize:17];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    
}
- (void)footer
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    

    if (!isAdd) {
        isAdd=YES;
        footerView.frame=CGRectMake(0, scrollFrameHeight, scrollWidth, footerHeight);
        [_scrollView addSubview:footerView];
        tipLabel.frame=CGRectMake(0, 0, scrollWidth, 60);
        [footerView addSubview:tipLabel];
    }
    
    contentHeight=_scrollView.contentSize.height;
    
    CGFloat currentPostion = _scrollView.contentOffset.y;
    
    
    if (currentPostion>60)
    {
        tipLabel.text = @"释放查看图文详情";
        
    }else
    {
        tipLabel.text = @"上拉查看图文详情";
    }
    
    footerView.hidden = NO;
    footerView.frame=CGRectMake(0, scrollFrameHeight, scrollWidth, footerHeight);
    
   if (!_scrollView.dragging) {

    // 进入刷新状态
    if (currentPostion>60) {
        [self beginRefreshing];
    }
        
    }
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing
{
    if (!isRefresh) {
        isRefresh=YES;
        [activityView startAnimating];
        //        设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, footerHeight, 0);
        }];
        //        block回调
        _beginRefreshingBlock();
    }
}

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
- (void)endRefreshing
{
    isRefresh=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
//            [activityView stopAnimating];
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            footerView.hidden = YES;
//            footerView.frame=CGRectMake(0, contentHeight, [[UIScreen mainScreen] bounds].size.width, footerHeight);
        }];
    });
}

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
