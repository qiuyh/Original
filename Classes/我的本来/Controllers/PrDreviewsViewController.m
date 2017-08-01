//
//  PrDreviewsViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "PrDreviewsViewController.h"


@interface PrDreviewsViewController ()

@end

@implementation PrDreviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addImage];
}

//商品评价没有购买过商品时,添加图片提示
- (void)addImage
{
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 170)];
    imgView.image=[UIImage imageNamed:@"comment_empty.png"];
    
    [self.view addSubview:imgView];
    
}


//返回
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
