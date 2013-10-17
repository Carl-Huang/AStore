//
//  HttpHelper.m
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "HttpHelper.h"
#import <objc/message.h>
#import "Commodity.h"
#import "Artical.h"
#import "userInfo.h"
#import "AddressInfo.h"
#import "CouponInfo.h"
#import "CategoryInfo.h"
#import "GetOrderInfo.h"
#import "User.h"

@implementation HttpHelper
+ (void) getAllCatalogWithSuccessBlock:(void (^)(NSDictionary * catInfo))success errorBlock:(void(^)(NSError * error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"youjian.php?getCategory=\""];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
        
        NSArray * results = (NSArray *)responseObject;
        //取得父节点
        NSMutableArray * parentsCat = [NSMutableArray array];
        for(NSDictionary * dic in results)
        {
            if([[dic objectForKey:@"parent_id"] intValue] == 0)
            {
                [parentsCat addObject:dic];
            }
        }
        
        if(parentsCat.count == 0)
        {
            NSLog(@"Could not found parent catalog.");
            NSError * error = [NSError errorWithDomain:@"Could not found parent catalog" code:100 userInfo:nil];
            if(failure)
            {
                failure(error);
            }
        }
        
        NSMutableDictionary * catalogInfo = [NSMutableDictionary dictionary];
        for(NSDictionary * dic in parentsCat)
        {
            int parentID = [[dic objectForKey:@"cat_id"] intValue];
            NSString * parentCatName = [dic objectForKey:@"cat_name"];
            NSMutableArray * childCats = [NSMutableArray array];
            for (NSDictionary * cat in results)
            {
                if([[cat objectForKey:@"parent_id"] intValue] == parentID)
                {
                    [childCats addObject:cat];
                }
            }
            [catalogInfo setObject:childCats forKey:parentCatName];
        }
        
        if(success)
        {
            success(catalogInfo);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
    
}

+ (void *) getAllCatalogWithSuffix:(NSString * )suffixStr SuccessBlock:(void (^)(NSArray * catInfo))success errorBlock:(void(^)(NSError * error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL_Prefix,suffixStr];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
        
        NSArray * results = (NSArray *)responseObject;
        if (success) {
            success(results);
        }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
    
    return nil;
}

+(void)postRequestWithCmdStr:(NSString *)cmd SuccessBlock:(void (^)(NSArray * resultInfo))success errorBlock:(void(^)(NSError * error))failure
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL_Prefix,cmd];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlString);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * results = (NSArray *)responseObject;
        success(results);
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
        failure(error);
    }];
}


+ (NSString *) escapeURLString:(NSString *)urlString
{
    CFStringRef cfString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();@&+$,%#[]", kCFStringEncodingUTF8);
    return (__bridge NSString *)cfString;
}
//取得热门推荐商品
+ (void)getHotCommodityWithCatalogTabID:(int)tab successBlock:(void (^)(NSArray * commoditys))success errorBlock:(void (^)(NSError * error))failure
{
    [HttpHelper getCommodityWithCatalogTabID:tab withTagName:@"7-8折" withStart:0 withCount:5 withSuccessBlock:success withErrorBlock:failure];
}

//取得商品，根据cat_id & tagname
+ (void)getCommodityWithCatalogTabID:(int)tab withTagName:(NSString *)tagName withStart:(int)start withCount:(int)count withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString * route = @"youjian.php";
    NSString * component_1 = [NSString stringWithFormat:@"cat_tab_getSales=%d",tab];
    NSString * component_2 = [NSString stringWithFormat:@"tag_name=%@",tagName];
    NSString * component_3 = [NSString stringWithFormat:@"start=%d",start];
    NSString * compoment_4 = [NSString stringWithFormat:@"count=%d",count];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@&%@&%@&%@",SERVER_URL,route,component_1,component_2,component_3,compoment_4];

    [HttpHelper requestCommodityWithString:urlString successBlock:success errorBlock:failure];
}

//根据标签获取商品（聚优惠，跳蚤市场页面 如：餐饮）
+ (void)getCommodityWithSaleTab:(NSString *)tab withStart:(int)start withCount:(int)count   withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString * route = @"youjian.php";
    NSString * component_1 = [NSString stringWithFormat:@"cat_getSales=%@",tab];
    NSString * component_2 = [NSString stringWithFormat:@"start=%d",start];
    NSString * component_3 = [NSString stringWithFormat:@"count=%d",count];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@&&%@&&%@",SERVER_URL,route,component_1,component_2,component_3];
    [HttpHelper requestCommodityWithString:urlString successBlock:success errorBlock:failure];
}

//获取首页兑换商品
+ (void)getGifCommodityWithSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString * route = @"youjian.php";
    NSString * urlString = [NSString stringWithFormat:@"%@%@?getGift=\"&start=0&count=5",SERVER_URL,route];
    [HttpHelper requestCommodityWithString:urlString successBlock:success errorBlock:failure];
}

