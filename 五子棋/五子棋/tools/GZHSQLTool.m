//
//  GZHSQLTool.h
//
//  Created by apple on 16/04/20.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//  工具类:用来处理咨询数据的缓存

#import "GZHSQLTool.h"
#import "FMDB.h"

@implementation GZHSQLTool

static FMDatabase *_db;
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"news.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_news (id integer PRIMARY KEY, news blob NOT NULL, idstr text NOT NULL UNIQUE);"];
}

+ (NSArray *)newsWithParams:(NSDictionary *)params
{
    // 根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
    if (params[@"since_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_news WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;", params[@"since_id"]];
    } else if (params[@"max_id"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_news WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;", params[@"max_id"]];
    } else {
        sql = @"SELECT * FROM t_news ORDER BY idstr DESC LIMIT 20;";
    }
    // 执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *news = [NSMutableArray array];
    while (set.next) {
        NSData *newData = [set objectForColumnName:@"news"];
        NSDictionary *new = [NSKeyedUnarchiver unarchiveObjectWithData:newData];
        [news addObject:new];
    }
    return news;
}

+ (void)saveNews:(NSArray *)news
{
    NSLog(@"%@",news);
    // 要将一个对象存进数据库的blob字段,最好先转为NSData
    // 一个对象要遵守NSCoding协议,实现协议中相应的方法,才能转成NSData
    for (NSDictionary *new in news) {
        NSLog(@"%@",new);
        // NSDictionary --> NSData
        NSData *newsData = [NSKeyedArchiver archivedDataWithRootObject:new];
        [_db executeUpdateWithFormat:@"INSERT INTO t_news(news, idstr) VALUES (%@, %@);", newsData, new[@"id"]];
    }
}
@end
