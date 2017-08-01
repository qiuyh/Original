//
//  CartCell.h
//  Original
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *buyCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
