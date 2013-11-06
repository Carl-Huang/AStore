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
#import "Region.h"
#import "GetGiftInfo.h"
#import "GetOrderGoodInfo.h"
#import "GetOrderGiftInfo.h"
#import "ProductStoreInfo.h"
#import "GiftStoreInfo.h"
#import "DeliveryTypeInfo.h"
@implementation HttpHelper
+ (void) getAllCatalogWithSuccessBlock:(void (^)(NSDictionary * catInfo))success errorBlock:(void(^)(NSError * error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"youjian.php?getCategory=\""];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
        NSArray * totalResults = [NSArray arrayWithArray:responseObject];
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
                if ([[cat objectForKey:@"parent_id"] isEqualToString:@"69"]) {
                    NSLog(@"%@",[cat objectForKey:@"cat_name"]);
                }
                if([[cat objectForKey:@"parent_id"] intValue] == parentID)
                {
                    [childCats addObject:cat];
                }
            }
            [catalogInfo setObject:childCats forKey:parentCatName];
        }
        
        if(success)
        {
            NSDictionary * queryInfoDic = @{@"totalObj": totalResults,@"catalogInfo":catalogInfo};
//            success(catalogInfo);
            success(queryInfoDic);
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
        success((NSArray *)responseObject);
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
    NSLog(@"%@",urlString);
    [HttpHelper requestCommodityWithString:urlString successBlock:success errorBlock:failure];
}

//根据标签获取商品（聚优惠，跳蚤市场页面 如：餐饮）
+ (void)getCommodityWithSaleTab:(NSString *)tab withStart:(int)start withCount:(int)count   withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString * route = @"youjian.php";
    NSString * component_1 = [NSString stringWithFormat:@"tag_getSales=%@",tab];
    NSString * component_2 = [NSString stringWithFormat:@"start=%d",start];
    NSString * component_3 = [NSString stringWithFormat:@"count=%d",count];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@&%@&%@",SERVER_URL,route,component_1,component_2,component_3];
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
    //判断返回值
    NSArray * results = (NSArray *)responseObject;
    NSDictionary * dic = [results objectAtIndex:0];
    if ([dic count] == 1) {
        return  nil;
    }
    
    
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
//             NSLog(@"%@:%@",propertyName,[model valueForKeyPath:propertyName]);
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
         if ([resultInfo count]) {
             NSString * str = [[resultInfo objectAtIndex:0]objectForKey:RequestStatusKey];
              successBlock(str);
             if ([str isEqualToString:@"1"]) {
                 NSLog(@"注册成功");
                 //写入plish
                 [User deleteUserInfo];
                 [User saveUserInfo:name password:pwd memberId:@"0000"];
             }

         }
        

     } errorBlock:^(NSError * error)
     {
         failedBlock(error);
     }];

}

+(void)getRegionWithSuccessBlock:(void(^)(NSArray *array))successBlock failedBlock:(void(^)(NSError *error))failedBlock
{
    NSString * cmdStr = [NSString stringWithFormat:@"http://www.shyl8.net/youjian.php?getRegion=1"];
    [HttpHelper requestWithString:cmdStr withClass:[Region class] successBlock:^(NSArray *items) {
        successBlock(items);
    } errorBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

+(void)addNewAddress:(NSString *)memberId name:(NSString *)name area:(NSString *)areaStr addr:(NSString *)addrStr mobile:(NSString *)mobileStr tel:(NSString *)telStr withCompletedBlock:(void (^)(id item,NSError *error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"addAddrs=1&&mid=%@&&name=%@&&area=%@&&addr=%@&&mobile=%@&&tel=%@",memberId,name,areaStr,addrStr,mobileStr,telStr];
    NSLog(@"%s",__func__);
    NSLog(@"%@",cmdStr);
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
        block(resultInfo,nil);
    } errorBlock:^(NSError *error) {
        block(nil,error);
    }];
    
}

