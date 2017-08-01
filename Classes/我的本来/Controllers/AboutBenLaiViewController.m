//
//  AboutBenLaiViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "AboutBenLaiViewController.h"
#import "WebViewController.h"

@interface AboutBenLaiViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation AboutBenLaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setcontent];
}

//关于本来,设置内容大小,添加图片和按钮
- (void)setcontent
{
    _myScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.1);
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.myScrollView.frame.size.height*0.9)];
 
    imgView.image=[UIImage imageNamed:@"about_benlai"];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(45, 42, 140, 21);

    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.myScrollView addSubview:imgView];
    
    [self.myScrollView addSubview:button];
}

//按钮事件,进入自带的浏览器浏览网址
- (void)click
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.benlai.com"]];

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
