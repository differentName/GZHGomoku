//
//  GZHNewsModel.h
//  五子棋
//
//  Created by 高增洪 on 16/3/3.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZHNewsModel : NSObject
/**视频链接地址*/
@property (copy, nonatomic) NSString *content;
/**新闻标题*/
@property (copy, nonatomic) NSString *title;
@end