+(void)updateAddressId:(NSString *)addr_id name:(NSString *)name area:(NSString *)area addrs:(NSString *)addr mobile:(NSString *)mobile tel:(NSString *)tel withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"uptateAddrs=1&&addr_id=%@&&name=%@&&area=%@&&addr=%@&&mobile=%@&&tel=%@",addr_id,name,area,addr,mobile,tel];
    NSLog(@"%s",__func__);
    NSLog(@"%@",cmdStr);
    
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
        block(resultInfo,nil);
    } errorBlock:^(NSError *error) {
        block(nil,error);
    }];
}

+(void)deleteAddressWithAddressId:(NSString *)addId completedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"delAddrs=%@",addId];
    NSLog(@"%s",__func__);
    NSLog(@"%@",cmdStr);
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
        block(resultInfo,nil);
    } errorBlock:^(NSError *error) {
        block(nil,error);
    }];
}

+(void)getGiftStart:(NSInteger)start count:(NSInteger )count WithCompleteBlock:(void (^)(id, NSError *))block
{
    //获取赠品
    NSString * giftStr = [NSString stringWithFormat:@"getGift=1&&start=%@&&count=%@",[NSString stringWithFormat:@"%d",start],[NSString stringWithFormat:@"%d",count]];
    giftStr = [SERVER_URL_Prefix stringByAppendingString:giftStr];
    [HttpHelper requestWithString:giftStr withClass:[GetGiftInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];

}


+(void)getOrderWithMemberId:(NSString *)memberId withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSString * strCmd = [NSString stringWithFormat:@"getOrders=%@",memberId];
    strCmd = [SERVER_URL_Prefix stringByAppendingString:strCmd];
    [HttpHelper requestWithString:strCmd withClass:[GetOrderInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];
}
+(void)getOrderDetailWithOrderId:(NSString *)orderId withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSString * strCmd = [NSString stringWithFormat:@"getOrders_dtl_good=%@",orderId];
    strCmd = [SERVER_URL_Prefix stringByAppendingString:strCmd];
    [HttpHelper requestWithString:strCmd withClass:[GetOrderGoodInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];
}

+(void)getOrderDetailWithGiftId:(NSString *)orderId withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSString * strCmd = [NSString stringWithFormat:@"getOrders_dtl_gift=%@",orderId];
    strCmd = [SERVER_URL_Prefix stringByAppendingString:strCmd];
    [HttpHelper requestWithString:strCmd withClass:[GetOrderGiftInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];
}

+(void)getProductStoreWithProductId:(NSArray *)produceIds withCompletedBlock:(void (^)(id item,NSError * error))block
{
    /*
     product_id 数值，也可以传多个 用，分隔如（22,123）
     */
    NSString * productId = [[NSString alloc]init];
    for (int i =0 ;i<[produceIds count];i++) {
        NSString * str = [produceIds objectAtIndex:i];
        NSString * formatStr  = nil;
        if (i != 0 ) {
            formatStr = [NSString stringWithFormat:@",%@",str];
            productId = [productId stringByAppendingString:formatStr];
        }else
        {
            productId = str;
        }
    }
    NSString * strCmd = [NSString stringWithFormat:@"get_goods_Store=%@",productId];
    strCmd = [SERVER_URL_Prefix stringByAppendingString:strCmd];
    [HttpHelper requestWithString:strCmd withClass:[ProductStoreInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];
}

+(void)getGiftStoreWithGiftId:(NSArray *)giftIds withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSString * giftId = [[NSString alloc]init];
    for (int i =0 ;i<[giftIds count];i++) {
        NSString * str = [giftIds objectAtIndex:i];
        NSString * formatStr  = nil;
        if (i != 0 ) {
            formatStr = [NSString stringWithFormat:@",%@",str];
            giftId = [giftId stringByAppendingString:formatStr];
        }else
        {
            giftId = str;
        }
    }
    NSString * strCmd = [NSString stringWithFormat:@"get_gift_Store=%@",giftId];
    strCmd = [SERVER_URL_Prefix stringByAppendingString:strCmd];
    [HttpHelper requestWithString:strCmd withClass:[GiftStoreInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];
}

+(void)getDeliveryTypeWithCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSString * strCmd = [NSString stringWithFormat:@"dly_type=1"];
    strCmd = [SERVER_URL_Prefix stringByAppendingString:strCmd];
    [HttpHelper requestWithString:strCmd withClass:[DeliveryTypeInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];

}

+(void)getUserInfoWithUserName:(NSString *)name pwd:(NSString *)password completedBlock:(void (^)(id, NSError *))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"getUser=%@&&pwd=%@",name,password];
    cmdStr = [SERVER_URL_Prefix stringByAppendingString:cmdStr];
    NSLog(@"cmdStr :%@",cmdStr);
    [HttpHelper requestWithString:cmdStr withClass:[userInfo class] successBlock:^(NSArray *items) {
        block(items,nil);
    } errorBlock:^(NSError *error) {
        block (nil,error);
    }];

}

