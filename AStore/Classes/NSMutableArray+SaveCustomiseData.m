//
//  NSMutableArray+SaveCustomiseData.m
//  AStore
//
//  Created by vedon on 21/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "NSMutableArray+SaveCustomiseData.h"

@implementation NSMutableArray (SaveCustomiseData)

+(void)archivingObjArray:(NSArray * )array withKey:(NSString *)key
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSArray *)unarchivingObjArrayWithKey:(NSString *)key
{
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSArray * array = (NSArray * )[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (array) {
        return array;
    }
    return nil;
}
+(void)removeObjArrayWithkey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



@end
