//
//  GZHHttpTool.h
//
//  Created by apple on 16-4-5.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
@interface GZHHttpTool : NSObject
/**
 *  用GET方法发送请求
 *  @param url     发送地址
 *  @param params  发送的普通参数
 *  @param success 发送成功调用的方法
 *  @param failure 发送失败调用的方法
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  用post方法发送请求（不需要上传文件）
 *  @param url     发送地址
 *  @param params  发送的普通参数
 *  @param success 发送成功调用的方法
 *  @param failure 发送失败调用的方法
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  用post方法发送请求（需要上传文件）
 *
 *  @param url      发送地址
 *  @param params  发送的普通参数
 *  @param block   设置要上传的文件
 *  @param success 发送成功调用的方法
 *  @param failure 发送失败调用的方法
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id formData))block success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end

