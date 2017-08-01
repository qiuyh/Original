//
//  ChangePhoneNumViewController.m
//  Original
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "ChangePhoneNumViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "NSString+Validate.h"

@interface ChangePhoneNumViewController ()

{
    NSString *_identity;//原来手机号得到的验证码
    NSTimer *_timer;//定时器来计算倒计时60s
    int _i;//结合定时器来计算倒计时的数
    
    NSString *_passWord;
}

@property (weak, nonatomic) IBOutlet UITextField *identifing;//验证码输入框

@property (weak, nonatomic) IBOutlet UILabel *tipWord;//不正确时提示

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipHeight;//提示label的高度
@property (weak, nonatomic) IBOutlet UILabel *reGetIdentify;//显示重新获取验证码和倒计时
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vSpace;//提示label的距离上面控件的距离
@property (weak, nonatomic) IBOutlet UIButton *button;//获取验证码的按钮
@property (weak, nonatomic) IBOutlet UITextField *inputPhoneNum;//输入新手机号的文本框
@property (weak, nonatomic) IBOutlet UILabel *originPhoneNum;//原来的手机号



@end

@implementation ChangePhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
    
    self.originPhoneNum.text = [accountPassword objectForKey:@"account"];
    
    
   _passWord  = [UserStorage shareInstance].passWord;

}

//视图即将出现
-(void)viewWillAppear:(BOOL)animated
{
    //更改约束,隐藏提示的label
    _tipHeight.constant=0;
    _tipWord.hidden=YES;
    
    //假设验证码为536278
//    _identity=@"536278";
//    _identity1=@"123456";
    //先隐藏按下获取验证码时弹出的重新获取验证码和倒计时label
    self.reGetIdentify.hidden=YES;
    //第一个页面先隐藏输入新手机号的文本框,显示原来的手机号;点击系一部第二次进入时显示输入新手机号的文本框,隐藏原来的手机号
    self.inputPhoneNum.hidden=!self.show;
    self.originPhoneNum.hidden=self.show;
}

//获取验证码
- (IBAction)getIdentifi:(id)sender {
    //如果是点击下一步的第二次进入
    if (self.show)
    {
        //更改约束
        _tipHeight.constant=21;
        _tipWord.hidden=NO;
        //显示相应的提示
        if (self.inputPhoneNum.text.length<1)
        {
            self.tipWord.text=@"请输入手机号!";
            return;
        }else if (![self isMobileNumber:self.inputPhoneNum.text])
        {
            self.tipWord.text=@"请输入正确的手机号!";
            return;
        }
    }
    //隐藏获取验证码按钮并显示重新获取验证码和倒计时的label
    UIButton *button=(UIButton *)sender;
    button.hidden=YES;
    self.reGetIdentify.hidden=NO;
    //更改约束
    self.vSpace.constant=39;
    _tipHeight.constant=21;
    _tipWord.hidden=NO;
    
    self.tipWord.text=@"验证码已经发送至您的手机,60s后可以重新获取验证码";
     self.reGetIdentify.text=@"重新获取60s";
    //60s定时不断刷新数据,
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    
  
    NSString *phoneNum = self.show ? self.inputPhoneNum.text:self.originPhoneNum.text;
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
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
    self.reGetIdentify.text=[NSString stringWithFormat:@"重新获取(%ds)",(59-_i)];
    _i++;
    if (_i>59)
    {
        //60s后,//显示获取验证码按钮并隐藏重新获取验证码和倒计时的label和销毁定时器
        [self.button setTitle:@"重新获取" forState:UIControlStateNormal];
        self.button.hidden=NO;
        self.reGetIdentify.hidden=YES;
        self.vSpace.constant=9;
        [_timer invalidate];
        _timer=nil;
        _i=0;
    }
    
}

