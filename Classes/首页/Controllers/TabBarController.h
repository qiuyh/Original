//
//  TabBarController.h
//  Original
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController
@property (nonatomic,strong) UIImageView *myTabBar;//自定义的tabBar
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *butt;
@property (nonatomic,strong) UIButton *selButton;//记住前一个选中的按钮
@end
