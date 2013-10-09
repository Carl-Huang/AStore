//
//  CouponInfo.h
//  AStore
//
//  Created by vedon on 10/9/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponInfo : NSObject
@property (strong ,nonatomic)NSString * memc_code;
@property (strong ,nonatomic)NSString * cpns_id;
@property (strong ,nonatomic)NSString * member_id;
@property (strong ,nonatomic)NSString * memc_enabled;
@property (strong ,nonatomic)NSString * cpns_name;
@property (strong ,nonatomic)NSString * pmt_id;
@property (strong ,nonatomic)NSString * pmt_time_begin;
@property (strong ,nonatomic)NSString * pmt_time_end;
@property (strong ,nonatomic)NSString * pmt_describe;

@end
