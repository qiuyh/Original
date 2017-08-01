//
//  QYHRegistViewController.m
//  Original
//
//  Created by iMacQIU on 16/3/14.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "QYHRegistViewController.h"
#import "HttpreQuestManager.h"
#import "QYHProgressHUD.h"
//#import "QYHRecoderPasswordViewController.h"
#import "UserStorage.h"
#import "UIImageView+AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <SMS_SDK/SMSSDK.h>
#import "NSString+Validate.h"

@interface QYHRegistViewController ()<UITextFieldDelegate>

{
    NSTimer *_timer;
    
    int _i;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nichengTextField;

@property (weak, nonatomic) IBOutlet UIButton *acodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *reAcodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;



@end

@implementation QYHRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextBtn.selected = NO;
    self.nextBtn.enabled  = NO;
    
    self.acodeBtn.hidden     = NO;
    self.reAcodeLabel.hidden = YES;
}
- (IBAction)getAcodeButton:(id)sender {
    
    
    if (![self isValidateMobile:self.phoneTextField.text])
    {
        [QYHProgressHUD showErrorHUD:nil message: @"请输入合法的手机号码！"];
        
        return;
        
    }
    
    NSString *fileName1 = @"info.json";
    
    [[QYHQiNiuRequestManarger shareInstance]getFile:fileName1 withphotoNumber:self.phoneTextField.text Success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            
            if ([[responseObject objectForKey:@"isRegist"] boolValue] == YES)
            {
                [QYHProgressHUD showErrorHUD:nil message:@"该手机已注册，请直接登录"];
                
            }else
            {
                [self getVerificationCode];
            }
            
        }else
        {
            [QYHProgressHUD showErrorHUD:nil message:@"该手机已注册，请直接登录"];
        
        }
        return ;
        
    } failure:^(NSError *error) {
        
        NSDictionary *err = error.userInfo;
        
        
        if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
        {
            [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
            
        }else   if ([err[@"NSLocalizedDescription"] isEqualToString:@"Request failed: not found (404)"])
        {
            
            
            [self getVerificationCode];
            
        }else
        {
            
            //            [QYHProgressHUD showHUDInView:self.view onlyMessage:@"登陆失败"];
        }
        NSLog(@"验证手机是否注册失败error==%@",error);
        
    }];
}
 
    

//    [[HttpreQuestManager shareInstance]getSNSCodeWithCellphone:self.phoneTextField.text success:^(id responseObject) {
//        
//        NSLog(@"获取验证码responseObject==%@",responseObject);
//        
//        if ([responseObject[@"status"] integerValue] == 1)
//        {
//            self.acodeBtn.hidden     = YES;
//            self.reAcodeLabel.hidden = NO;
//            self.reAcodeLabel.text   = @"重新获取60s";
//            //60s定时不断刷新数据,
//            _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
//            [QYHProgressHUD showErrorHUD:self.view message:@"验证码已经发送至您的手机,60s后可以重新获取验证码"];
//            
//        }else
//        {
//            [QYHProgressHUD showErrorHUD:self.view message:@"该手机号已经注册，请直接登录"];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"获取验证码失败");
//    }];
    
- (void)getVerificationCode
{

    self.acodeBtn.hidden     = YES;
    self.reAcodeLabel.hidden = NO;
    self.reAcodeLabel.text   = @"重新获取60s";
    //60s定时不断刷新数据,
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [QYHProgressHUD showHUDInView:nil onlyMessage:@"验证码已经发送至您的手机,60s后可以重新获取验证码"];
    
    
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        if (!error)
        {
            NSLog(@"获取验证码成功");
            
        } else
        {
            NSLog(@"错误信息：%@",error);
        }}
     ];

}

