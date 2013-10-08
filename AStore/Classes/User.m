//
//  User.m
//  AStore
//
//  Created by vedon on 10/7/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
#define USER_NAME_MAX_LENGTH    16
#define USER_NAME_MIN_LENGTH    3
#define PWD_MAX_LENGTH          80
#define PWD_MIN_LENGTH          6

#import "User.h"
#import "RegularExpressions.h"
@implementation User

//验证用户名是否合法
+(error_tpye)isUserNamelegal:(NSString *)NameS{
    //是否全数字
    if ([RegularExpressions isAllNumCharacterInString:NameS]) {
        return ALL_NUM_ERROR;
    }
    //是否存在特殊字符
    if (![RegularExpressions isNoSpecialCharacterInString:NameS]) {
        return SPECIAL_WORD_ERROR;
    }
    //字符长度检查
    if (![RegularExpressions isLengthOfString:NameS inAreaMax:USER_NAME_MAX_LENGTH Min:USER_NAME_MIN_LENGTH]) {
        return LENGTH_ERROR;
    }
    
    return -1;
}

//检查密码长度
+(BOOL)isPwdlegal:(NSString *)pwd{
    
    return [RegularExpressions isLengthOfString:pwd inAreaMax:PWD_MAX_LENGTH Min:PWD_MIN_LENGTH];
}

+(BOOL)isPwdNoSpecialCharacterStr:(NSString *)pwd{
    if (![RegularExpressions isNoSpecialCharacterInString:pwd]) {
        return NO;
    }
    return YES;
}



@end
