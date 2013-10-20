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
#import "constants.h"
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

+ (void *) getAllCatalogWithSuffix:(NSString * )suffixStr SuccessBlock:(void (^)(NSArray * catInfo))success errorBlock:(void(^)(NSError * error))failure;
+(void)postRequestWithCmdStr:(NSString *)cmd SuccessBlock:(void (^)(NSArray * resultInfo))success errorBlock:(void(^)(NSError * error))failure;


//将取得的内容转换为commodity模型
+ (NSArray *)mapCommodityProcess:(id)responseObject;
//将取得的内容转换为模型
+ (NSArray *)mapModelProcess:(id)responseObject withClass:(Class)class;
//根据url获取商品
+ (void)requestCommodityWithString:(NSString *)urlString successBlock:(void (^)(NSArray * commoditys))success errorBlock:(void (^)(NSError * error))failure;

+ (NSString *)escapeURLString:(NSString *)urlString;
+ (void)requestWithString:(NSString *)urlString withClass:(Class)class successBlock:(void (^)(NSArray * items))success errorBlock:(void (^)(NSError * error))failure;


//Added by vedon <<<<<<<<<<<<<<<<<<<
//提取图片的url
+(NSString *)extractImageURLWithStr:(NSString *)str;

//登陆
+(void)userLoginWithName:(NSString *)name pwd:(NSString *)pwd completedBlock:(void (^)(id items)) completedBlock failedBlock:(void (^) (NSError * error))faliedBlock;

//用户注册
+(void)userRegisterWithName:(NSString * )name pwd:(NSString *)pwd email:(NSString *)email completedBlock:(void (^)(id items))successBlock failedBlock:(void (^)(NSError * error))failedBlock;

//获取地区信息
+(void)getRegionWithSuccessBlock:(void(^)(NSArray * array))successBlock failedBlock:(void(^)(NSError *error))failedBlock;

//新增地址
+(void)addNewAddress:(NSString *)memberId name:(NSString *)name area:(NSString *)areaStr addr:(NSString *)addrStr mobile:(NSString *)mobileStr tel:(NSString *)telStr withCompletedBlock:(void (^)(id item,NSError *error))block;

//更新地址
+(void)updateAddressId:(NSString *)addr_id name:(NSString *)name area:(NSString *)area addrs:(NSString *)addr mobile:(NSString *)mobile tel:(NSString *)tel withCompletedBlock:(void (^)(id item,NSError * error))block;

//删除地址
+(void)deleteAddressWithAddressId:(NSString *)addId completedBlock:(void (^)(id item,NSError * error))block;

//获取赠品
+(void)getGiftWithCompleteBlock:(void (^)(id item,NSError * error))block;
//EndAdd:vedon >>>>>>>>>>>>>>>>>>>>
@end
