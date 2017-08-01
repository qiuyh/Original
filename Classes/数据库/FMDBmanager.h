//
//  FMDBmanager.h
//  Original
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface FMDBmanager : NSObject

@property (nonatomic,strong)FMDatabase *basae;
+(instancetype)shareInstance;

@end
