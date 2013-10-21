//
//  GetGiftInfo.h
//  AStore
//
//  Created by vedon on 10/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetGiftInfo : NSObject<NSCoding>
@property (strong ,nonatomic) NSString * gift_id;           //赠品ID
@property (strong ,nonatomic) NSString * name;
@property (strong ,nonatomic) NSString * weight;
@property (strong ,nonatomic) NSString * storage;
@property (strong ,nonatomic) NSString * small_pic;         //图片路径
@property (strong ,nonatomic) NSString * point;             //赠品兑换所需积分
@property (strong ,nonatomic) NSString * limit_num;         //最大兑换数量
@property (strong ,nonatomic) NSString * gift_describe;
@property (strong ,nonatomic) NSString * intro;             //概要信息
@property (strong ,nonatomic) NSString * limit_start_time;  //开始时间
@property (strong ,nonatomic) NSString * limit_end_time;    //结束时间
@property (strong ,nonatomic) NSString * disabled;          //是否禁用

@end
