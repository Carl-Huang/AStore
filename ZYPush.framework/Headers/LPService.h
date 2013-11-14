//
//  LPService.h
//  LPPushSDK
//
//  Created by 文夕 on 13-3-6.
//  Copyright (c) 2013年 danchwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern NSString * const LPAPNetworkDidSetupNotification;          // 建立连接
extern NSString * const LPAPNetworkDidCloseNotification;          // 关闭连接
extern NSString * const LPAPNetworkDidRegisterNotification;       // 注册成功
extern NSString * const LPAPNetworkDidLoginNotification;          // 登录成功
extern NSString * const LPAPNetworkDidReceiveMessageNotification; // 收到消息(非APNS)
extern NSString * const LPAPNetworkDidVersionNotification;        // 版本监听
@interface LPService : NSObject
{

}
//required
+ (void)setupWithOption:(NSDictionary *)launchingOption;      // 初始化
+ (void)registerForRemoteNotificationTypes:(int)types;        // 注册APNS类型
+ (void)registerDeviceToken:(NSData *)deviceToken;            // 向服务器上报Device Token
//optional 
+ (void)setAlias:(NSString *)alias;                           //设置别名
+ (void)cancelAlias;                                          //取消别名
@end
