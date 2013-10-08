//
//  RegularExpressions.m
//  AStore
//
//  Created by vedon on 10/7/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "RegularExpressions.h"

@implementation RegularExpressions
#define SPECIAL_CHAR   @"[^[`~!@#$^&*()%=| {}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]]{0,}$"
#define ALL_NUM_REGYLAR    @"[0-9]{0,}$"


//计算字符串长度
+(NSUInteger) unicodeLengthOfString: (NSString *) textA {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < textA.length; i++) {
        
        
        unichar uc = [textA characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength ;
    
    
    return unicodeLength;
}

//检查是否全为字符串
+(BOOL)isAllNumCharacterInString:(NSString *)modeStr{
    NSString * regexNum = ALL_NUM_REGYLAR;//全数字
    NSPredicate * predNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexNum];
    BOOL res = [predNum evaluateWithObject:modeStr];
    
    return res;
}

//检查是否包含特殊字符
+(BOOL)isNoSpecialCharacterInString:(NSString *)modeStr{
    NSString * regexNum = SPECIAL_CHAR;//特殊字符
    NSPredicate * predNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexNum];
    BOOL res = [predNum evaluateWithObject:modeStr];
    
    return res;
}

//检查字符串长度
+(BOOL)isLengthOfString:(NSString*) modeStr inAreaMax:(NSInteger)maxL Min:(NSInteger)minL{
    NSInteger strLength = [RegularExpressions unicodeLengthOfString:modeStr];
    if (strLength<=maxL && strLength>=minL) {
        return YES;
    }
    return NO;
}


@end
