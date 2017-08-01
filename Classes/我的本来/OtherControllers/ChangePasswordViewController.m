//
//  ChangePasswordViewController.m
//  Original
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "NSString+Validate.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

{
    BOOL _isShow;//判断密码是否可见
}

@property (weak, nonatomic) IBOutlet UITextField *originalPassword;//原来的密码
@property (weak, nonatomic) IBOutlet UITextField *nPassword;//新密码

@property (weak, nonatomic) IBOutlet UILabel *tipWord;//提示的label

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipHeight;//提示label的高度

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
//视图即将出现
- (void)viewWillAppear:(BOOL)animated
{
    //设置边框颜色和宽度
    _originalPassword.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    _originalPassword.layer.borderWidth = 1.0;
    
    
    _nPassword.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    _nPassword.layer.borderWidth = 1.0;
    
    //更改约束为0,并隐藏
    _tipHeight.constant=0;
    _tipWord.hidden=YES;
    //假设原密码等于
    
    self.password  = [UserStorage shareInstance].passWord;

//    self.password=@"123456";
}

//返回(修改密码)
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//修改完成
- (IBAction)done:(id)sender {
    
    //更改约束,并显示出来
    _tipWord.hidden=NO;
    _tipHeight.constant=21;
    //根据所填的内容判断是否正确,做出相应的提示
    if (self.originalPassword.text.length==0)
    {
        _tipWord.text=@"请输入原密码";
        
    }else if (self.originalPassword.text.length<6)
    {
        _tipWord.text=@"密码至少6位,最多16位";
    }else if (self.nPassword.text.length==0)
    {
        _tipWord.text=@"请输入新密码";
    }else if (![self.originalPassword.text isEqualToString:self.password])
    {
        _tipWord.text=@"原密码错误!";
    }else if ([self.nPassword.text isEqualToString:self.password])
    {
        _tipWord.text=@"新密码不能和旧密码一样";
    }else
    {
        //更改约束
        _tipWord.hidden=YES;
        _tipHeight.constant=0;
//        self.password=self.nPassword.text;//替换密码
        
        [QYHProgressHUD  showHUDAddedTo:self.view animated:YES];
        
        
        NSString *fileName = @"info.json";
        
        NSString *imageUrl  = [UserStorage shareInstance].imageUrl;
        NSString *passWord  = self.nPassword.text;
        NSString *nickName  = [UserStorage shareInstance].nickname;
        BOOL      isRegist  = YES;
        BOOL   loginStatus  = YES;
        
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
            
            [QYHProgressHUD showSuccessHUD:nil message:@"更改密码成功"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
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
            
            NSLog(@"更改密码失败error==%@",error);
            
        }];

    }
}
//点击是否可以显示密码
- (IBAction)showSecure:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    _isShow=!_isShow;
    if (_isShow)
    {//如果点击了显示,就让它可见
        button.selected=YES;
        self.nPassword.secureTextEntry=NO;
    }else
    {//如果点击了隐藏,就让它不可见
        button.selected=NO;
        self.nPassword.secureTextEntry=YES;
    }
}



#pragma mark-UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
   
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.originalPassword == textField||self.nPassword == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 16) { //如果输入框内容大于16则弹出警告
            textField.text = [toBeString substringToIndex:16];
            
            return NO;
        }
    }
    return YES;
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
