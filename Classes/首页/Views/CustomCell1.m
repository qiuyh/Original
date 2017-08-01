//
//  CustomCell1.m
//  Original
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "CustomCell1.h"
#import "MainViewController.h"

@implementation CustomCell1

- (void)awakeFromNib {
    // Initialization code

}
- (IBAction)hotSales:(id)sender {
    
    [self.myDelege pushToControllerWithPage:1 AndItem:[(UIButton *)sender currentTitle]];
}
- (IBAction)phone:(id)sender {
    [self.myDelege pushToControllerWithPage:2 AndItem:[(UIButton *)sender currentTitle]];
}
- (IBAction)gift:(id)sender {
    [self.myDelege pushToControllerWithPage:3 AndItem:[(UIButton *)sender currentTitle]];
}
- (IBAction)oder:(id)sender {
    [self.myDelege pushToControllerWithPage:4 AndItem:[(UIButton *)sender currentTitle]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
