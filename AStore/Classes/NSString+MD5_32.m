//
//  NSString+MD5_32.m
//  AStore
//
//  Created by vedon on 28/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "NSString+MD5_32.h"
#import  <CommonCrypto/CommonDigest.h>
@implementation NSString (MD5_32)
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+(NSString *)convertTimeToStr:(NSTimeInterval)time
{
    //time 是毫秒级的数字
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSString *strTime = [dateFormatter stringFromDate:date];
    dateFormatter = nil;
    return strTime;
}
@end
