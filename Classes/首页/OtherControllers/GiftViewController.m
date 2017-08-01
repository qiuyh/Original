//
//  GiftViewController.m
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "GiftViewController.h"
#import "ExchangeViewController.h"

@interface GiftViewController ()<UIAlertViewDelegate>

@end

@implementation GiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
//进入页面
- (IBAction)exchange:(id)sender {
    ExchangeViewController *exchangeVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ExchangeViewController"];
    [self.navigationController pushViewController:exchangeVC animated:YES];

}
//返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//打电话按钮
- (IBAction)phone:(id)sender {
    
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"是否拨打客户电话" message:@"4008000917" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    aler.delegate=self;
    
    //让提示框显示
    [aler show];
}

- (IBAction)share:(id)sender {
    
    ShareCustomView *shareView = [[ShareCustomView alloc]init];
    
    [shareView show];

}


#pragma mark-UIAlertViewDelegate
//选中第几个
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //进入拨电话界面,系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]]];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