+(void)postOrderWithUserInfo:(NSArray *)userData
                deliveryType:(DeliveryTypeInfo *)deliveryType
                      Weight:(NSString *)weight
                  productNum:(NSString *)numStr
                     address:(AddressInfo *)addressInfo
           totalProuctMomeny:(NSString *)productMoney
                deliveryCost:(NSString *)deliveryCost
                    getPoint:(NSString *)point
                  totalMoney:(NSString *)money
                        memo:(NSString *)memo
          withCommodityArray:(NSArray *)commodityDic
          withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSDictionary *userInfo = [User getUserInfo];
    
    
    NSString * product_id_str   = [[NSString alloc]init];
    NSString * arr_bn_str       = [[NSString alloc]init];
    NSString * arr_name_str     = [[NSString alloc]init];
    NSString * arr_cost_str     = [[NSString alloc]init];
    NSString * arr_price_str    = [[NSString alloc]init];
    NSString * arr_amount_str   = [[NSString alloc]init];
    NSString * arr_nums_str     = [[NSString alloc]init];
    NSString * arr_score_str    = [[NSString alloc]init];
    
    NSString *tostr = @"";
    for (int i = 0;i< [commodityDic count]; i++) {
        NSDictionary * dic = [commodityDic objectAtIndex:i];
        //商品的数量
        NSInteger count =[[dic objectForKey:@"count"]integerValue];

        Commodity * commodityInfo = [dic objectForKey:@"commodity"];
        
        product_id_str = [product_id_str stringByAppendingString:commodityInfo.product_id];
        
        arr_bn_str = [arr_bn_str stringByAppendingString:commodityInfo.bn];
       
        arr_name_str = [arr_name_str stringByAppendingString:commodityInfo.name];
        
        arr_cost_str = [arr_cost_str stringByAppendingString:commodityInfo.cost];
        
        arr_price_str = [arr_price_str stringByAppendingString:commodityInfo.price];
        
        
        //数量
        NSString * countStr = [NSString stringWithFormat:@"%d",count];
        arr_nums_str = [arr_nums_str stringByAppendingString:countStr];
        
        tostr = [NSString stringWithFormat:@"%@(%@)",arr_name_str,countStr];
        //总积分
        NSInteger totalScore = count * commodityInfo.score.integerValue;
        NSString * scoreStr = [NSString stringWithFormat:@"%d",totalScore];
        arr_score_str = [arr_score_str stringByAppendingString:scoreStr];
        
        
        //总额
        NSInteger totalPrice = count * commodityInfo.price.integerValue;
        NSString * priceStr = [NSString stringWithFormat:@"%d",totalPrice];
        arr_amount_str = [arr_amount_str stringByAppendingString:priceStr];
        
        if (i != [commodityDic count]-1) {
            product_id_str  = [product_id_str stringByAppendingString:@","];
            arr_bn_str     = [arr_bn_str stringByAppendingString:@","];
            arr_name_str    = [arr_name_str stringByAppendingString:@","];
            arr_cost_str    = [arr_cost_str stringByAppendingString:@","];
            arr_price_str   = [arr_price_str stringByAppendingString:@","];
            arr_nums_str    = [arr_nums_str stringByAppendingString:@","];
            arr_score_str   = [arr_score_str stringByAppendingString:@","];
            arr_amount_str  = [arr_amount_str stringByAppendingString:@","];
            tostr = [tostr stringByAppendingString:@","];

        }
    }
    if (memo == nil) {
        memo =@"   ";
    }
    NSString * cmdStr1 = [NSString stringWithFormat:@"addOrders_1=1&&member_id=%@&&shipping=%@&&weight=%@&&tostr=%@&&itemnum=%@&&ship_name=%@&&ship_area=%@&&ship_addr=%@&&ship_time=%@&&ship_mobile=%@&&tel=%@&&cost_item=%@&&cost_freight=%@&&score_u=%@&&score_g=%@&&total_amount=%@&&memo=%@",
                          [userInfo objectForKey:DMemberId],
                          deliveryType.dt_name,
                          weight,
                          tostr,                //商品名称列表，多个商品用,分隔格式如下：
                          //商品1（规格）（数量）
                          //例如：
                          //女式洞洞鞋1165（三色可选）(蓝色、38)(1)
                          
                          numStr,               //商品总数量
                          addressInfo.name,
                          addressInfo.area,
                          addressInfo.addr,
                          @"任意时间段",
                          addressInfo.mobile,
                          addressInfo.tel,
                          productMoney,         //商品总额
                          deliveryCost,         //配送费用
                          @"0",                 //消耗积分：商品为0，赠品才需要
                          point,                //可得总积分=可得积分*数量
                          money,                //总金额
                          memo];                //备注
    
    NSString *cmdStr2 = [NSString stringWithFormat:@"&&arr_product_id=%@&&arr_bn=%@&&arr_name=%@&&arr_cost=%@&&arr_price=%@&&arr_amount=%@&&arr_nums=%@&&arr_score=%@",product_id_str,arr_bn_str,arr_name_str,arr_cost_str,arr_price_str,arr_amount_str,arr_nums_str,arr_score_str];
    
    
    NSString * postStr = [cmdStr1 stringByAppendingString:cmdStr2];
    NSLog(@"postStr: %@",postStr);
    
    [HttpHelper postRequestWithCmdStr:postStr SuccessBlock:^(NSArray *resultInfo) {
        block(resultInfo,nil);
    } errorBlock:^(NSError *error) {
         block(nil,error);
    }];
    
    
    product_id_str  = nil;
    arr_bn_str      = nil;
    arr_name_str    = nil;
    arr_nums_str    = nil;
    arr_cost_str    = nil;
    arr_price_str   = nil;
    arr_score_str   = nil;
}


