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
#import "constants.h"
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

//用户数据保存路径
+(NSString *)userInfoFilePath
{
    NSString * tempStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath = [tempStr stringByAppendingPathComponent:@"userInfo.plist"];
    return filePath;
}


+(BOOL)saveUserInfo:(NSString *)userName password:(NSString *)password memberId:(NSString *)memberId
{
//    NSString *filePath = [User userInfoFilePath];
//    NSString * err;
//    NSLog(@"保存用户信息路径：%@",filePath);
    NSDictionary *userInfoDic = @{DUserName: userName,DPassword:password,DMemberId:memberId};
    [[NSUserDefaults standardUserDefaults]setObject:userInfoDic forKey:VUserInfo];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    NSData *userData = [NSPropertyListSerialization dataFromPropertyList:userInfoDic format:NSPropertyListXMLFormat_v1_0 errorDescription:&err];
//    if(!err){
//        if ([userData writeToFile:filePath atomically:YES]) {
//            NSLog(@"write userInfo successfully");
//            return YES;
//        }else
//        {
//            NSLog(@"Failed to write userInfo  to local");
//            return NO; 
//        }
//        
//    }else{
//        NSLog(@"error with:%@", err);
//    }
    return NO;
}

+(NSDictionary *)getUserInfo
{
//    NSString *userInfoPath = [User userInfoFilePath];
//    NSData * userData = [NSData dataWithContentsOfFile:userInfoPath];
//    if (userData) {
//        NSPropertyListFormat format;
//        NSError * error = nil;
//        NSDictionary * userInfoDic = [NSPropertyListSerialization propertyListWithData:userData options:NSPropertyListMutableContainersAndLeaves  format:&format error:&error];
//        if (error == nil) {
//            NSLog(@"本地读取用户数据成功");
//            NSLog(@"%@",userInfoDic);
//            return userInfoDic;
//            
//        }else
//            NSLog(@"本地读取用户数据失败：%@",error.description);
//    }else
//    {
//        NSLog(@"用户数据不存在");
//    }
//    return [NSDictionary dictionary];
    NSDictionary * userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:VUserInfo];
    if (userInfoDic) {
        return userInfoDic;
    }
    return nil;
}

+(void)saveServerUserInfoTL:(NSDictionary *)userInfoDic
{
    NSLog(@"%s",__func__);
//    NSString * str1 = [userInfoDic objectForKey:DArea];
    NSString * str2 = [userInfoDic objectForKey:DEmail];
    NSString * str3 = [userInfoDic objectForKey:DLevelName];
    NSString * str4 = [userInfoDic objectForKey:DMemberId];
    NSString * str5 = [userInfoDic objectForKey:DLevelId];
//    NSString * str6 = [userInfoDic objectForKey:DMobile];
    NSString * str7 = [userInfoDic objectForKey:DPoint];
    NSString * str8 = [userInfoDic objectForKey:DUserName];

    NSDictionary * dic = @{DEmail:str2,DLevelName:str3,DMemberId:str4,DLevelId:str5,DPoint:str7,DUserName:str8};
    NSLog(@"%@",dic);
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:VServerUserInfo];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
+(NSDictionary *)getServerUserInfoFL
{
    NSLog(@"%s",__func__);
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:VServerUserInfo];
    NSLog(@"%@",dic);
    if (dic) {
        
        return dic;
    }else
    {
        return nil;
    }
}
@end
