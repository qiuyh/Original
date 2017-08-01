//
//  CollectionCell.m
//  Original
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.notiView.hidden=YES;
//    self.notiTop.constant=-54;
    self.notiHeightConstraint.constant = 0;
    
    
}


- (IBAction)nito:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    if (_block)
    {
        _block(1,button);
    }
}

- (IBAction)del:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    if (_block)
    {
        _block(2,button);
    }

}

- (IBAction)cart:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    if (_block)
    {
        _block(3,button);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
