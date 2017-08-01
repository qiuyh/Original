//
//  WebViewController.m
//  Original
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;//可以加载网页数据的View
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //调用加载web
    [self loadWeb];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//加载web
- (void)loadWeb
{
    //初始化_webView
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [self.view sendSubviewToBack:_webView];
    
    
    NSURL *url = [NSURL URLWithString:self.url];
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
//加载完成后设置偏移量
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webView.scrollView.contentOffset=CGPointMake(0, 50);
    _webView.scrollView.contentInset=UIEdgeInsetsMake(-50, 0, 0, 0);
    [_webView setScalesPageToFit:YES];
    _webView.scrollView.bounces=NO;
    _webView.scrollView.showsVerticalScrollIndicator=NO;
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
   
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
