//
//  ProductDetail.h
//  Original
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetail : NSObject
@property (nonatomic,copy) NSString *productModel;
@property (nonatomic,copy) NSString *couponMsg;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *priceName;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *productSysNo;
@property (nonatomic,copy) NSString *promotionWord;
@property (nonatomic,copy) NSString *tipContent;


@property (nonatomic,strong) NSMutableArray *imagesArray;

@end


//productModel
//couponMsg ,imageUrls,price,priceName,productName,productSysNo,promotionWord,tipContent