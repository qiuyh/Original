//
//  UserStorage.h
//  Original
//
//  Created by iMacQIU on 16/1/30.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@class Model;
@class SSEBaseUser;

@interface UserStorage : NSObject


@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *suggestCityName;


@property (nonatomic, assign) BOOL isLogined;

@property (nonatomic, assign) BOOL isPopRoot;

@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *account;


@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *noReCommandCount;
@property (nonatomic, copy) NSString *rankName;
@property (nonatomic, copy) NSString *safePhoneShow;
@property (nonatomic, copy) NSString *suggestionCount;
@property (nonatomic, copy) NSString *username;
@property (nonatomic,strong) SSEBaseUser *user;

@property (nonatomic, strong) NSDictionary *loginInfo;// customerID = 13763067912;isLogin = 1;
@property (nonatomic, strong) NSDictionary *iconPay;

@property (nonatomic, strong) NSDictionary *iconList;

+(instancetype)shareInstance;

- (void)setCityName:(NSString *)CurrenCityName;

@end


@interface Model : NSObject <NSCoding>





@end