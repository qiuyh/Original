//
//  GuidViewController.m
//  Original
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "GuidViewController.h"
#import "TabBarController.h"

@interface GuidViewController ()

@end

@implementation GuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //引导页设计
    [self welcome];
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    [UIApplication sharedApplication].statusBarHidden=YES;
    return YES;

}

- (void)welcome
{
    //使用scrollView做引导页
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    //设置滚动大小
    scroll.contentSize = CGSizeMake(self.view.frame.size.width*3, 0);
    //打开分页
    scroll.pagingEnabled = YES;
    [self.view addSubview:scroll];
    self.navigationController.navigationBarHidden=YES;
    
    //创建四张图片视图,放到scroll之上
    for (int i=0; i<3; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ico%02d_3x.png",i+1]];
        
        [scroll addSubview:imgView];
        
        if (i==2)
        {
            //打开手势
            imgView.userInteractionEnabled = YES;
            
            //添加按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, 100, 30);
            //将button放到正中间
            button.center = CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2);
            
            [button setImage:[UIImage imageNamed:@"ico08_3x.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(coming) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:button];
        }
    }
    
}
//点击按钮进入首页
- (void)coming
{
    //取到storyboard
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil ];
    //取到storyboard对应的ViewController
    TabBarController *main = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self isFirst];
        
    [self presentViewController:main animated:YES completion:nil];
   
}


//记录已经使用过
- (void)isFirst
{
    //将已经使用过的记录,记下来
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    [myDefault setObject:@"NO" forKey:@"isFirst"];
    [myDefault setObject:@""   forKey:@"account"];
    [myDefault synchronize];
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
