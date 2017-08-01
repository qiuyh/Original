//
//  ReviewsModel.h
//  Original
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewsModel : NSObject
@property (nonatomic,copy) NSString *starsCount;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *content;
@end
