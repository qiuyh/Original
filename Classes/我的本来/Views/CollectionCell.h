//
//  CollectionCell.h
//  Original
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *notiView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notiTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notiHeightConstraint;

@property (nonatomic,copy)void (^block)(int n,UIButton *button);
@end
