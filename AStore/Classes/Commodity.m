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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.goods_id   = [aDecoder decodeObjectForKey:@"goods_id"];
        self.pdt_des    = [aDecoder decodeObjectForKey:@"pdt_des"];
        self.cost       = [aDecoder decodeObjectForKey:@"cost"];
        self.small_pic  = [aDecoder decodeObjectForKey:@"small_pic"];
        self.price      = [aDecoder decodeObjectForKey:@"price"];
        self.product_id = [aDecoder decodeObjectForKey:@"product_id"];
        self.score      = [aDecoder decodeObjectForKey:@"score"];
        self.name       = [aDecoder decodeObjectForKey:@"name"];
        self.unit       = [aDecoder decodeObjectForKey:@"unit"];
        self.weight     = [aDecoder decodeObjectForKey:@"weight"];
        self.marketable = [aDecoder decodeObjectForKey:@"marketable"];
        self.brief      = [aDecoder decodeObjectForKey:@"brief"];
        self.intro      = [aDecoder decodeObjectForKey:@"intro"];
        self.cat_id     = [aDecoder decodeObjectForKey:@"cat_id"];
        self.store      = [aDecoder decodeObjectForKey:@"store"];
        self.count      = [aDecoder decodeObjectForKey:@"count"];
        self.spec       = [aDecoder decodeObjectForKey:@"spec"];
        self.bn         = [aDecoder decodeObjectForKey:@"bn"];
        self.mktprice   = [aDecoder decodeObjectForKey:@"mktprice"];
        self.pdt_desc   = [aDecoder decodeObjectForKey:@"pdt_desc"];
    }
    return  self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.goods_id  forKey:@"goods_id"];
    [aCoder encodeObject:self.pdt_des   forKey:@"pdt_des"];
    [aCoder encodeObject:self.cost      forKey:@"cost"];
    [aCoder encodeObject:self.small_pic forKey:@"small_pic"];
    [aCoder encodeObject:self.price     forKey:@"price"];
    [aCoder encodeObject:self.product_id forKey:@"product_id"];
    [aCoder encodeObject:self.score     forKey:@"score"];
    [aCoder encodeObject:self.name      forKey:@"name"];
    [aCoder encodeObject:self.unit      forKey:@"unit"];
    [aCoder encodeObject:self.weight    forKey:@"weight"];
    [aCoder encodeObject:self.marketable forKey:@"marketable"];
    [aCoder encodeObject:self.brief     forKey:@"brief"];
    [aCoder encodeObject:self.intro     forKey:@"intro"];
    [aCoder encodeObject:self.cat_id    forKey:@"cat_id"];
    [aCoder encodeObject:self.store     forKey:@"store"];
    [aCoder encodeObject:self.count     forKey:@"count"];
    [aCoder encodeObject:self.spec      forKey:@"spec"];
    [aCoder encodeObject:self.bn        forKey:@"bn"];
    [aCoder encodeObject:self.mktprice  forKey:@"mktprice"];
    [aCoder encodeObject:self.pdt_desc  forKey:@"pdt_desc"];
}

+(void)archivingCommodityObj:(Commodity *)item
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:item];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"Commodity"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(Commodity *)unarchivingCommodityObj
{
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"Commodity"];
    Commodity * item = (Commodity *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return  item;
}
@end
