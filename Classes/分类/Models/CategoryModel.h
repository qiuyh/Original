//
//  CategoryModel.h
//  Original
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property (nonatomic,copy) NSString *name;//名称
@property (nonatomic,copy) NSString *c1SysNo;//type=3对应的编号
@property (nonatomic,copy) NSString *imageUrl;//图片
@property (nonatomic,copy) NSString *url;//type=3 对应的信息(进入下一个页面用)
@property (nonatomic,copy) NSString *c1SysNoUrl;//type=2 对应的网址
@property (nonatomic,copy) NSString *type;//判断是哪种类型

@end
