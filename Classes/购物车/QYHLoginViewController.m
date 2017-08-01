//
//  QYHLoginViewController.m
//  Original
//
//  Created by iMacQIU on 16/3/14.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "QYHLoginViewController.h"
#import "QYHProgressHUD.h"
#import "QYHRegistViewController.h"
#import "HttpreQuestManager.h"
#import "UserStorage.h"
#import "UIImageView+AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "NSString+Validate.h"
#import "QYHResetPassWordViewController.h"


@interface QYHLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headViewBtn;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *toRegistBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;

@end

@implementation QYHLoginViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getUserDefault];
    
    [self getTextField];
    
}

- (void)getUserDefault
{
    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
    
    NSString *account  = [NSString stringWithFormat:@"%@",[accountPassword valueForKey:@"account"]];
    NSString *password = [NSString stringWithFormat:@"%@",[accountPassword valueForKey:@"password"]];
    self.account.text  = [account isEqualToString:@"(null)"]  ? @"" :account;
    self.password.text = [password isEqualToString:@"(null)"] ? @"" :password;

    NSLog(@"self.password.text==%@",self.password.text);
    NSString *rememberPassword = [NSString stringWithFormat:@"%@",[accountPassword valueForKey:@"rememberPasswordBtn"]];
    self.rememberPasswordBtn.selected = [rememberPassword isEqualToString:@"(null)"] ? NO :[rememberPassword boolValue];
}

- (void)getTextField
{
    
    if (self.account.text.length > 0 && self.password.text.length > 0)
    {
        self.loginBtn.selected = YES;
        self.loginBtn.enabled  = YES;
        
    }else
    {
        self.loginBtn.selected = NO;
        self.loginBtn.enabled  = NO;
    }
    

    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",NSHomeDirectory(),[self.account.text isEqualToString:@"(null)"]  ? @"" :self.account.text];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    NSLog(@"image==%@",image);
    
    if (image)
    {
         [self.headViewBtn setImage:image forState:UIControlStateNormal];
        
    }else
    {
        [self.headViewBtn setImage:[UIImage imageNamed:@"sun.png"] forState:UIControlStateNormal];
    
    }

}


-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weiboBtn.layer.cornerRadius  = self.weiboBtn.frame.size.width/2.0;
    self.weixinBtn.layer.cornerRadius = self.weiboBtn.frame.size.width/2.0;
    self.qqBtn.layer.cornerRadius     = self.weiboBtn.frame.size.width/2.0;
    
//     UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back1"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnDidPush)];
//    
//    self.navigationItem.leftBarButtonItem = backBarItem;
//
    
    self.account.delegate  = self;
    self.password.delegate = self;
    
    
}
- (IBAction)back:(id)sender
{
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButton:(id)sender {
    
    if (![self isValidateMobile:self.account.text])
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入合法的手机号码！"];
        
    }else if(self.password.text.length < 6)
    {
    
        [QYHProgressHUD showErrorHUD:nil message:@"输入的密码不能少于6位"];
    }else
    {
        [self login];
    }
    
}