+(void)postGiftOrderWithUserInfo:(NSArray *)userData
                deliveryType:(DeliveryTypeInfo *)deliveryType
                      Weight:(NSString *)weight
                       tostr:(NSString *)tostr
                  productNum:(NSString *)numStr
                     address:(AddressInfo *)addressInfo
           totalProuctMomeny:(NSString *)productMoney
                deliveryCost:(NSString *)deliveryCost
                    getPoint:(NSString *)point
                  totalMoney:(NSString *)money
                        memo:(NSString *)memo
          withCommodityArray:(NSArray *)commodityDic
          withCompletedBlock:(void (^)(id item,NSError * error))block
{
    NSDictionary *userInfo = [User getUserInfo];
    if (memo == nil) {
        memo =@"   ";
    }
    NSString * cmdStr1 = [NSString stringWithFormat:@"addOrders_2=1&&member_id=%@&&shipping=%@&&weight=%@&&tostr=%@&&itemnum=%@&&ship_name=%@&&ship_area=%@&&ship_addr=%@&&ship_time=%@&&ship_mobile=%@&&tel=%@&&ost_item=%@&&cost_freight=%@&&score_u=%@&&score_g=%@&&total_amount=%@&&memo=%@",
                          [userInfo objectForKey:DMemberId],
                          deliveryType.dt_name,
                          weight,
                          tostr,                //商品名称列表，多个商品用,分隔格式如下：
                          //商品1（规格）（数量）
                          //例如：
                          //女式洞洞鞋1165（三色可选）(蓝色、38)(1)
                          
                          numStr,               //商品总数量
                          addressInfo.name,
                          addressInfo.area,
                          addressInfo.addr,
                          @"任意时间段",
                          addressInfo.mobile,
                          addressInfo.tel,
                          @"0",                  //赠品总额,默认为0？
                          deliveryCost,         //配送费用
                          productMoney,         //hardcode 运费为2块
                          point,                //可得总积分=可得积分*数量
                          money,                 //总金额,默认为0？
                          memo];                //备注
    
    NSString * arr_gift_id   = [[NSString alloc]init];
    NSString * arr_name       = [[NSString alloc]init];
    NSString * arr_point     = [[NSString alloc]init];
    NSString * arr_nums     = [[NSString alloc]init];

    
    
    for (int i = 0;i< [commodityDic count]; i++) {
        NSDictionary * dic = [commodityDic objectAtIndex:i];
        //单一商品的数量
        NSInteger count =[[dic objectForKey:@"count"]integerValue];
        
        GetGiftInfo * giftInfo = [dic objectForKey:@"present"];
        
        arr_gift_id = [arr_gift_id stringByAppendingString:giftInfo.gift_id];
        
        arr_name = [arr_name stringByAppendingString:giftInfo.name];
    
        //数量
        NSString * countStr = [NSString stringWithFormat:@"%d",count];
        arr_nums = [arr_nums stringByAppendingString:countStr];

        //总积分
        NSInteger totalScore = count * giftInfo.point.integerValue;
        NSString * scoreStr = [NSString stringWithFormat:@"%d",totalScore];
        arr_point = [arr_point stringByAppendingString:scoreStr];
        
        if (i != [commodityDic count]-1) {
            arr_gift_id  = [arr_gift_id stringByAppendingString:@","];
            arr_name     = [arr_name stringByAppendingString:@","];
            arr_nums     = [arr_nums stringByAppendingString:@","];
            arr_point    = [arr_point stringByAppendingString:@","];

        }
    }
    
    NSString *cmdStr2 = [NSString stringWithFormat:@"&&arr_gift_id=%@&&arr_name=%@&&arr_nums=%@&&arr_point=%@",arr_gift_id,arr_name,arr_nums,arr_point];
    
    
    NSString * postStr = [cmdStr1 stringByAppendingString:cmdStr2];
    NSLog(@"postStr: %@",postStr);
    
    [HttpHelper postRequestWithCmdStr:postStr SuccessBlock:^(NSArray *resultInfo) {
        block(resultInfo,nil);
    } errorBlock:^(NSError *error) {
        block(nil,error);
    }];
    arr_gift_id     = nil;
    arr_name        = nil;
    arr_nums        = nil;
    arr_point       = nil;

}

