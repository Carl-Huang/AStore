//
//  RegularExpressions.h
//  AStore
//
//  Created by vedon on 10/7/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpressions : NSObject
//检查是否全为字符串
+(BOOL)isAllNumCharacterInString:(NSString *)modeStr;
//检查是否包含特殊字符
+(BOOL)isNoSpecialCharacterInString:(NSString *)modeStr;
//检查字符串长度
+(BOOL)isLengthOfString:(NSString*) modeStr inAreaMax:(NSInteger)maxL Min:(NSInteger)minL;

@end
