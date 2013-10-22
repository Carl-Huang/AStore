//
//  userInfo.h
//  AStore
//
//  Created by vedon on 10/8/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfo : NSObject<NSCoding>
@property (nonatomic,strong)NSString * area;
@property (nonatomic,strong)NSString * lv_name;
@property (nonatomic,strong)NSString * member_id;
@property (nonatomic,strong)NSString * member_lv_id;
@property (nonatomic,strong)NSString * mobile;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * point;
@property (nonatomic,strong)NSString * uname;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * email;
+(void)archivingUserInfo:(userInfo * )userinfo;
+(userInfo *)unarchivingUserInfo;
+(void)removeUserInfo;
@end
