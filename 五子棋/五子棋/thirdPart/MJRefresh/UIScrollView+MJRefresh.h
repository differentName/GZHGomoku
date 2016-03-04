//
//  UIScrollView+MJRefresh.h
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MJRefresh)
#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback;

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 *  @param dateKey 刷新时间保存的key值
 */
- (void)addHeaderWithCallback:(void (^)())callback dateKey:(NSString*)dateKey;

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 *  @param dateKey 刷新时间保存的key值
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action dateKey:(NSString*)dateKey;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing;

/**
 *  下拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isHeaderHidden) BOOL headerHidden;

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeaderRefreshing) BOOL headerRefreshing;

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback;

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action;

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing;

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)footerEndRefreshing;

/**
 *  上拉刷新头部控件的可见性
 */
@property (nonatomic, assign, getter = isFooterHidden) BOOL footerHidden;

/**
 *  是否正在上拉刷新
 */
@property (nonatomic, assign, readonly, getter = isFooterRefreshing) BOOL footerRefreshing;

/**
 *  设置尾部控件的文字
 */
/** *  设置下拉刷新过程中还未达到刷新位置时显示的尾部控件文字*/
@property (copy, nonatomic) NSString *footerPullToRefreshText; // 默认:@"上拉可以加载更多数据"
/***  设置下拉刷新过程中已达到刷新位置时显示的尾部控件文字*/
@property (copy, nonatomic) NSString *footerReleaseToRefreshText; // 默认:@"松开立即加载更多数据"
/*** 设置下拉刷新过程中 正在请求刷新过程时的尾部控件文字*/
@property (copy, nonatomic) NSString *footerRefreshingText; // 默认:@"正在加载数据..."



/**
 *  设置头部控件的文字
 */

/** *  设置下拉刷新过程中还未达到刷新位置时显示的头部控件文字*/
@property (copy, nonatomic) NSString *headerPullToRefreshText; // 默认:@"下拉可以刷新"
/***  设置下拉刷新过程中已达到刷新位置时显示的头部控件文字*/
@property (copy, nonatomic) NSString *headerReleaseToRefreshText; // 默认:@"松开立即刷新"
/*** 设置下拉刷新过程中 正在请求刷新过程时的头部控件文字*/
@property (copy, nonatomic) NSString *headerRefreshingText; // 默认:@"正在刷新..."
@end
