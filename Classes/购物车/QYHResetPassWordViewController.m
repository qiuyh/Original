//
//  QYHResetPassWordViewController.m
//  Original
//
//  Created by 邱永槐 on 16/4/25.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "QYHResetPassWordViewController.h"
#import "QYHProgressHUD.h"
#import <SMS_SDK/SMSSDK.h>
#import "QYHRecoderPasswordViewController.h"

@interface QYHResetPassWordViewController ()

{
    NSTimer *_timer;
    
    int _i;

}

@property (weak, nonatomic) IBOutlet UIButton *getAcodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *photoNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *acodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeTipLabel;


@end

@implementation QYHResetPassWordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.timeTipLabel.hidden  = YES;
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)getAcodeAction:(id)sender {
    
    
    if (self.photoNumTextField.text.length <1 )
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入电话号码"];
        
        return;
        
    }else if (![self isValidateMobile:self.photoNumTextField.text])
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入合法的手机号码"];
        return;
    }

    
    NSString *fileName1 = @"info.json";
    
    [[QYHQiNiuRequestManarger shareInstance]getFile:fileName1 withphotoNumber:self.photoNumTextField.text Success:^(id responseObject) {
        
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            
            NSString *imageUrl  = [responseObject objectForKey:@"imageUrl"];
            NSString *passWord  = [responseObject objectForKey:@"passWord"];
            NSString *nickName  = [responseObject objectForKey:@"nickName"];
            BOOL      isRegist  = [[responseObject objectForKey:@"isRegist"] boolValue];
            BOOL   loginStatus  = [[responseObject objectForKey:@"loginStatus"] boolValue];;
            
            
            [UserStorage shareInstance].imageUrl  = imageUrl;
            [UserStorage shareInstance].nickname  = nickName;
     
        
            if (!isRegist)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [QYHProgressHUD showErrorHUD:nil message:@"该手机未注册"];
                
                return ;
            }
            
            
            [self getVerificationCode];
            
        }
        
    }failure:^(NSError *error) {
            
            NSDictionary *err = error.userInfo;
            
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

- (void)getVerificationCode
{
    
    self.getAcodeBtn.hidden     = YES;
    self.timeTipLabel.hidden    = NO;
    self.timeTipLabel.text      = @"重新获取60s";
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
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.photoNumTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        if (!error)
        {
            NSLog(@"获取验证码成功");
            
        } else
        {
            NSLog(@"错误信息：%@",error);
            
            [QYHProgressHUD showErrorHUD:nil message:@"获取验证码失败"];
        }}
     ];
    
}

//不断刷新数据
- (void)changeTime
{
    self.timeTipLabel.text=[NSString stringWithFormat:@"重新获取(%ds)",(59-_i)];
    _i++;
    if (_i>59)
    {
        //60s后,//显示获取验证码按钮并隐藏重新获取验证码和倒计时的label和销毁定时器
        [self.getAcodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getAcodeBtn.hidden = NO;
        self.timeTipLabel.hidden= YES;
        
        [_timer invalidate];
        _timer=nil;
        _i=0;
    }
    
}



- (IBAction)nextAction:(id)sender {
    
    if (self.photoNumTextField.text.length <1 )
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入电话号码"];
        
        return;
        
    }else if (self.acodeTextField.text.length <1 )
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入验证码"];
        return;
        
    }else if (![self isValidateMobile:self.photoNumTextField.text])
    {
        [QYHProgressHUD showErrorHUD:nil message:@"请输入合法的手机号码"];
        return;
    }
    
    //验证验证码是否正确
    
    [SMSSDK commitVerificationCode:self.acodeTextField.text phoneNumber:self.photoNumTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            NSLog(@"验证成功");
            
            QYHRecoderPasswordViewController *setPassWordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHRecoderPasswordViewController"];
            
            [self.navigationController pushViewController:setPassWordVC animated:YES];
            
        }  else
        {
            [QYHProgressHUD showErrorHUD:nil message:@"验证码错误"];
            NSLog(@"错误信息:%@",error);
        }
    }];
}
     

/* 手机号码验证 */
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//结束键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