//搜索商品
+ (void)searchCommodityWithKeyworkd:(NSString *)keyword withStart:(int)start withCount:(int)count   withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString * route = @"youjian.php";
    NSString * component_1 = [NSString stringWithFormat:@"searchSales=%@",keyword];
    NSString * component_2 = [NSString stringWithFormat:@"start=%d",start];
    NSString * component_3 = [NSString stringWithFormat:@"count=%d",count];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@&%@&%@",SERVER_URL,route,component_1,component_2,component_3];
    [HttpHelper requestCommodityWithString:urlString successBlock:success errorBlock:failure];
}

//获取公告列表
+ (void)getArticalListWithSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"youjian.php?getArticle=\""];
    [HttpHelper requestWithString:urlString withClass:[Artical class] successBlock:success errorBlock:failure];
}


//根据url获取商品
+ (void)requestCommodityWithString:(NSString *)urlString successBlock:(void (^)(NSArray * commoditys))success errorBlock:(void (^)(NSError * error))failure
{
    NSLog(@"URL:%@",urlString);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@",responseObject);
        
        if(success)
        {
            success([HttpHelper mapModelProcess:responseObject withClass:[Commodity class]]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        if(failure)
        {
            failure(error);
        }
        
    }];
}


+ (void)requestWithString:(NSString *)urlString withClass:(Class)class successBlock:(void (^)(NSArray * items))success errorBlock:(void (^)(NSError * error))failure
{
    NSLog(@"URL:%@",urlString);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            success([HttpHelper mapModelProcess:responseObject withClass:class]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        if(failure)
        {
            failure(error);
        }
        
    }];
}


//将取得的内容转换为commodity模型
+ (NSArray *)mapCommodityProcess:(id)responseObject
{
    NSArray * results = (NSArray *)responseObject;
    Class commodityClass = [Commodity class];
    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList(commodityClass, &outCount);
    NSMutableArray * commoditys = [NSMutableArray arrayWithCapacity:results.count];
    for(NSDictionary * commodityInfo in results)
    {
        //取得Commodity类的属性
        Commodity * commodity = [[Commodity alloc] init];
        
        for(i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
//                NSLog(@"%@",propertyName);
//            NSLog(@"%@:%@",propertyName,[commodityInfo objectForKey:propertyName]);
            
            [commodity setValue:[commodityInfo objectForKey:propertyName] forKeyPath:propertyName];
//            NSLog(@"%@:%@",propertyName,[commodity valueForKeyPath:propertyName]);
        }
        [commoditys addObject:commodity];
    }
    
    return (NSArray *)commoditys;
}

//将取得的内容转换为模型
+ (NSArray *)mapModelProcess:(id)responseObject withClass:(Class)class
{
    NSArray * results = (NSArray *)responseObject;
    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList(class, &outCount);
    NSMutableArray * models = [NSMutableArray arrayWithCapacity:results.count];
    for(NSDictionary * info in results)
    {
        id model = [[class alloc] init];
        for(i = 0; i < outCount; i++)
        {
            objc_property_t property = properties[i];
            NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
            [model setValue:[info objectForKey:propertyName] forKeyPath:propertyName];
             NSLog(@"%@:%@",propertyName,[model valueForKeyPath:propertyName]);
        }
        [models addObject:model];
    }
    return (NSArray *)models;
}

+(NSString *)extractImageURLWithStr:(NSString *)str
{
    NSString * tempStr = [NSString stringWithFormat:@"%@",str];
    NSRange range = [tempStr rangeOfString:@"|" options:NSCaseInsensitiveSearch];
    NSRange strRange = NSMakeRange(0, range.location);
    return [Resource_URL_Prefix stringByAppendingString:[str substringWithRange:strRange]];
}

+(void)userLoginWithName:(NSString *)name pwd:(NSString *)pwd completedBlock:(void (^)(id items)) completedBlock failedBlock:(void (^) (NSError * error))faliedBlock
{
    NSString * cmdStr = [NSString stringWithFormat:@"getUser=%@&&pwd=%@",name,pwd];
    NSLog(@"cmdStr :%@",cmdStr);
    [HttpHelper getAllCatalogWithSuffix:cmdStr SuccessBlock:^(NSArray *catInfo) {
        completedBlock(catInfo);
    } errorBlock:^(NSError *error) {
        faliedBlock(error);
    }];

}

+(void)userRegisterWithName:(NSString * )name pwd:(NSString *)pwd email:(NSString *)email completedBlock:(void (^)(id items))successBlock failedBlock:(void (^)(NSError * error))failedBlock
{
    NSString *cmdStr = [NSString stringWithFormat:@"addUser=adduser&&name=%@&&pwd=%@&&email=%@",name,pwd,email];
    NSLog(@"CmdStr : %@",cmdStr);
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray * resultInfo)
     {
         NSString * str = [[resultInfo objectAtIndex:0]objectForKey:RequestStatusKey];
         successBlock(str);

         if ([str isEqualToString:@"1"]) {
             NSLog(@"注册成功");
             //写入plish
             [User deleteUserInfo];
             [User saveUserInfo:name password:pwd memberId:@"0000"];
         }
     } errorBlock:^(NSError * error)
     {
         failedBlock(error);
     }];

}
@end