//不断刷新数据
- (void)changeTime
{
    self.reAcodeLabel.text=[NSString stringWithFormat:@"重新获取(%ds)",(59-_i)];
    _i++;
    if (_i>59)
    {
        //60s后,//显示获取验证码按钮并隐藏重新获取验证码和倒计时的label和销毁定时器
        [self.acodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.acodeBtn.hidden=NO;
        self.reAcodeLabel.hidden=YES;
        
        [_timer invalidate];
        _timer=nil;
        _i=0;
    }
    
}




- (IBAction)back:(id)sender {
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender {
    
    
    if (![self isValidateMobile:self.phoneTextField.text])
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入合法的手机号码！"];
        
        return;
        
    }else if (self.codeTextField.text.length < 1)
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入验证码！"];
        
        return;
        
    }else if (self.passwordTextField.text.length < 1)
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入密码！"];
        
        return;
    }
    else if (self.nichengTextField.text.length < 1)
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入昵称！"];
        
        return;
        
    }else if(self.passwordTextField.text.length < 6)
    {
        
        [QYHProgressHUD showErrorHUD:nil message:@"输入的密码不能少于6位"];
    }


    [QYHProgressHUD showHUDAddedTo:self.view animated:YES];

 //验证验证码是否正确
    
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!error) {
            NSLog(@"验证成功");
            
            NSString *fileName = @"info.json";
            
             NSString *imageUrl = [NSString stringWithFormat:@"http://7xt8p0.com2.z0.glb.qiniucdn.com/%@uploadfile.jpeg",self.phoneTextField.text];
            
            NSString *passWord  = self.passwordTextField.text;
            NSString *nickName  = self.nichengTextField.text;
            BOOL      isRegist  = YES;
            BOOL   loginStatus  = YES;
            
            NSDictionary *dic   = @{@"imageUrl"   : imageUrl,
                                    @"passWord"   : passWord,
                                    @"nickName"   : nickName,
                                    @"isRegist"   : @(isRegist),
                                    @"loginStatus": @(loginStatus)};
            
            NSString *str = [NSString dictionaryToJson:dic];
            
            NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];

            
             [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName withphotoNumber:self.phoneTextField.text data:data Success:^(id responseObject) {
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
                 
                 [accountPassword setObject:self.phoneTextField.text forKey:@"account"];
                 [accountPassword setObject:self.passwordTextField.text forKey:@"password"];
                 [accountPassword setObject:@"1" forKey:@"rememberPasswordBtn"];
                 
                 [UserStorage shareInstance].imageUrl  = imageUrl;
                 [UserStorage shareInstance].passWord  = passWord;
                 [UserStorage shareInstance].nickname  = nickName;
                 [UserStorage shareInstance].uid       = nil;
                 [UserStorage shareInstance].isLogined = loginStatus;
                 [UserStorage shareInstance].account   = self.phoneTextField.text;
                 
                 [QYHProgressHUD showSuccessHUD:nil message:@"注册成功"];
                 
                 [UserStorage shareInstance].isPopRoot = YES;
                 
                 [self.navigationController popToRootViewControllerAnimated:YES];

                 
                 
             } failure:^(NSError *error) {
                 
                 NSDictionary *err = error.userInfo;
                 
                 [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                 
                 if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
                 {
                     [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
                     
                 }else
                 {
                     
                     [QYHProgressHUD showErrorHUD:nil message:@"注册失败"];
                 }
                 
                 NSLog(@"注册失败error==%@",error);
                 
             }];
        }  else
        {
            [QYHProgressHUD showErrorHUD:nil message:@"验证码错误"];
            NSLog(@"错误信息:%@",error);
        }
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
    
    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",homePath,self.phoneTextField.text];
    
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




/* 手机号码验证 */
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)getTextField
{

    if (self.phoneTextField.text.length > 0 && self.codeTextField.text.length > 0 && self.passwordTextField.text.length > 0 && self.nichengTextField.text.length > 0)
    {
        self.nextBtn.selected = YES;
        self.nextBtn.enabled  = YES;
    }else
    {
        self.nextBtn.selected = NO;
        self.nextBtn.enabled  = NO;
        
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
