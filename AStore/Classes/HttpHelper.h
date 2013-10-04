//
//  HttpHelper.h
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define SERVER_URL @"http://www.shyl8.net/youjian.php"
@interface HttpHelper : NSObject
+ (NSDictionary *) getAllCatalog;
+ (NSString *) escapeURLString:(NSString *)urlString;
@end
