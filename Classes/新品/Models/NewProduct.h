//
//  NewProduct.h
//  Original
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewProduct : NSObject
@property (nonatomic,copy) NSString *imageUrl;//图片
@property (nonatomic,copy) NSString *productName;//名称
@property (nonatomic,copy) NSString *productSysNo;//编号
@property (nonatomic,copy) NSString *price;//现在的价格
@property (nonatomic,copy) NSString *origPrice;//原来的价格

@end
