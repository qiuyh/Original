//
//  QYHRecoderPasswordViewController.m
//  Original
//
//  Created by iMacQIU on 16/3/14.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "QYHRecoderPasswordViewController.h"
#import "QYHProgressHUD.h"
#import "HttpreQuestManager.h"
#import "UserStorage.h"
#import "UIImageView+AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Validate.h"


@interface QYHRecoderPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstPassword;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;

@end

@implementation QYHRecoderPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.successBtn.selected = NO;
    self.successBtn.enabled  = NO;
    

}
- (IBAction)back:(id)sender {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)success:(id)sender {
    
    if (self.firstPassword.text.length < 6)
    {
        [QYHProgressHUD showHUDInView:self.view onlyMessage:@"输入密码不能少于6位数！"];
        
        return;
        
    }else if (![self.firstPassword.text isEqualToString:self.surePassword.text])
    {
        [QYHProgressHUD showHUDInView:self.view onlyMessage:@"两次输入的密码不一致！"];
        
        return;
    }
    
    [QYHProgressHUD  showHUDAddedTo:self.view animated:YES];
    
    
    NSString *fileName = @"info.json";
    
    NSString *imageUrl  = [UserStorage shareInstance].imageUrl;
    NSString *passWord  = self.firstPassword.text;
    NSString *nickName  = [UserStorage shareInstance].nickname;
    BOOL      isRegist  = YES;
    BOOL   loginStatus  = NO;
    
    NSDictionary *dic   = @{@"imageUrl"   : imageUrl,
                            @"passWord"   : passWord,
                            @"nickName"   : nickName,
                            @"isRegist"   : @(isRegist),
                            @"loginStatus": @(loginStatus)};
    
    NSString *str = [NSString dictionaryToJson:dic];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName withphotoNumber:nil data:data Success:^(id responseObject) {
        
        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //            NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
        
        //            [accountPassword setObject:self.nPassword.text forKey:@"password"];
        
        [UserStorage shareInstance].isLogined = NO;
        
        [UserStorage shareInstance].isPopRoot = YES;
        
        [QYHProgressHUD showSuccessHUD:nil message:@"重置密码成功"];
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        
        
    } failure:^(NSError *error) {
        
        NSDictionary *err = error.userInfo;
        
        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
        {
            [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
            
        }else
        {
            
            [QYHProgressHUD showErrorHUD:nil message:@"更改密码失败"];
        }
        
        NSLog(@"重置密码失败error==%@",error);
        
    }];


}

- (void)getTextField
{
    
    if (self.firstPassword.text.length > 0 && self.surePassword.text.length > 0)
    {
        self.successBtn.selected = YES;
        self.successBtn.enabled  = YES;
    }else
    {
        self.successBtn.selected = NO;
        self.successBtn.enabled  = NO;
        
    }
    
}

- (IBAction)textChange:(id)sender {
    [self getTextField];
}
- (IBAction)textChange1:(id)sender {
    [self getTextField];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self getTextField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self getTextField];
}

//结束键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
