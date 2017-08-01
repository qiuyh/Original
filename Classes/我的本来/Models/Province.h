//
//  Province.h
//  Original
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
@property(nonatomic,copy) NSString *provinceName;//省名
@property (nonatomic,strong) NSMutableArray *cityArray;//装市模型
@end
