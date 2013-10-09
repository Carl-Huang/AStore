//
//  User.h
//  AStore
//
//  Created by vedon on 10/7/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
typedef enum _error_type{
    ALL_NUM_ERROR = 0,
    SPECIAL_WORD_ERROR,
    LENGTH_ERROR,
}error_tpye;
#import <Foundation/Foundation.h>

@interface User : NSObject
//验证用户名是否合法
+(error_tpye)isUserNamelegal:(NSString *)NameS;
//检查密码长度
+(BOOL)isPwdlegal:(NSString *)pwd;
+(BOOL)isPwdNoSpecialCharacterStr:(NSString *)pwd;
+(NSString *)userInfoFilePath;
+(BOOL)saveUserInfo:(NSString *)userName password:(NSString *)password memberId:(NSString *)memberId;
+(NSDictionary *)getUserInfo;
@end