+(void)setUserDefaultAddress:(NSString *)addressId memberId:(NSString *)memberId completedBlock:(void (^)(id responed,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"setAddrs=%@&&mid=%@",addressId,memberId];
//    cmdStr = [SERVER_URL_Prefix stringByAppendingString:cmdStr];
    NSLog(@"%@",cmdStr);
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
        block(resultInfo,nil);
    } errorBlock:^(NSError *error) {
        block(nil,error);
    }];

}


+ (void)getAdsWithURL:(NSString *)urlString withNodeClass:(NSString *)clsString withSuccessBlock:(void (^)(NSArray * items))success errorBlock:(void (^)(NSError * error))failure
{
    if(urlString == nil) return ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData * htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        if(!htmlData)
        {
            NSLog(@"The html content is nil");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(failure)
                {
                    NSError * error = [NSError errorWithDomain:@"The html content is nil." code:0 userInfo:nil];
                    failure(error);
                }
            });
            
            return ;
        }
        
        TFHpple * xParse = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSString * xpath = [NSString stringWithFormat:@"//div[@class=\"%@\"]/script",clsString];
        NSArray * elements = [xParse searchWithXPathQuery:xpath];
        
        if([elements count] == 0)
        {
            NSLog(@"Could not found the elements.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(failure)
                {
                    NSError * error = [NSError errorWithDomain:@"Could not found the elements." code:0 userInfo:nil];
                    failure(error);
                }
            });
            
            return ;
        }
        
        
        
        TFHppleElement * element = [elements objectAtIndex:0];
