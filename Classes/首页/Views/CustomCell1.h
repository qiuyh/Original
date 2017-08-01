//
//  CustomCell1.h
//  Original
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Delege <NSObject>

- (void)pushToControllerWithPage:(int)page AndItem:(NSString *)intem;

@end

@interface CustomCell1 : UITableViewCell

@property (nonatomic,weak) id<Delege>myDelege;



@end
