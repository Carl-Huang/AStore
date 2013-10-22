//
//  userInfo.m
//  AStore
//
//  Created by vedon on 10/8/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "userInfo.h"

@implementation userInfo
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.member_id      = [aDecoder decodeObjectForKey:@"member_id"];
        self.lv_name        = [aDecoder decodeObjectForKey:@"lv_name"];
        self.member_lv_id   = [aDecoder decodeObjectForKey:@"member_lv_id"];
        self.name           = [aDecoder decodeObjectForKey:@"name"];
        self.uname          = [aDecoder decodeObjectForKey:@"uname"];
        self.point          = [aDecoder decodeObjectForKey:@"point"];
        self.area           = [aDecoder decodeObjectForKey:@"area"];
        self.title          = [aDecoder decodeObjectForKey:@"title"];
        self.email          = [aDecoder decodeObjectForKey:@"email"];
        self.mobile         = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.member_id forKey:@"member_id"];
    [aCoder encodeObject:self.lv_name forKey:@"lv_name"];
    [aCoder encodeObject:self.member_lv_id forKey:@"member_lv_id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.uname forKey:@"uname"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}

+(void)archivingUserInfo:(userInfo * )userinfo
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+(userInfo *)unarchivingUserInfo
{
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"userinfo"];
    userInfo * info = (userInfo * )[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (info) {
        return info;
    }
    return nil;
}
+(void)removeUserInfo
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
