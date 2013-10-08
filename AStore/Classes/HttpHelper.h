//
//  HttpHelper.h
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define SERVER_URL @"http://www.shyl8.net/"
#define SERVER_URL_Prefix @"http://www.shyl8.net/youjian.php?"
@interface HttpHelper : NSObject

//获得所有分类
+ (void) getAllCatalogWithSuccessBlock:(void (^)(NSDictionary * catInfo))success errorBlock:(void(^)(NSError * error))failure;

//获得热门推荐商品
+ (void)getHotCommodityWithCatalogTabID:(int)tab successBlock:(void (^)(NSArray * commoditys))success errorBlock:(void (^)(NSError * error))failure;
//根据分类id和标签获得商品
+ (void)getCommodityWithCatalogTabID:(int)tab withTagName:(NSString *)tagName withStart:(int)start withCount:(int)count withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure;
//根据标签获取商品（聚优惠，跳蚤市场页面 如：餐饮）
+ (void)getCommodityWithSaleTab:(NSString *)tab withStart:(int)start withCount:(int)count   withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure;
//获取兑换商品
+ (void)getGifCommodityWithSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure;

//搜索商品
+ (void)searchCommodityWithKeyworkd:(NSString *)keyword withStart:(int)start withCount:(int)count   withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure;

//获取公告列表
+ (void)getArticalListWithSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure;

+(void)postRequestWithCmdStr:(NSString *)cmd SuccessBlock:(void (^)(NSArray * resultInfo))success errorBlock:(void(^)(NSError * error))failure;


//将取得的内容转换为commodity模型
+ (NSArray *)mapCommodityProcess:(id)responseObject;
//将取得的内容转换为模型
+ (NSArray *)mapModelProcess:(id)responseObject withClass:(Class)class;
//根据url获取商品
+ (void)requestCommodityWithString:(NSString *)urlString successBlock:(void (^)(NSArray * commoditys))success errorBlock:(void (^)(NSError * error))failure;

+ (NSString *)escapeURLString:(NSString *)urlString;
@end