- (void)login
{
    [QYHProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *fileName1 = @"info.json";
    
    [[QYHQiNiuRequestManarger shareInstance]getFile:fileName1 withphotoNumber:self.account.text Success:^(id responseObject) {
        
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            
            NSString *imageUrl  = [responseObject objectForKey:@"imageUrl"];
            NSString *passWord  = [responseObject objectForKey:@"passWord"];
            NSString *nickName  = [responseObject objectForKey:@"nickName"];
            BOOL      isRegist  = [[responseObject objectForKey:@"isRegist"] boolValue];
            BOOL   loginStatus  = YES;
            
            
            if (!isRegist)
            {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [QYHProgressHUD showErrorHUD:nil message:@"该手机未注册"];
                
                return ;
            }
            
            if (![passWord isEqualToString:self.password.text])
            {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [QYHProgressHUD showErrorHUD:nil message:@"密码错误"];
                
                return ;
            }

            
            
            NSDictionary *dic   = @{@"imageUrl"   : imageUrl,
                                    @"passWord"   : passWord,
                                    @"nickName"   : nickName,
                                    @"isRegist"   : @(isRegist),
                                    @"loginStatus": @(loginStatus)};
            
            NSString *str = [NSString dictionaryToJson:dic];
            
            NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
            
            
            [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName1 withphotoNumber:self.account.text data:data Success:^(id responseObject) {
                
                NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
                
                [accountPassword setObject:self.account.text forKey:@"account"];
//                [accountPassword setObject:self.password.text forKey:@"password"];
//                [accountPassword setObject:@"1" forKey:@"rememberPasswordBtn"];
                
                [UserStorage shareInstance].imageUrl  = imageUrl;
                [UserStorage shareInstance].passWord  = passWord;
                [UserStorage shareInstance].nickname  = nickName;
                [UserStorage shareInstance].uid       = nil;
                [UserStorage shareInstance].isLogined = loginStatus;
                [UserStorage shareInstance].account   = self.account.text;
                
                
                if (self.rememberPasswordBtn.selected == YES)
                {
                    [accountPassword setObject:self.password.text forKey:@"password"];
                    [accountPassword setObject:@"1" forKey:@"rememberPasswordBtn"];
                    
                }else
                {
                    [accountPassword setObject:@"" forKey:@"password"];
                    [accountPassword setObject:@"0" forKey:@"rememberPasswordBtn"];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [QYHProgressHUD showSuccessHUD:nil message:@"登录成功"];
                    
                    [UserStorage shareInstance].isPopRoot = YES;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            
            } failure:^(NSError *error) {
                
                NSDictionary *err = error.userInfo;
                
                [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                
                if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
                {
                    [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
                    
                }else
                {
                    
                    [QYHProgressHUD showErrorHUD:nil message:@"登陆失败"];
                }
                
                NSLog(@"登陆失败error==%@",error);
                
            }];

        }else
        {
        
        
        }
        
    } failure:^(NSError *error) {
        
        NSDictionary *err = error.userInfo;
        
        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
        {
            [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
            
        }else   if ([err[@"NSLocalizedDescription"] isEqualToString:@"Request failed: not found (404)"])
        {
            [QYHProgressHUD showErrorHUD:nil message:@"该手机未注册"];
            
        }else
        {
            
//            [QYHProgressHUD showHUDInView:self.view onlyMessage:@"登陆失败"];
        }
        NSLog(@"验证手机是否注册失败error==%@",error);
        
    }];
    
}

- (void)delay2:(UIImageView *)ImgView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
//    [_img setImage:ImgView.image forState:UIControlStateNormal];
    
    //把图片转为二进制数据
    NSData *data = UIImageJPEGRepresentation(ImgView.image, 1.0);
    
    //取到沙盒路径
    NSString *homePath = NSHomeDirectory();

    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",homePath,self.account.text];
    
    //    NSString *path=[homePath stringByAppendingString:@"/Documents/uploadfile.jpeg"];
    //    NSLog(@"homePath==%@",path);
    
    //写入沙盒
    [data writeToFile:path atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:^{
    
         [QYHProgressHUD showSuccessHUD:nil message:@"登陆成功！"];
//    }];
    
    
}


//md5加密
-(NSString *)MD5ByAStr:(NSString *)aSourceStr
{
    const char *original_str = [aSourceStr UTF8String];
    //unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
    {
        //x表示十六进制，X  意思是不足两位将用0补齐，如果多余两位则不影响
        [hash appendFormat:@"%02x", result[i]];
//        aab7b5bf8546fd9fa24a92f584eeca6a
//        aab7b5bf8546fd9fa24a92f584eeca6a
    }
    
    NSString *mdfiveString = [hash lowercaseString];
    
    
    
     NSLog(@"md5加密输出：Encryption Result = %@",mdfiveString);
    
    return mdfiveString;}




/* 邮箱验证 */
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/* 手机号码验证 */
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 *  第三方登陆，微信、QQ、微博
 *
 *  @param sender 
 */
- (IBAction)weixin:(id)sender {
    
    [self diSanFangLogin:SSDKPlatformTypeWechat];
}


- (IBAction)qq:(id)sender {
    
    [self diSanFangLogin:SSDKPlatformTypeQQ];
}

- (IBAction)weibo:(id)sender {
    
    [self diSanFangLogin:SSDKPlatformTypeSinaWeibo];
}

- (void)diSanFangLogin:(SSDKPlatformType)type

{
    
    NSUserDefaults *userType = [NSUserDefaults standardUserDefaults];
    
    [userType setObject:@(type) forKey:@"loginType"];
    
    
    // 登陆
    [SSEThirdPartyLoginHelper loginByPlatform:type
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                       
                                       
                                       NSString *nickname = nil;
                                       NSString *imageUrl = nil;
                                       
                                       switch (type)
                                       {
                                           case SSDKPlatformTypeSinaWeibo:
                                               nickname = user.rawData[@"name"] ;
                                               imageUrl = user.rawData[@"avatar_hd"] ;
                                               break;
                                           case SSDKPlatformTypeQQ:
                                               nickname = user.rawData[@"nickname"] ;
                                               imageUrl = user.rawData[@"figureurl_qq_2"] ;
                                               break;
                                           case SSDKPlatformTypeWechat:
                                               nickname = user.rawData[@"name"] ;
                                               imageUrl = user.rawData[@"avatar_hd"] ;
                                               break;
                                               
                                           default:
                                               break;
                                       }
                                       
                                       [UserStorage shareInstance].nickname = nickname;
                                       [UserStorage shareInstance].imageUrl = imageUrl;
                                     
                                       
                                       
                                       SSDKCredential *credential = user.credential;
                                       
                                       
                                       [UserStorage shareInstance].uid    = credential.uid ;
                                       [UserStorage shareInstance].token  = credential.token ;
                                       
                                       NSLog(@"credential.uid==%@,,%@",credential.uid,credential.token);
                                       
                                       
                                       NSUserDefaults *userManer = [NSUserDefaults standardUserDefaults];
                                       
                                          [userManer setObject:imageUrl forKey:[NSString stringWithFormat:@"imageUrl%@", credential.uid]];
//                                       
//                                       [userManer setObject:nickname forKey:[NSString stringWithFormat:@"nickname%@", credential.uid]];
//                                       [userManer setObject:credential.uid  forKey:@"uid"];
//                                       [userManer setObject:credential.token forKey:[NSString stringWithFormat:@"token%@", credential.uid]];
                                       
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    
                                    
                                    NSLog(@"user==%@",user);
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        [UserStorage shareInstance].user  = user ;
                                        
                                        [UserStorage shareInstance].isLogined = YES;
                                        
                                        [self.navigationController popToRootViewControllerAnimated:NO];
                                    }
                                    
                                }];
    
}




- (IBAction)registButton:(id)sender {
    
    QYHRegistViewController *registVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHRegistViewController"];
    [self.navigationController pushViewController:registVC animated:YES];
    
//    registVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    
//    [self presentViewController:registVC animated:YES completion:^{
//        
//    }];
    
}

- (IBAction)forgetButton:(id)sender {
    
    QYHResetPassWordViewController  *resetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHResetPassWordViewController"];
    
    [self.navigationController pushViewController:resetVC animated:YES];
    
}

- (IBAction)remenber:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    button.selected = !button.selected;
}

#pragma mark- textFielDelegate

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
//    045f34a7751e14b4e6998a24204a85a8
//    284c1064bf7f9f5b6322dbf3e932fe1b
    
   
}

//结束键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
