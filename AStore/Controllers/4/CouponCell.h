//
//  CouponCell.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *couponName;

@property (weak, nonatomic) IBOutlet UILabel *validityTime;
@property (weak, nonatomic) IBOutlet UILabel *userMethod;
@property (weak, nonatomic) IBOutlet UILabel *couponStatus;

@end
