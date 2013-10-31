//
//  GetOrderInfo.h
//  AStore
//
//  Created by vedon on 10/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetOrderInfo : NSObject

@property (strong ,nonatomic) NSString * order_id;      //订单id
@property (strong ,nonatomic) NSString * tostr;         //商品名称列表
@property (strong ,nonatomic) NSString * cost_item;     //总金额
@property (strong ,nonatomic) NSString * status;        //状态
@property (strong ,nonatomic) NSString * acttime;       //下单时间

@property (strong ,nonatomic) NSString * final_amount;
@property (strong ,nonatomic) NSString * cost_freight;
@property (strong ,nonatomic) NSString * score_g;
@property (strong ,nonatomic) NSString * score_u;
@property (strong ,nonatomic) NSString * shipping;
@end
