//
//  ImageDetailViewController.h
//  Original
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController
@property (nonatomic,copy) NSString *productSysNo;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,strong) void(^block)(BOOL isSel);
@property (nonatomic,assign) BOOL isReviewsSelected;

@property (nonatomic,copy) NSString *present;
@end
