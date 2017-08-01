//
//  NSDictionary+Valkidate.m
//  Original
//
//  Created by iMacQIU on 16/4/25.
//  Copyright © 2016年 qiuyognhuai. All rights reserved.
//

#import "NSDictionary+Valkidate.h"

@implementation NSDictionary (Valkidate)


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


@end
