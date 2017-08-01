//
//  YiRefreshHeader.h
//  YiRefresh
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//
//YiRefresh is a simple way to use pull-to-refresh.下拉刷新，大道至简，最简单的网络刷新控件
//项目地址在：https://github.com/coderyi/YiRefresh
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^BeginRefreshing1Block)(void);

#define kRefreshHeaderTitleLoading @"正在载入…"
#define kRefreshHeaderTitlePullDown @"下拉返回查看"
#define kRefreshHeaderTitleRelease @"释放返回查看"

@interface YiRefreshHeader : NSObject
@property(nonatomic,strong) UIScrollView *scrollView;

/**
 *  callback when refreshing
 */
@property(nonatomic,copy) BeginRefreshing1Block beginRefreshingBlock;

@property(nonatomic,copy) NSString *titleLoading;// YiRefresh header loading title
@property(nonatomic,copy) NSString *titlePullDown;//YiRefresh header pull down title
@property(nonatomic,copy) NSString *titleRelease;//YiRefresh header release title

/**
 *  header's init
 */
-(void)header;

/**
 *  begin refresh
 */
-(void)beginRefreshing;

/**
 *  end refresh  
 */
-(void)endRefreshing;

@end