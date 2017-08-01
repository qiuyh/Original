//
//  QYHQiNiuRequestManarger.m
//  Original
//
//  Created by 邱永槐 on 16/4/23.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "QYHQiNiuRequestManarger.h"

#import "AFHTTPRequestOperationManager.h"
#import "QiniuSDK.h"
#import "QiniuPutPolicy.h"
#import "UIImage-Extensions.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+Valkidate.h"

/**
 *  注册七牛获取
 */
static NSString *QiniuAccessKey        = @"c2cCFhByfUAm1EWQIS_j8CFx2RZp1APuU8TG85VV";
static NSString *QiniuSecretKey        = @"iDhIvzXZSA7MplpFHnijlzQf6JBpjpCPVloZnaRx";
//static NSString *QiniuBucketName       = [NSString stringWithFormat:@"huaibucket:%@uploadfile.jpeg",@"e"];
static NSString *QiniuBaseURL          = @"7xt8p0.com2.z0.glb.qiniucdn.com";


@implementation QYHQiNiuRequestManarger


+ (instancetype)shareInstance
{
    static QYHQiNiuRequestManarger *manager=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[QYHQiNiuRequestManarger alloc]init];
    });
    
    return manager;
}

#pragma mark - QINIU Method
- (NSString *)tokenWithScope:(NSString *)scope
{
    QiniuPutPolicy *policy = [QiniuPutPolicy new];
    policy.scope = scope;
    return [policy makeToken:QiniuAccessKey secretKey:QiniuSecretKey];
    
}

- (void)updateFile:(NSString *)fileNmae withphotoNumber:(NSString *)photoNumber data:(NSData *)data Success:(qiNIuSuccess)success failure:(qiNIuFailure)failure
{
    
    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
    NSString *customerID = photoNumber ? photoNumber:[accountPassword objectForKey:@"account"];
    
    NSString *QiniuBucketName  = [NSString stringWithFormat:@"huaibucket:%@%@",customerID,fileNmae];
    NSString *qiNiukey         = [NSString stringWithFormat:@"%@%@",customerID,fileNmae];
    
    NSString *token = [self tokenWithScope:QiniuBucketName];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    
    
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                               progressHandler:^(NSString *key, float percent){
                                                   
                                               }
                                                        params:@{ @"x:foo":@"fooval" }
                                                  checkCrc:YES
                                        cancellationSignal:nil];


    [upManager putData:data key:qiNiukey token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (!info.error) {
        
                      NSString *contentURL = [NSString stringWithFormat:@"http://%@/%@?_=%@",QiniuBaseURL,key,timeString];
                      
                      NSLog(@"QN Upload Success URL= %@",contentURL);
                      
                      success(contentURL);
                }
              else {
                  
                  NSLog(@"%@",info.error);
                  
                  failure(info.error);
              }
          } option:opt];

}

- (void)getFile:(NSString *)fileNmae withphotoNumber:(NSString *)photoNumber Success:(qiNIuSuccess)success failure:(qiNIuFailure)failure
{
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger.requestSerializer =  [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    
    NSUserDefaults *accountPassword = [NSUserDefaults standardUserDefaults];
    NSString *customerID = photoNumber ? photoNumber: [accountPassword objectForKey:@"account"];
    
    NSString *urlString  = [NSString stringWithFormat:@"http://7xt8p0.com2.z0.glb.qiniucdn.com/%@%@?_=%@",customerID,fileNmae,timeString];
    
    [manger POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
          NSDictionary *dic = [NSDictionary dictionaryWithJsonString:string];
        
        NSLog(@"string==%@,dic==%@",string,dic);
        
        success(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error.userInfo);
        
        //失败走失败的回调
        failure(error);
    }];
    
}



@end
