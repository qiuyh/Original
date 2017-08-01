//
//  HttpreQuestManager.m
//  Original
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "HttpreQuestManager.h"
#import "NetInterface.h"
#import "AFNetworking.h"
#import"UserStorage.h"

@implementation HttpreQuestManager

+ (instancetype)shareInstance
{
    static HttpreQuestManager *manager=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[HttpreQuestManager alloc]init];
    });
    
    return manager;
}

- (void)GetAPPHomePage:(int)lotType success:(httpSuccess)success failure:(httpFailure)failure
{
    NSString *url=[NSString stringWithFormat:HOME_PAGE,246,lotType];
    
    [[AFHTTPRequestOperationManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        //失败走失败的回调
        failure(error);
    }];
}

- (void)getCategorySuccess:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:CATEGORY_PRODUCTS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getNewProductPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:NEW_PRODUCTS,page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

//productModel
//couponMsg ,imageUrls,price,priceName,productName,productSysNo,promotionWord,tipContent

- (void)getProductDetailWithproductSysNo:(int)sysNo success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:PRODUCTS_DETAIL,sysNo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getProductReviewsNewproductSysNo:(int)productSysNo withPage:(int)page withType:(int)type success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:PRODUCTS_REVIEW_NEW,productSysNo,page,type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getSubjectWithproductSysNo:(int)sysNo Page:(int)page success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:SUBJECT,sysNo,page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}
- (void)getHotProductsPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:HOT_PRODUCTS,page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getProductListSort:(int)sort c1SysNo:(int)c1SysNo c2SysNo:(int)c2SysNo withPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:PRODUCTS_LIST,sort,c1SysNo,c2SysNo,page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getProductAllListSort:(int)sort c1SysNo:(int)c1SysNo withPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:[NSString stringWithFormat:PRODUCTS_ALLLIST,sort,c1SysNo,page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getProductWithUrl:(NSString *)url success:(httpSuccess)success failure:(httpFailure)failure
{
    
    [[AFHTTPRequestOperationManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getSiteListSuccess:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:SITE_LIST parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];
    

}


- (void)getRecommendSearchKeySuccess:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:RECOMMEND_SEARCH_KEY parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getSearchKeySuccess:(httpSuccess)success failure:(httpFailure)failure
{
    [[AFHTTPRequestOperationManager manager]GET:SEARCH_KEY parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getHelpSuccess:(httpSuccess)success failure:(httpFailure)failure
{
    
    [[AFHTTPRequestOperationManager manager]GET:HELP parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                NSLog(@"responseObject==%@",responseObject);
        success(responseObject[@"data"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败走失败的回调
        failure(error);
    }];

}


- (void)getHelpWithFileNAme:(NSString *)fileName success:(httpSuccess)success failure:(httpFailure)failure
{
    //&name=Appfile&filename=%@  uploadfile.jpeg
    [[AFHTTPRequestOperationManager manager]POST:UPLOADFILE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSURL *fileUrl = [NSURL URLWithString:fileName];
        
//         NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Snip20150123_3.jpeg" withExtension:nil];
        
        [formData appendPartWithFileURL:fileUrl name:@"Appfile" fileName:@"uploadfile.jpeg" mimeType:@"image/jpeg" error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
    
     
}

-(void)loginWithCustomerID:(NSString *)customerID md5Pwd:(NSString *)md5Pwd success:(httpSuccess)success failure:(httpFailure)failure
{
    //&md5Pwd=%@&customerID=%@
    //http://www.benlai.com/IAccount/Login?customerID=13763067912&md5Pwd=21218cca77804d2ba1922c33e0151105&LoginType=2&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=284c1064bf7f9f5b6322dbf3e932fe1b
    //http://www.benlai.com/IAccount/Login?customerID=13763067912&md5Pwd=21218cca77804d2ba1922c33e0151105&LoginType=2&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=284c1064bf7f9f5b6322dbf3e932fe1b
    //http://www.benlai.com/IAccount/Login?customerID=13763067912&md5Pwd=670b14728ad9902aecba32e22fa4f6bd&LoginType=2&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=50814746efe16c51fffad555e50553e2
    
    NSDictionary *parameters = @{@"mobile":customerID,@"password":md5Pwd};
    
//    NSString *url = [NSString stringWithFormat:LOGIN,customerID,md5Pwd] ;
//    NSLog(@"url == %@",url);
    
    [[AFHTTPRequestOperationManager manager]POST:LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

    
//    [[AFHTTPRequestOperationManager manager]GET:LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"responseObject==%@",responseObject);
//        success(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"error==%@",error);
//        
//        //失败走失败的回调
//        failure(error);
//    }];

}

-(void)loginWithCustomerID1:(NSString *)customerID md5Pwd1:(NSString *)md5Pwd success:(httpSuccess)success failure:(httpFailure)failure
{
    //&md5Pwd=%@&customerID=%@
    //http://www.benlai.com/IAccount/Login?customerID=13763067912&md5Pwd=21218cca77804d2ba1922c33e0151105&LoginType=2&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=284c1064bf7f9f5b6322dbf3e932fe1b
    //http://www.benlai.com/IAccount/Login?customerID=13763067912&md5Pwd=21218cca77804d2ba1922c33e0151105&LoginType=2&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=284c1064bf7f9f5b6322dbf3e932fe1b
    //http://www.benlai.com/IAccount/Login?customerID=13763067912&md5Pwd=670b14728ad9902aecba32e22fa4f6bd&LoginType=2&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=50814746efe16c51fffad555e50553e2
    
//    NSDictionary *parameters = @{@"mobile":customerID,@"password":md5Pwd};
    
//        NSString *url = [NSString stringWithFormat:LOGIN1,customerID,md5Pwd] ;
    //    NSLog(@"url == %@",url);
    
    [[AFHTTPRequestOperationManager manager]GET:LOGIN1 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];
    
    
    //    [[AFHTTPRequestOperationManager manager]GET:LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        NSLog(@"responseObject==%@",responseObject);
    //        success(responseObject);
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //        NSLog(@"error==%@",error);
    //
    //        //失败走失败的回调
    //        failure(error);
    //    }];
    
}

- (void)logoutSuccess:(httpSuccess)success failure:(httpFailure)failure
{
    
    NSDictionary *parameters = @{@"token":[UserStorage shareInstance].token};
    
    [[AFHTTPRequestOperationManager manager]GET:LOGOUT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}


-(void)getIUserHomeSuccess:(httpSuccess)success failure:(httpFailure)failure
{

    [[AFHTTPRequestOperationManager manager]GET:IUSERHOME parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];
}

- (void)getUserSuccess:(httpSuccess)success failure:(httpFailure)failure
{

    NSDictionary *parameters = @{@"token":[ NSString stringWithFormat:@"%@", [UserStorage shareInstance].token]};

    
    [[AFHTTPRequestOperationManager manager]GET:GETUSER parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getStatusSuccess:(httpSuccess)success failure:(httpFailure)failure
{

    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];

    NSDictionary *parameters = @{@"mobile":[accountPassword objectForKey:@"account"]};
    
    
    [[AFHTTPRequestOperationManager manager]GET:GETSTATUS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject登录状态==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];
    

}


- (void)getTokenSuccess:(httpSuccess)success failure:(httpFailure)failure
{


    NSDictionary *parameters = @{@"token":[ NSString stringWithFormat:@"%@", [UserStorage shareInstance].token]};
    
    
    [[AFHTTPRequestOperationManager manager]GET:GETSTSTOKEN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}



-(void)editNickNameWithNickName:(NSString *)nickName CustomerID:(NSString *)customerID success:(httpSuccess)success failure:(httpFailure)failure
{
//    {"name":"huai2"}
//    NSString *url = [NSString stringWithFormat:EDITNICKNAME,nickName,customerID];
 
    
    NSDictionary *parameters = @{@"name":@"name",@"token":[NSString stringWithFormat:@"%@", [UserStorage shareInstance].token]};
    
        NSLog(@"parameters==%@",parameters);
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];

    manger.requestSerializer =  [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    
    [manger POST:@"http://7xt8p0.com2.z0.glb.qiniucdn.com/nickName17.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        
        NSLog(@"string==%@,responseObject==%@",string,responseObject);
//        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];
    
}

- (void)getNickNameSuccess:(httpSuccess)success failure:(httpFailure)failure
{

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger.requestSerializer =  [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
    NSString *customerID = [accountPassword objectForKey:@"account"];

    NSString *urlString  = [NSString stringWithFormat:@"http://7xt8p0.com2.z0.glb.qiniucdn.com/%@nickName.json",customerID];
    
    [manger POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"string==%@,responseObject==%@",string,responseObject);
                success(string);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}

- (void)getIconSuccess:(httpSuccess)success failure:(httpFailure)failure
{
    
}


-(void)getSNSCodeWithCellphone:(NSString *)cellphone success:(httpSuccess)success failure:(httpFailure)failure
{
    
//    NSString *url = [NSString stringWithFormat:GETSMSCODE,cellphone];
    
    NSDictionary *parameters = @{@"mobile":cellphone};
    
    [[AFHTTPRequestOperationManager manager]POST:GETAUTHCODE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 1)
        {

        [[AFHTTPRequestOperationManager manager]POST:GETAUTHCODE1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseObject==%@",responseObject);
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error==%@",error);
            
            //失败走失败的回调
            failure(error);
        }];
            
        }else
        {
            success(responseObject);
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}

-(void)nextSNSCodeWithCellphone:(NSString *)cellphone code:(NSString *)code  password:(NSString *)password name:(NSString *)name success:(httpSuccess)success failure:(httpFailure)failure
{

//    {"mobile":"13763067912","authCode":"9138","password":"888888","name":"huai"}
    
//    NSString *url = [NSString stringWithFormat:VALSMSCODE,cellphone,code];
    
    NSDictionary *parameters = @{@"mobile":cellphone,@"authCode":code,@"password":password,@"name":name};
    
    [[AFHTTPRequestOperationManager manager]POST:VALSMSCODE1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}

-(void)regiserSNSCodeWithCellphone:(NSString *)cellphone psw:(NSString *)psw success:(httpSuccess)success failure:(httpFailure)failure
{

    NSString *url = [NSString stringWithFormat:REGISER,cellphone,psw];
    
    
    [[AFHTTPRequestOperationManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
        //失败走失败的回调
        failure(error);
    }];

}

@end
