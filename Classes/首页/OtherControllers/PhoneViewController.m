//
//  PhoneViewController.m
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "PhoneViewController.h"
//手机专享
//#define BIG_Product @"http://m.benlai.com/bigProduct/4222"

@interface PhoneViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;//可以加载网页数据的View
}


@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=self.itemText;
    
    [self loadWeb];
    
}
//加载网页Web
- (void)loadWeb
{
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [self.view sendSubviewToBack:_webView];
    
    
    NSURL *url = [NSURL URLWithString:BIG_Product];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView.delegate=self;
    
    //加载一个网页地址
    [_webView loadRequest:request];
}
//返回
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
- (IBAction)share:(id)sender {
    
    
    ShareCustomView *shareView = [[ShareCustomView alloc]init];
    
    [shareView show];

}
//加载结束,偏移
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.scrollView.contentOffset=CGPointMake(0, -24);
    _webView.scrollView.contentInset=UIEdgeInsetsMake(24, 0, 0, 0);
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_webView loadRequest:nil];
    [_webView removeFromSuperview];
    _webView = nil;
    _webView.delegate = nil;
    [_webView stopLoading];
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
