//
//  UserStorage.m
//  Original
//
//  Created by iMacQIU on 16/1/30.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "UserStorage.h"

@implementation UserStorage


+(instancetype)shareInstance
{
    
    static UserStorage *manager=nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
         manager=[[UserStorage alloc]init];
    });
    

    return manager;
}


- (void)setCityName:(NSString *)CurrenCityName
{
    
    _cityName  = CurrenCityName;

}


@end
