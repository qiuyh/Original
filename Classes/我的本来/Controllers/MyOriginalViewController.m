//
//  MyOriginalViewController.m
//  Original
//
//  Created by qianfeng on 15/9/19.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "MyOriginalViewController.h"
#import "MyoderViewController1.h"
#import "PrDreviewsViewController.h"
#import "AboutBenLaiViewController.h"
#import "SuggestionsViewController.h"
#import "MyColectionViewController.h"
#import "AccountManageViewController.h"
#import "GiftCardViewController.h"
#import "CouponViewController.h"
#import "TabBarController.h"
#import "LocationViewController.h"
#import "SetViewController.h"
#import "MainViewController.h"

#import "HttpreQuestManager.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NetInterface.h"
#import "QYHProgressHUD.h"
//#import "UIImageView+AFNetworking.h"

#import "UserStorage.h"
#import "QYHLoginViewController.h"
#import "QYHRegistViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import "UIImageView+WebCache.h"

#import "NSString+Validate.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface MyOriginalViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,NSURLSessionDelegate>

{
    BOOL _isEdit;//用于判断是否对昵称进行编辑
    UILabel *_label;//弹出提示作用
    
    BOOL _isCity;
    NSString *_cityName;
    
    BOOL isLogin;
    
    UIImageView *imgView;
    

}

@property (weak, nonatomic) IBOutlet UITextField *myTextView;//文本框
@property (weak, nonatomic) IBOutlet UILabel *integral;//可以积分
@property (weak, nonatomic) IBOutlet UILabel *coupon;//优惠劵
@property (weak, nonatomic) IBOutlet UILabel *giftCard;//礼金卡
@property (weak, nonatomic) IBOutlet UILabel *accountBalance;//账户余额
@property (weak, nonatomic) IBOutlet UIButton *img;//头像

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bttomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight1;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight2;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIButton *headView;
@property (weak, nonatomic) IBOutlet UIButton *headView1;
@property (weak, nonatomic) IBOutlet UITextField *headView2;
@property (weak, nonatomic) IBOutlet UIButton *headView3;
@property (weak, nonatomic) IBOutlet UILabel *headView4;
@property (weak, nonatomic) IBOutlet UILabel *headView5;
@property (weak, nonatomic) IBOutlet UILabel *headView6;
@property (weak, nonatomic) IBOutlet UILabel *headView7;
@property (weak, nonatomic) IBOutlet UILabel *headView8;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height2;

@property (weak, nonatomic) IBOutlet UIButton *longinBtn;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation MyOriginalViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityName:) name:@"city" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [_button setTitle:_cityName forState:UIControlStateNormal];
    
    self.viewHeight.constant=self.view.frame.size.height/4.3;
    self.bttomHeight.constant=self.view.frame.size.height/8.0;
    self.phoneHeight.constant=self.view.frame.size.height/30.0;
    self.phoneHeight1.constant=self.view.frame.size.height/30.0;
    self.phoneHeight2.constant=self.view.frame.size.height/30.0;
    
    self.longinBtn.layer.cornerRadius    = 15.0f;
    self.longinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.longinBtn.layer.borderWidth     = 1.0f;
    self.longinBtn.layer.masksToBounds   = YES;
    
    self.registBtn.layer.cornerRadius    = 15.0f;
    self.registBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registBtn.layer.borderWidth     = 1.0f;
    self.registBtn.layer.masksToBounds   = YES;
    
}