//        NSLog(@"%@",element.raw);
        NSArray * tmp = [element.raw componentsSeparatedByString:@"vars:"];
        NSString * content = [tmp objectAtIndex:1];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"]]>" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"</script>" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"});" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"{" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"}" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        tmp = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        NSString * imagesString = [[[tmp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"bcastr_flie:" withString:@""] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString * urlsString = [[[tmp objectAtIndex:1] stringByReplacingOccurrencesOfString:@"bcastr_link:" withString:@""] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSArray * images = [imagesString componentsSeparatedByString:@"|"];
        NSArray * urls = [urlsString componentsSeparatedByString:@"|"];
        
        if(images.count != urls.count)
        {
            NSLog(@"Something error.");
            return ;
        }
        
        NSMutableArray * items = [NSMutableArray arrayWithCapacity:images.count];
        
        for(int i = 0; i < images.count; i++)
        {
            if([[images objectAtIndex:i] length] == 0 || [[urls objectAtIndex:i] length] == 0)
            {
                continue;
            }
            NSDictionary * dic = [NSDictionary dictionaryWithObjects:@[[images objectAtIndex:i],[SERVER_URL stringByAppendingString:[urls objectAtIndex:i]]] forKeys:@[@"image",@"url"]];
            [items addObject:dic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success)
            {
                success(items);
            }
        });
        
    });
}

+(void)getSpecificUrlContentOfAdUrl:(NSString *)urlStr completedBlock:(void (^)(id item ,NSError *error))block
{
    
    if(urlStr == nil) return ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData * htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        
        if(!htmlData)
        {
            NSLog(@"The html content is nil");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                    NSError * error = [NSError errorWithDomain:@"The html content is nil." code:0 userInfo:nil];
                    block(nil,error);
            });
            
            return ;
        }
        
        TFHpple * xParse = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray * elements = [xParse searchWithXPathQuery:@"//div[@class=\"ArticleDetailsWrap\"]"];
        TFHppleElement * element = [elements objectAtIndex:0];

    
       
      
        if([elements count] == 0)
        {
            NSLog(@"Could not found the elements.");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError * error = [NSError errorWithDomain:@"Could not found the elements." code:0 userInfo:nil];
                block(nil,error);
            });
            
            return ;
        }
        
        //NSLog(@"%@",[element.children objectAtIndex:7]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
           block(element.raw,nil);
        });
     
        
    });
}

//根据标签获取商品（聚优惠，跳蚤市场页面 如：餐饮）
+ (void)getCommodityWithTab:(NSString *)tab withStart:(int)start withCount:(int)count   withSuccessBlock:(void (^)(NSArray * commoditys))success withErrorBlock:(void (^)(NSError * error))failure
{
    NSString * route = @"youjian.php";
    NSString * component_1 = [NSString stringWithFormat:@"cat_getSales=%@",tab];
    NSString * component_2 = [NSString stringWithFormat:@"start=%d",start];
    NSString * component_3 = [NSString stringWithFormat:@"count=%d",count];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@&%@&%@",SERVER_URL,route,component_1,component_2,component_3];
    [HttpHelper requestCommodityWithString:urlString successBlock:success errorBlock:failure];
}

+(void)getThumbnailImageWithGood_id:(NSString *)goodId completedBlock:(void (^)(id item,NSError * error))block
{
    NSString * cmdStr = [NSString stringWithFormat:@"getImage=%@",goodId];
    NSLog(@"cmdStr :%@",cmdStr);
    [HttpHelper getAllCatalogWithSuffix:cmdStr SuccessBlock:^(NSArray *catInfo) {
        NSLog(@"%@",catInfo);
        block(catInfo,nil);
    } errorBlock:^(NSError *error) {
        block(nil,error);
    }];
}

@end
