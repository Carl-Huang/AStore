//
//  HttpHelper.m
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper
+ (NSDictionary *) getAllCatalog
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"?getCategory=\""];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.shyl8.net/youjian.php?cat_tab_getSales=15&&tag_name=7-8%E6%8A%98&&start=0&&count=10"]];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",json);
    return nil;
}

+ (NSString *) escapeURLString:(NSString *)urlString
{
    CFStringRef cfString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();@&+$,%#[]", kCFStringEncodingUTF8);
    return (__bridge NSString *)cfString;
}



@end
