//
//  Commodity.m
//  AStore
//
//  Created by Carl on 13-10-8.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "Commodity.h"
#import <objc/message.h>
@implementation Commodity
@synthesize pdt_des;
@synthesize cost;
@synthesize small_pic;
@synthesize price;
@synthesize product_id;
@synthesize score;
@synthesize name;
@synthesize unit;
@synthesize weight;
@synthesize marketable;
@synthesize goods_id;
@synthesize brief;
@synthesize intro;
@synthesize cat_id;
@synthesize store;
@synthesize count;
@synthesize spec;
@synthesize bn;
@synthesize mktprice;
@synthesize pdt_desc;

+(void)printCommodityInfo:(Commodity *)info
{
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([Commodity class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        const char* name = ivar_getName(var);
        NSString *valueKey = [NSString stringWithUTF8String:name];
        NSLog(@"%@:%@",valueKey,[info valueForKey:valueKey]);
    }
    free(vars);
}
@end