- (void)delay2:(UIImageView *)ImgView
{
    
   __block  BOOL isEnd  = NO;
    
    dispatch_async ( dispatch_get_global_queue ( DISPATCH_QUEUE_PRIORITY_DEFAULT , 0 ), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            isEnd = YES;
        });

        for (; 1; )
        {
            if(imgView.image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSLog(@" imgView.image==%@", imgView.image);
                    _headImageView.image = imgView.image;
                    
                    //把图片转为二进制数据
                    NSData *data = UIImageJPEGRepresentation(ImgView.image, 1.0);
                    
                    //取到沙盒路径
                    NSString *homePath = NSHomeDirectory();
                    
                    NSString *path= nil;
                    if ( [UserStorage shareInstance].uid)
                    {
                        path = [NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",homePath,[UserStorage shareInstance].uid];
                    }else
                    {
                        NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
                        
                        path = [NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",homePath,[accountPassword objectForKey:@"account"]];
                    }
                    
                    //写入沙盒
                    [data writeToFile:path atomically:YES];
                    
                    
                });
               
                break;
                
            }else
            {
                
                if (isEnd)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    });
                    
                    break;
                }
            }
        }
        
        
    });
    
    
    
}


//md5加密
-(NSString *)MD5ByAStr:(NSString *)aSourceStr
{
    const char* cStr = [aSourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (void)getIsLogin
{
    [[GetStatusStorage shareInstance]getSatueSSEBaseUser];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    imgView = [[UIImageView alloc]init];
    
    
    if (![UserStorage shareInstance].isPopRoot)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else
    {
        [UserStorage shareInstance].isPopRoot = NO;
    }
    
    
    SSEBaseUser *user = [SSEThirdPartyLoginHelper currentUser];
    
    if (user)
    {
        
        [self getIsLogin];
    }
    
    //取到沙盒路径
    NSString *homePath = NSHomeDirectory();
    
    NSString *path= nil;
    if ( [UserStorage shareInstance].uid)
    {
        path = [NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",homePath,[UserStorage shareInstance].uid];
        
    }else
    {
        NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
        
        path = [NSString stringWithFormat:@"%@/Documents/%@uploadfile.jpeg",homePath,[accountPassword objectForKey:@"account"]];
        
    }
    
    [_headImageView setImage:[UIImage imageWithContentsOfFile:path]];
    
    self.headView2.text = [UserStorage shareInstance].nickname;
    
    if (!_headImageView.image)
    {
        _headImageView.image = [UIImage imageNamed:@"sun"];
    }
    
    
    NSLog(@"path==%@",path);
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=NO;
    
    [_button setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
    
    
    isLogin = [UserStorage shareInstance].isLogined;
    
    
    NSLog(@"isLogin==%d",isLogin);
    
    [self isLogined:isLogin];
    
    if (isLogin)
    {
        
        if ( [UserStorage shareInstance].uid)
        {
            
            NSUserDefaults *userManer = [NSUserDefaults standardUserDefaults];
            
            if (![[UserStorage shareInstance].imageUrl isEqualToString: [userManer objectForKey:[NSString stringWithFormat:@"imageUrl%@", [UserStorage shareInstance].uid]]])
            {
                [userManer setObject:[UserStorage shareInstance].imageUrl forKey:[NSString stringWithFormat:@"imageUrl%@", [UserStorage shareInstance].uid]];
                
                //                UIImageView *ImgView = [[UIImageView alloc]init];
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:[UserStorage shareInstance].imageUrl]];
                NSLog(@"[UserStorage shareInstance].imageUrl]===%@",[UserStorage shareInstance].imageUrl);
                
                [self delay2:imgView];
                //                [self performSelector:@selector(delay2:) withObject:_headImageView afterDelay:12.0];
                
            }
            
            if (![UIImage imageWithContentsOfFile:path])
            {
                
                [imgView sd_setImageWithURL:[NSURL URLWithString:[UserStorage shareInstance].imageUrl]];
                
                [self delay2:imgView];
            }
            
            
            self.headView2.text = [UserStorage shareInstance].nickname;
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        }else
        {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970]*1000;
            NSString *timeString = [NSString stringWithFormat:@"%f",a];
            
            //图片的地址。。。。。。。。。
            NSString *contentURL = [NSString stringWithFormat:@"%@?_=%@",[UserStorage shareInstance].imageUrl,timeString];
            
            NSLog(@"contentURL = %@",contentURL);
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:contentURL]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            [self delay2:imgView];
            
        }
        
        
    }else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)isLogined:(BOOL)isLogined
{
    
    self.longinBtn.hidden = isLogined;
    self.registBtn.hidden = isLogined;
    
    self.headView.hidden  = !isLogined;
    self.headView1.hidden = !isLogined;
    self.headView2.hidden = !isLogined;
    self.headView3.hidden = !isLogined;
    self.headView4.hidden = !isLogined;
    self.headView5.hidden = !isLogined;
    self.headView6.hidden = !isLogined;
    self.headView7.hidden = !isLogined;
    self.headView8.hidden = !isLogined;
    
    self.headImageView.hidden = !isLogined;

    
    self.height.constant  = isLogined ? 50 : 25;
    self.height1.constant = isLogined ? 50 : 25;
    self.height2.constant = isLogined ? 50 : 25;

    
}

