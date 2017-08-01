//
//  NewViewController.h
//  Original
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Delege <NSObject>

- (void)buttonSelect;

@end

@interface NewViewController : UIViewController

@property (nonatomic,weak) id<Delege>myDelege;

@end
