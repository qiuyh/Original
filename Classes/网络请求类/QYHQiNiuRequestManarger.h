//
//  QYHQiNiuRequestManarger.h
//  Original
//
//  Created by 邱永槐 on 16/4/23.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>
//成功回调
typedef void (^qiNIuSuccess)(id responseObject);
//失败回调
typedef void (^qiNIuFailure)(NSError *error);

@interface QYHQiNiuRequestManarger : NSObject

+ (instancetype)shareInstance;

- (void)updateFile:(NSString *)fileNmae withphotoNumber:(NSString *)photoNumber data:(NSData *)data Success:(qiNIuSuccess)success failure:(qiNIuFailure)failure;

- (void)getFile:(NSString *)fileNmae withphotoNumber:(NSString *)photoNumber Success:(qiNIuSuccess)success failure:(qiNIuFailure)failure;

@end
