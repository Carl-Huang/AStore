//
//  HttpHelper.m
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper
+ (void *) getAllCatalogWithSuccessBlock:(void (^)(NSDictionary * catInfo))success errorBlock:(void(^)(NSError * error))failure
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"youjian.php?getCategory=\""];

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",NSStringFromSelector(_cmd));
        
        NSArray * results = (NSArray *)responseObject;
        //取得父节点
        NSMutableArray * parentsCat = [NSMutableArray array];
        for(NSDictionary * dic in results)
        {
            if([[dic objectForKey:@"parent_id"] intValue] == 0)
            {
                [parentsCat addObject:dic];
            }
        }
        
        if(parentsCat.count == 0)
        {
            NSLog(@"Could not found parent catalog.");
            NSError * error = [NSError errorWithDomain:@"Could not found parent catalog" code:100 userInfo:nil];
            if(failure)
            {
                failure(error);
            }
        }
        
        NSMutableDictionary * catalogInfo = [NSMutableDictionary dictionary];
        for(NSDictionary * dic in parentsCat)
        {
            int parentID = [[dic objectForKey:@"cat_id"] intValue];
            NSString * parentCatName = [dic objectForKey:@"cat_name"];
            NSMutableArray * childCats = [NSMutableArray array];
            for (NSDictionary * cat in results)
            {
                if([[cat objectForKey:@"parent_id"] intValue] == parentID)
                {
                    [childCats addObject:cat];
                }
            }
            [catalogInfo setObject:childCats forKey:parentCatName];
        }
        
        if(success)
        {
            success(catalogInfo);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
    
    return nil;
}

+ (NSString *) escapeURLString:(NSString *)urlString
{
    CFStringRef cfString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, (CFStringRef)@"!*'();@&+$,%#[]", kCFStringEncodingUTF8);
    return (__bridge NSString *)cfString;
}



@end
