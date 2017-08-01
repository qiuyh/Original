//
//  ProductListViewController.h
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController

@property (nonatomic,copy) NSString *name;//名称
@property (nonatomic,assign) int c1SysNo;//对应的编号
@property (nonatomic,assign) int sort;//分类
@property (nonatomic,copy) NSString *url;//对应的信息(进入下一个页面用)
@property (nonatomic,copy) NSString *type;//判断是哪种类型
@property (nonatomic,copy) NSString *c1SysNoUrl;//type=2 对应的网址
@property (nonatomic,assign) NSInteger originalHeight;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) BOOL isSearch;
@end
