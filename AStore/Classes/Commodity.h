//
//  Commodity.h
//  AStore
//
//  Created by Carl on 13-10-8.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : NSObject<NSCoding>
@property (nonatomic,retain) NSString * goods_id;
@property (nonatomic,retain) NSString * brief;
@property (nonatomic,retain) NSString * intro;
@property (nonatomic,retain) NSString * store;
@property (nonatomic,retain) NSString * spec;
@property (nonatomic,retain) NSString * pdt_des;
@property (nonatomic,retain) NSString * small_pic;
@property (nonatomic,retain) NSString * price;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * weight;
@property (nonatomic,retain) NSString * marketable;
@property (nonatomic,retain) NSString * unit;
@property (nonatomic,retain) NSString * score;
@property (nonatomic,retain) NSString * product_id;
@property (nonatomic,retain) NSString * cost;
@property (nonatomic,retain) NSString * bn;
@property (nonatomic,retain) NSString * count;
@property (nonatomic,retain) NSString * cat_id;
@property (nonatomic,retain) NSString * mktprice;
@property (nonatomic,retain) NSString * pdt_desc;
@property (nonatomic,retain) NSString * productType;
+(void)printCommodityInfo:(Commodity *)info;
+(void)archivingCommodityObj:(Commodity *)item;
+(Commodity *)unarchivingCommodityObj;

@end
