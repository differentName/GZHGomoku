//
//  GZHWeatherModel.h
//  五子棋
//
//  Created by 高增洪 on 16/3/23.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZHWeatherModel : NSObject
/**天气*/
@property (copy, nonatomic) NSString *text;
/**风向及风力*/
@property (copy, nonatomic) NSString *wind;
/**周几*/
@property (copy, nonatomic) NSString *day;
/**最高温度*/
@property (copy, nonatomic) NSString *high;
/**日期*/
@property (copy, nonatomic) NSString *date;
/**天气代码*/
@property (copy, nonatomic) NSString *code1;
/**最低温度*/
@property (copy, nonatomic) NSString *low;
/**降水概率吧*/
@property (copy, nonatomic) NSString *cop;

@end
