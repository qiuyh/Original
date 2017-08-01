//
//  FMDBmanager.m
//  Original
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "FMDBmanager.h"

@implementation FMDBmanager
+(instancetype)shareInstance
{
    FMDBmanager *manager=nil;
    @synchronized(self)
    {
        if (manager==nil)
        {
            manager=[[FMDBmanager alloc]init];
        }
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //初始化数据库
        NSString *filePath1 = [NSHomeDirectory() stringByAppendingString:@"/Documents/games.db"];
        
//                NSLog(@"filePath1==%@",filePath1);
        
        self.basae = [FMDatabase databaseWithPath:filePath1];
        
        if (![self.basae open])
        {
            NSLog(@"数据库打开失败");
        }
        //创建数据库1(搜索历史)
        if (![self.basae executeUpdate:@"create table if not exists SearchHistory(id integer primary key autoincrement,name text,cityNo text)"])
        {
            NSLog(@"创建表失败");
        }
        
        //创建数据库2(购物车)
        if (![self.basae executeUpdate:@"create table if not exists Cart(id integer primary key autoincrement,imageUrl text,price text,productName text,productSysNo text,num text,choose text)"])
        {
            NSLog(@"创建表失败");
        }

        //创建数据库3(收藏)
        if (![self.basae executeUpdate:@"create table if not exists Colection(id integer primary key autoincrement,imageUrl text,productName text,productSysNo text,price text)"])
        {
            NSLog(@"创建表失败");
        }

        
    }
    return self;
}

@end
