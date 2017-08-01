//
//  ReviewsCell.h
//  Original
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starsWith;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UILabel *createTime;


@end
