//
//  GetGiftInfo.m
//  AStore
//
//  Created by vedon on 10/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "GetGiftInfo.h"

@implementation GetGiftInfo


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.gift_id = [aDecoder decodeObjectForKey:@"gift_id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        self.storage = [aDecoder decodeObjectForKey:@"storage"];
        self.small_pic = [aDecoder decodeObjectForKey:@"small_pic"];
        self.point = [aDecoder decodeObjectForKey:@"point"];
        self.limit_num = [aDecoder decodeObjectForKey:@"limit_num"];
        self.limit_start_time = [aDecoder decodeObjectForKey:@"limit_start_time"];
        self.limit_end_time = [aDecoder decodeObjectForKey:@"limit_end_time"];
        self.gift_describe = [aDecoder decodeObjectForKey:@"gift_describe"];
        self.intro = [aDecoder decodeObjectForKey:@"intro"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.gift_id forKey:@"gift_id"];
        [aCoder encodeObject:self.name forKey:@"name"];
        [aCoder encodeObject:self.weight forKey:@"weight"];
        [aCoder encodeObject:self.storage forKey:@"storage"];
        [aCoder encodeObject:self.small_pic forKey:@"small_pic"];
        [aCoder encodeObject:self.point forKey:@"point"];
        [aCoder encodeObject:self.limit_num forKey:@"limit_num"];
        [aCoder encodeObject:self.limit_end_time forKey:@"limit_end_time"];
        [aCoder encodeObject:self.limit_start_time forKey:@"limit_start_time"];
        [aCoder encodeObject:self.gift_describe forKey:@"gift_describe"];
        [aCoder encodeObject:self.intro forKey:@"intro"];

}
@end
