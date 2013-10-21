//
//  NSMutableArray+SaveCustomiseData.h
//  AStore
//
//  Created by vedon on 21/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SaveCustomiseData)
+(void)archivingCommodityArray:(NSArray * )array withKey:(NSString *)key;
+(NSArray *)unarchivingCommodityArrayWithKey:(NSString *)key;
+(void)removeCommodityArrayWithkey:(NSString *)key;
@end
