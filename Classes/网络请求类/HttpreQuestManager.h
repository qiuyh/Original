//
//  HttpreQuestManager.h
//  Original
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>
//成功回调
typedef void (^httpSuccess)(id responseObject);
//失败回调
typedef void (^httpFailure)(NSError *error);

@interface HttpreQuestManager : NSObject

+ (instancetype)shareInstance;


//lotType=1 广告   lotType=2 主页
- (void)GetAPPHomePage:(int)lotType success:(httpSuccess)success failure:(httpFailure)failure;
//获取分类的主页
- (void)getCategorySuccess:(httpSuccess)success failure:(httpFailure)failure;
//获取新品的主页
- (void)getNewProductPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure;
//获取商品详情
- (void)getProductDetailWithproductSysNo:(int)sysNo success:(httpSuccess)success failure:(httpFailure)failure;
//评价
- (void)getProductReviewsNewproductSysNo:(int)productSysNo withPage:(int)page withType:(int)type success:(httpSuccess)success failure:(httpFailure)failure;
//获取Subject的
- (void)getSubjectWithproductSysNo:(int)sysNo Page:(int)page success:(httpSuccess)success failure:(httpFailure)failure;
//获取热排的主页
- (void)getHotProductsPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure;
//获取分类点击进入对应的(其他分类)数据
- (void)getProductListSort:(int)sort c1SysNo:(int)c1SysNo c2SysNo:(int)c2SysNo withPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure;
//获取分类点击进入对应的(全部)数据
- (void)getProductAllListSort:(int)sort c1SysNo:(int)c1SysNo withPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure;
//获取对应网址的数据
- (void)getProductWithUrl:(NSString *)url success:(httpSuccess)success failure:(httpFailure)failure;

//sort=%d&source=3&c1SysNo=%d&c2SysNo=%d&offset=%d  ProductList
//获取定位信息
- (void)getSiteListSuccess:(httpSuccess)success failure:(httpFailure)failure;

//获取热门搜索信息
- (void)getRecommendSearchKeySuccess:(httpSuccess)success failure:(httpFailure)failure;

//获取搜索关键词
- (void)getSearchKeySuccess:(httpSuccess)success failure:(httpFailure)failure;

//获取使用帮助
- (void)getHelpSuccess:(httpSuccess)success failure:(httpFailure)failure;
//上传头像
- (void)getHelpWithFileNAme:(NSString *)fileName success:(httpSuccess)success failure:(httpFailure)failure;
//登陆
- (void)loginWithCustomerID:(NSString *)customerID md5Pwd:(NSString *)md5Pwd success:(httpSuccess)success failure:(httpFailure)failure;
-(void)loginWithCustomerID1:(NSString *)customerID md5Pwd1:(NSString *)md5Pwd success:(httpSuccess)success failure:(httpFailure)failure;
//退出
- (void)logoutSuccess:(httpSuccess)success failure:(httpFailure)failure;
//我的本来
- (void)getIUserHomeSuccess:(httpSuccess)success failure:(httpFailure)failure;

//编辑昵称
- (void)editNickNameWithNickName:(NSString *)nickName CustomerID:(NSString *)customerID success:(httpSuccess)success failure:(httpFailure)failure;
//获取验证码
- (void)getSNSCodeWithCellphone:(NSString *)cellphone success:(httpSuccess)success failure:(httpFailure)failure;

- (void)nextSNSCodeWithCellphone:(NSString *)cellphone code:(NSString *)code password:(NSString *)password name:(NSString *)name success:(httpSuccess)success failure:(httpFailure)failure;

- (void)regiserSNSCodeWithCellphone:(NSString *)cellphone psw:(NSString *)psw success:(httpSuccess)success failure:(httpFailure)failure;

- (void)getUserSuccess:(httpSuccess)success failure:(httpFailure)failure;


- (void)getStatusSuccess:(httpSuccess)success failure:(httpFailure)failure;


- (void)getTokenSuccess:(httpSuccess)success failure:(httpFailure)failure;

- (void)getNickNameSuccess:(httpSuccess)success failure:(httpFailure)failure;

- (void)getIconSuccess:(httpSuccess)success failure:(httpFailure)failure;


@end
