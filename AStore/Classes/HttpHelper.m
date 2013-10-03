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
    NSLog(@"%@",urlString);
    NSURL * url = [NSURL URLWithString:    [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:url] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@:%@",[request URL],JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
    
    return nil;
}
@end
