//
//  GroupCell.h
//  Original
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *GoodP;
@property (weak, nonatomic) IBOutlet UIButton *reviewsCount;
@property (weak, nonatomic) IBOutlet UILabel *veryGoodCount;

@property (weak, nonatomic) IBOutlet UILabel *goodCount;
@property (weak, nonatomic) IBOutlet UILabel *noGoodCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *veryGoodHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noGoodHeight;

@end
