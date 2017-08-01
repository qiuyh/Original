//
//  LotType.h
//  Original
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotType : NSObject
@property (nonatomic,copy) NSString *lotType;//每组对应的类型
@property (nonatomic,strong) NSMutableArray *typeArray;//存储组
@end
