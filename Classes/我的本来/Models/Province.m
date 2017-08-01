//
//  Province.m
//  Original
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "Province.h"

@implementation Province
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cityArray=[[NSMutableArray alloc]init];
    }
    return self;
}
@end
