//
//  PersonNationnalViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "PersonNationnalViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePhoneNumViewController.h"

@interface PersonNationnalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;//注册的手机号
@end

@implementation PersonNationnalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.phoneNum.text= [UserStorage shareInstance].account;
    self.phoneNum.text = @"";

}


//进入修改手机号的页面
- (IBAction)changeNum:(id)sender {
    
    ChangePhoneNumViewController *phoneNumVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePhoneNumViewController"];
    
    [self.navigationController pushViewController:phoneNumVC animated:YES];

}

//进入修改密码的页面
- (IBAction)changePassword:(id)sender {
    
    ChangePasswordViewController *passWordVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    
    [self.navigationController pushViewController:passWordVC animated:YES];
}
//返回(个人信息)
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
