//
//  AppDelegate.m
//  Original
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "GuidViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <SMS_SDK/SMSSDK.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

static NSString *SMSappKey    = @"120625f209b55";
static NSString *SMSappSecret = @"95be22fdbab50ddcffc0009cd773750a";

static NSString *SHAREappKey    = @"1126ca64eadd6";
static NSString *SHAREappSecret = @"648db18ccafadf5a7a86a5a843c490b6";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
       
    //将是否使用过APP记录,放到NSUserDefault中.
    NSUserDefaults *myDefault=[NSUserDefaults standardUserDefaults];
    NSString *isFirst=[myDefault objectForKey:@"isFirst"];
    
    //如果不是第一次就直接进入首页
    if ([isFirst isEqualToString:@"NO"])
    {
        //取到storyboard
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarController *main=[story instantiateViewControllerWithIdentifier:@"TabBarController"];
        
        self.window.rootViewController=main;
        
    }else//如果是第一次就进入引导页
    {
        
        GuidViewController *guid=[[GuidViewController alloc]init];
        
        self.window.rootViewController=guid;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    
    [SMSSDK registerApp:SMSappKey withSecret:SMSappSecret];
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    //App Secre:648db18ccafadf5a7a86a5a843c490b6
    //App Key:1126ca64eadd6
    
    [ShareSDK registerApp:SHAREappKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"4175569942"
                                           appSecret:@"d7783fc28a71fa2cd355abe77adf3b5b"
                                         redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx9bbd60f498fe73b8"
                                       appSecret:@"698f2ccdd9e89c623427c936915c2156"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105274795"
                                      appKey:@"drqHsVHVKMTycqwM"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
