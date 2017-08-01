//
//  SuggestionsViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "SuggestionsViewController.h"

@interface SuggestionsViewController ()

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//返回(产品建议)
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