//点击下一步
- (IBAction)next:(id)sender {
    
    //如果是点击下一步的第二次进入
    if (self.show)
    {
        //显示相应的提示
        if (self.inputPhoneNum.text.length<1)
        {
            //更改约束
            _tipHeight.constant=21;
            _tipWord.hidden=NO;

            self.tipWord.text=@"请输入手机号!";
        }else if (![self isMobileNumber:self.inputPhoneNum.text])
        {
            //更改约束
            _tipHeight.constant=21;
            _tipWord.hidden=NO;

            self.tipWord.text=@"请输入正确的手机号!";
        }else if (self.identifing.text.length<1)
        {
            //更改约束
            _tipHeight.constant=21;
            _tipWord.hidden=NO;

            self.tipWord.text=@"请输入验证码!";
        }else
        {
            
            [QYHProgressHUD  showHUDAddedTo:self.view animated:YES];
            
            [SMSSDK commitVerificationCode:self.identifing.text phoneNumber:self.inputPhoneNum.text zone:@"86" result:^(NSError *error) {
                
                //                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (!error) {
                    NSLog(@"验证成功");
                    //更改手机的操作........................................
                    
                    
                    NSString *fileName = @"info.json";
                    
                    NSString *imageUrl  = [UserStorage shareInstance].imageUrl;
                    NSString *passWord  = [UserStorage shareInstance].passWord;
                    NSString *nickName  = [UserStorage shareInstance].nickname;
                    BOOL      isRegist  = NO;
                    BOOL   loginStatus  = NO;
                    
                    NSDictionary *dic   = @{@"imageUrl"   : imageUrl,
                                            @"passWord"   : passWord,
                                            @"nickName"   : nickName,
                                            @"isRegist"   : @(isRegist),
                                            @"loginStatus": @(loginStatus)};
                    
                    NSString *str = [NSString dictionaryToJson:dic];
                    
                    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName withphotoNumber:nil data:data Success:^(id responseObject) {
                        
                         NSString *fileName1 = @"info.json";
                        
                        NSString *imageUrl1  = [UserStorage shareInstance].imageUrl;
                        NSString *passWord1  = [UserStorage shareInstance].passWord;
                        NSString *nickName1  = [UserStorage shareInstance].nickname;
                        BOOL      isRegist1  = YES;
                        BOOL   loginStatus1  = YES;
                        
                        NSDictionary *dic1   = @{@"imageUrl"   : imageUrl1,
                                                 @"passWord"   : passWord1,
                                                 @"nickName"   : nickName1,
                                                 @"isRegist"   : @(isRegist1),
                                                 @"loginStatus": @(loginStatus1)};
                        
                        NSString *str1 = [NSString dictionaryToJson:dic1];
                        
                        NSData *data1 =[str1 dataUsingEncoding:NSUTF8StringEncoding];
                        
                        
                        [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName1 withphotoNumber:self.inputPhoneNum.text data:data1 Success:^(id responseObject) {
                            
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
//                            NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
                            
//                            [accountPassword setObject:self.inputPhoneNum.text forKey:@"account"];
//                            [accountPassword setObject:_passWord forKey:@"password"];
//                            [accountPassword setObject:@"1" forKey:@"rememberPasswordBtn"];
                            
                            [QYHProgressHUD showSuccessHUD:nil message:@"更改手机号成功"];
                            
                            [UserStorage shareInstance].isPopRoot = YES;
                            
                            [UserStorage shareInstance].isLogined = NO;
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                            
                        } failure:^(NSError *error) {
                            
                            NSDictionary *err = error.userInfo;
                            
                            [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            
                            if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
                            {
                                [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
                                
                            }else
                            {
                                
                                [QYHProgressHUD showErrorHUD:nil message:@"更改手机号失败"];
                            }
                            
                            NSLog(@"更改手机号失败error==%@",error);
                            
                        }];

                        
                    } failure:^(NSError *error) {
                        
                        NSDictionary *err = error.userInfo;
                        
                        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                        
                        if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
                        {
                            [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
                            
                        }else
                        {
                            
                            [QYHProgressHUD showErrorHUD:nil message:@"更改手机号失败"];
                        }
                        
                        NSLog(@"更改手机号失败error==%@",error);
                        
                    }];
                }
                else
                {
                    //更改约束
                    _tipHeight.constant=21;
                    _tipWord.hidden=NO;
                    
                    self.tipWord.text=@"验证码不正确!";
                    
                    [QYHProgressHUD showErrorHUD:nil message:@"验证码错误"];
                    NSLog(@"错误信息:%@",error);
                }
            }];
            
        }
        
    }else
    {
        //显示相应的提示
        if (self.identifing.text.length<1)
        {
            self.tipWord.text=@"请输入验证码!";
        }else
        {
            
            [SMSSDK commitVerificationCode:self.identifing.text phoneNumber:self.originPhoneNum.text zone:@"86" result:^(NSError *error) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (!error) {
                    NSLog(@"验证成功");
                    
                    ChangePhoneNumViewController *chVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePhoneNumViewController"];
                    chVC.show=YES;//传值用于判断是否是第二次进入
                    [self.navigationController pushViewController:chVC animated:YES];
                }
             else
             {
                 //更改约束
                 _tipHeight.constant=21;
                 _tipWord.hidden=NO;

                 self.tipWord.text=@"验证码不正确!";
                 
                 [QYHProgressHUD showErrorHUD:nil message:@"验证码错误"];
                 NSLog(@"错误信息:%@",error);
             }
             }];
            
        }
    }
}

//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//返回(修改电话号码)
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