- (void)cityName:(NSNotification *)info
{
    [_button setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"city" object:nil];
}


//设置
- (IBAction)setting:(id)sender {
    
    SetViewController *setVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SetViewController"];
    [self.navigationController pushViewController:setVC animated:YES];
    
//    TabBarController *tab =(TabBarController *) self.tabBarController;
//    tab.myTabBar.hidden=YES;

}
//定位
- (IBAction)city:(id)sender {
    
    LocationViewController *locationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationVC.buttonName=_button.currentTitle;
     locationVC.suggestCityName=[UserStorage shareInstance].suggestCityName;
    [self.navigationController pushViewController:locationVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;


}
//提示上传头像的方式
- (IBAction)camera:(id)sender {
    
    if ( [UserStorage shareInstance].uid)
    {
        [QYHProgressHUD showErrorHUD:nil message:@"第三方登录不支持上传头像"];
        
        return;
    }
    //从底部出现提示
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"相机拍照",nil];
    
    [sheet showInView:self.view];
    
}
//进入选择的方式选取头像
- (void)uploadAvatar:(UIImagePickerControllerSourceType )type
{
    //读取图片的控制器
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    
    //设置代理
    pick.delegate = self;
    pick.sourceType =type;
    [self presentViewController:pick animated:YES completion:nil];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    

}

//修改昵称
- (IBAction)edit:(id)sender {
    
    if ( [UserStorage shareInstance].uid)
    {
        [QYHProgressHUD showErrorHUD:nil message:@"第三方登录不支持修改昵称"];
        
        return;
    }

    
    UIButton *button=(UIButton *)sender;
    
    _isEdit = !_isEdit;
    button.selected = !button.selected;
    
    if ( _isEdit)
    {
        [QYHProgressHUD showHUDInView:self.view onlyMessage:@"编辑昵称"];
        
    }else
    {
        
        NSString *fileName = @"info.json";
        
        NSString *imageUrl  = [UserStorage shareInstance].imageUrl;
        NSString *passWord  = [UserStorage shareInstance].passWord;
        NSString *nickName  = self.headView2.text;
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
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [QYHProgressHUD showSuccessHUD:nil message:@"编辑成功"];
            
            [UserStorage shareInstance].nickname = self.headView2.text;
            
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [QYHProgressHUD showErrorHUD:nil message:@"编辑失败"];
        }];
        
        
    }
}

