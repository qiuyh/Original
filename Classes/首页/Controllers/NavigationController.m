//
//  NavigationController.m
//  Original
//
//  Created by 邱永槐 on 16/4/15.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "NavigationController.h"
#import "QYHKeyBoardManagerViewController.h"
#import "MyOriginalViewController.h"

@interface NavigationController ()<UINavigationControllerDelegate>
@property (nonatomic,weak) id popDelage;
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelage = self.interactivePopGestureRecognizer.delegate;
    
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count)
    {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"jso" style:UIBarButtonItemStylePlain target:viewController action:@selector(popAction)];
        
//        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}


- (void)popAction
{
    [self popViewControllerAnimated:YES];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
//    NSLog(@"viewController===%@",[self.viewControllers[0] class]);
    
    if (viewController != self.viewControllers[0]) {
        
//        MyOriginalViewController *myOriginalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOriginalViewController"];
//        
//        if ([myOriginalVC isKindOfClass: [self.viewControllers[0] class]])
//        {
        
            [QYHKeyBoardManagerViewController shareInstance].selfView = viewController.view;

//        }

    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) { // 是根控制器
        
        self.interactivePopGestureRecognizer.delegate = _popDelage;
        
    }else{ // 非根控制器
        self.interactivePopGestureRecognizer.delegate = nil;
        
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
