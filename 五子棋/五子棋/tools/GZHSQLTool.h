//
//  GZHSQLTool.h
//
//  Created by apple on 16/04/20.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//  工具类:用来处理咨询数据的缓存

#import <Foundation/Foundation.h>

@interface GZHSQLTool : NSObject
/**
 *  根据请求参数去沙盒中加载缓存的咨询数据
 *
 *  @param params 请求参数
 */
+ (NSArray *)newsWithParams:(NSDictionary *)params;

/**
 *  存储微博数据到沙盒中
 *
 *  @param statuses 需要存储的咨询数据
 */
+ (void)saveNews:(NSArray *)news;
@end
