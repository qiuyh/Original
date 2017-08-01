//
//  ShareCustomView.m
//  Original
//
//  Created by iMacQIU on 16/4/19.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "ShareCustomView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#define LCOUNT 3
#define SPACE  35
#define HCOUNT 2
#define HEIGHT ((SCREEN_WIDTH - SPACE*4)/3.0*HCOUNT + (HCOUNT+1)*SPACE)

@implementation ShareCustomView

{
    UIView *view;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self = [[ShareCustomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-HEIGHT, SCREEN_WIDTH, HEIGHT)];
    }
    return self;
}

- (void)show
{
  
    self.backgroundColor  = [UIColor whiteColor];
    
    [self layoutSubviews];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 300, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = [UIColor blackColor] ;
    label.font            = [UIFont systemFontOfSize:18];
    label.text            = @"分享到:";
    
    [self addSubview:label];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor darkGrayColor];
    view.alpha = 0.6;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:tapGestureRecognizer];
//    [self addGestureRecognizer:tapGestureRecognizer];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect rect1  = self.frame;
    CGRect rect   = self.frame;
    rect.origin.y = SCREEN_HEIGHT;
    self.frame  = rect;
    
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.1 initialSpringVelocity:1.1 options:7 animations:^{
        
        self.frame = rect1;
        
    } completion:^(BOOL finished) {
        
    }];


}

-(void)layoutSubviews
{
    
    NSArray *imageArray  =@[@"weixinChat",@"weixinpen",@"weixinF",@"qqChat",@"qqZ",@"weibo"];
    NSArray *titleArray  =@[@"微信",@"朋友圈",@"收藏",@"QQ",@"空间",@"微博"];
    
    CGFloat with   = (SCREEN_WIDTH - SPACE*4)/3.0;
    CGFloat height = with;

    for (int i = 0; i < LCOUNT; i++)
    {
        for (int j = 0; j < HCOUNT; j++)
        {
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((SPACE+with)*i + SPACE, (SPACE+height)*j + SPACE, with, height);
            [button setImage:[UIImage imageNamed:imageArray[i+j*LCOUNT]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imageArray[i+j*LCOUNT]] forState:UIControlStateHighlighted];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, height, with, 21)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor       = [UIColor blackColor] ;
            label.font            = [UIFont systemFontOfSize:15];
            label.text            = titleArray[i+j*LCOUNT];
            label.textAlignment   = NSTextAlignmentCenter;
            
            [button addSubview:label];
            
            
            button.tag = 100 + i + j*LCOUNT;
            
            [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            
            CGRect rect1  = button.frame;
            CGRect rect   = button.frame;
            rect.origin.y = HEIGHT + rect.origin.y;
            button.frame  = rect;
            
            
            [UIView animateWithDuration:0.5 delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:7 animations:^{
                
                button.frame = rect1;
                
            } completion:^(BOOL finished) {
                
            }];
        }
       
    }

}

- (void)shareClick:(UIButton *)button

{

    NSLog(@"button.tag==%ld",(long)button.tag);
    
    NSUInteger type  = 0;
    
    switch (button.tag)
    {
        case 100:
            type = SSDKPlatformSubTypeWechatSession;
            break;
            
        case 101:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;

        case 102:
            type = SSDKPlatformSubTypeWechatFav;
            break;

        case 103:
            type = SSDKPlatformSubTypeQQFriend;
            break;

        case 104:
            type = SSDKPlatformSubTypeQZone;
            break;
            
        case 105:
            type = SSDKPlatformTypeSinaWeibo;
            break;
            
        default:
            break;
    }
   
    
    
    [self keyboardHide:nil];
    
    //自定义界面
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //用客户端
    [shareParams SSDKEnableUseClientShare];
    
    
    [shareParams SSDKSetupShareParamsByText:@"我在@本来生活，发现了极致美食，赶快过来一起做一个资深吃货吧？http://m.benlai.com"
                                     images:[UIImage imageNamed:@"AppIcon40x40"]
                                        url:[NSURL URLWithString:@"http://m.benlai.com"]
                                      title:@"Original"
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
                
            default:
                break;
        }
        
    }];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
    [view removeFromSuperview];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
    [view removeFromSuperview];

}



@end