//查看优惠劵
- (IBAction)couponButton:(id)sender {
    
    if ([UserStorage shareInstance].isLogined)
    {
        CouponViewController *couponVC= [self.storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
        [self.navigationController pushViewController:couponVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }
   
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
}
//查看礼金卡
- (IBAction)giftCardButton:(id)sender {
    
    if ([UserStorage shareInstance].isLogined)
    {
        GiftCardViewController *giftCardVC= [self.storyboard instantiateViewControllerWithIdentifier:@"GiftCardViewController"];
        [self.navigationController pushViewController:giftCardVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }

    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
}
//查看我的订单
- (IBAction)myOrder:(id)sender {
    
    if ([UserStorage shareInstance].isLogined)
    {
        MyoderViewController1 *orderVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyoderViewController1"];
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
}
//查看商品评论
- (IBAction)prDreviews:(id)sender {
    
    if ([UserStorage shareInstance].isLogined)
    {
        PrDreviewsViewController *dreviewsrVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PrDreviewsViewController"];
        [self.navigationController pushViewController:dreviewsrVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;

}
//账户管理
- (IBAction)accountManage:(id)sender {
    
    if ([UserStorage shareInstance].isLogined)
    {
        AccountManageViewController *managerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AccountManageViewController"];
        [self.navigationController pushViewController:managerVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
}
//查看我的收藏
- (IBAction)myColection:(id)sender {
    
    if ([UserStorage shareInstance].isLogined)
    {
        MyColectionViewController *colectionVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyColectionViewController"];
        [self.navigationController pushViewController:colectionVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }

    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
}
//查看关于本来
- (IBAction)aboutBenLai:(id)sender {
    
    AboutBenLaiViewController *aboutVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AboutBenLaiViewController"];
    [self.navigationController pushViewController:aboutVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
   
}
//产品建议
- (IBAction)suggestions:(id)sender {
    
//        [self putFile];
    
    if ([UserStorage shareInstance].isLogined)
    {
        SuggestionsViewController *suggestVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SuggestionsViewController"];
        [self.navigationController pushViewController:suggestVC animated:YES];
        
    }else
    {
        QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
        
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
  
}
//拨打电话
- (IBAction)call:(id)sender {
    
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"是否拨打客户电话" message:@"4008000917" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    aler.delegate=self;
    
    //让提示框显示
    [aler show];

}


//触摸开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark-UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_isEdit)//如果点击了编辑就允许编辑
    {
         return YES;
    }else
    {
         return NO;
    }
   
}
//结束输入
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}

#pragma mark-UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
   //    NSLog(@"%d",buttonIndex);
    if (buttonIndex==0)
    {//选择从图库选择照片上传头像
        [self uploadAvatar:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
       
    }else if (buttonIndex==1)
    {//选择通过相机拍照上传头像
        [self uploadAvatar:UIImagePickerControllerSourceTypeCamera];
    }

}


#pragma mark - UIImagePickerControllerDelegate
//选择图片的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

//        NSLog(@"info==%@",info);
    //把图片转为二进制数据
    NSData *data = UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"], 0.1);
    
    //取到沙盒路径
    NSString *homePath = NSHomeDirectory();
    
    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
    NSString       *account = [accountPassword valueForKey:@"account"];

    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@/uploadfile.jpeg",homePath,account];
//                    stringByAppendingString:@"/Documents/uploadfile.jpeg"];
//    NSLog(@"homePath==%@",path);
    //写入沙盒
    [data writeToFile:path atomically:YES];
    
    
    [self uploadfile:data];
    
    //退出图片选择器
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)uploadfile:(NSData *)data
{
    if ( [UserStorage shareInstance].uid)
    {
       
        
    }else
    {
        
        NSString *fileName = @"uploadfile.jpeg";
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName withphotoNumber:nil data:data Success:^(id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
    
            _headImageView.image = [UIImage imageWithData:data];
            [QYHProgressHUD showSuccessHUD:nil message:@"上传成功"];
            
            imgView.image  = nil;
            
            imgView.image = [UIImage imageWithData:data];
            
            [self delay2:imgView];
            
           
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [QYHProgressHUD showErrorHUD:nil message:@"上传失败"];
        }];
       
    }
    
}

#pragma mark-UIAlertViewDelegate
//选中第几个
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //进入拨电话界面,系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]]];
//        NSLog(@"%@",alertView.message);
    }
}

//登录
- (IBAction)loginButton:(id)sender {
    
    
    QYHLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHLoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
//    [self presentViewController:loginVC animated:YES completion:^{
//        
//    }];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
}

- (IBAction)registButton:(id)sender {
    

    QYHRegistViewController *registVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QYHRegistViewController"];
    [self.navigationController pushViewController:registVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;


}


@end
