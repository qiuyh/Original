//
//  NewAddressViewController.h
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAddressViewController : UIViewController
@property (nonatomic,strong) void(^block)(NSArray *);//通过block反向传值到上一个界面
@property (nonatomic,strong) NSDictionary *editDic;//接收上一个页面传来的值

@property (nonatomic,strong) NSArray *allArray;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,assign) NSInteger index;

@end
