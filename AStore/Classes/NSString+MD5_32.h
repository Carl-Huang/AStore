//
//  NSString+MD5_32.h
//  AStore
//
//  Created by vedon on 28/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5_32)
+(NSString *)md5:(NSString *)str;
+(NSString *)convertTimeToStr:(NSTimeInterval)time;
@end
