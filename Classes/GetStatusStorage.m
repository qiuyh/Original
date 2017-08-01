//
//  GetStatusStorage.m
//  Original
//
//  Created by 邱永槐 on 16/4/23.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "GetStatusStorage.h"
#import "HttpreQuestManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@implementation GetStatusStorage

+(instancetype)shareInstance
{
    
    static GetStatusStorage *manager=nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager=[[GetStatusStorage alloc]init];
    });
    
    
    return manager;
}


- (void)getStaus
{
    
    NSString *fileName = @"info.json";
    
    [[QYHQiNiuRequestManarger shareInstance]getFile:fileName withphotoNumber:nil Success:^(id responseObject) {
        
        NSLog(@"查询是否登录==%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *imageUrl  = [responseObject objectForKey:@"imageUrl"];
            NSString *passWord  = [responseObject objectForKey:@"passWord"];
            NSString *nickName  = [responseObject objectForKey:@"nickName"];
            BOOL      isRegist  = [[responseObject objectForKey:@"isRegist"] boolValue];
            BOOL   loginStatus  = [[responseObject objectForKey:@"loginStatus"] boolValue];
            
            [UserStorage shareInstance].imageUrl  = imageUrl;
            [UserStorage shareInstance].passWord  = passWord;
            [UserStorage shareInstance].nickname  = nickName;
            [UserStorage shareInstance].uid       = nil;
            [UserStorage shareInstance].isLogined = loginStatus;
            
             NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
            [accountPassword setObject:@(YES) forKey:@"isLogined"];
        }
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"查询是否登录失败");
    }];
    
}

- (void)getSatueSSEBaseUser

{
    SSEBaseUser *user = [SSEThirdPartyLoginHelper currentUser];
    
    NSLog(@"user=========%@, user.socialUsers==%@",user, [user.socialUsers[@(998)] class]);
    
    if (user)
    {
        NSLog(@"user=========%@, user.socialUsers==%@",user, [user.socialUsers[@(1)] class]);
        [UserStorage shareInstance].isLogined = YES;
        [UserStorage shareInstance].user      = user;
        
        NSNumber *firstNum = nil;
        
        NSUserDefaults *userType = [NSUserDefaults standardUserDefaults];
        
        SSDKPlatformType type = [[userType objectForKey:@"loginType"] integerValue];
        SSDKUser *socialUsers = nil;
        
        
        switch (type)
        {
            case SSDKPlatformTypeSinaWeibo:
                firstNum  = @(1);
                break;
            case SSDKPlatformTypeQQ:
                firstNum  = @(998);
                break;
            case SSDKPlatformTypeWechat:
                
#pragma 微信未知参数。。。。。。。。
                firstNum  = @(1323);
                break;
                
            default:
                break;
        }
        
        
        socialUsers = user.socialUsers[firstNum];
        
        NSDictionary *rawData = socialUsers.rawData;
        
        switch (type)
        {
            case SSDKPlatformTypeSinaWeibo:
//                nickname = user.rawData[@"name"] ;
                [UserStorage shareInstance].imageUrl  = rawData[@"avatar_hd"] ;
                break;
            case SSDKPlatformTypeQQ:
//                nickname = user.rawData[@"nickname"] ;
                [UserStorage shareInstance].imageUrl  = rawData[@"figureurl_qq_2"] ;
                break;
            case SSDKPlatformTypeWechat:
//                nickname = user.rawData[@"name"] ;
                [UserStorage shareInstance].imageUrl  = rawData[@"avatar_hd"] ;
                break;
                
            default:
                break;
        }

        
        [UserStorage shareInstance].uid      =  socialUsers.uid;
        [UserStorage shareInstance].nickname  = socialUsers.nickname;
//        [UserStorage shareInstance].imageUrl  = socialUsers.icon;
        
        
        NSLog(@"%@,%@,%@,rawData==%@",socialUsers.uid,socialUsers.nickname,socialUsers.icon,rawData);
        
        //        NSUserDefaults *userManer = [NSUserDefaults standardUserDefaults];
        //
        //        [UserStorage shareInstance].uid      = [userManer objectForKey:@"uid"];
        //        [UserStorage shareInstance].nickname  = [userManer objectForKey:[NSString stringWithFormat:@"nickname%@", [UserStorage shareInstance].uid]];
        //        [UserStorage shareInstance].imageUrl      = [userManer objectForKey:[NSString stringWithFormat:@"imageUrl%@", [UserStorage shareInstance].uid]];
        //        [UserStorage shareInstance].token      = [userManer objectForKey:[NSString stringWithFormat:@"token%@", [UserStorage shareInstance].uid]];
        
    }else
    {
        [self getStaus];
    }
    
}


@end
