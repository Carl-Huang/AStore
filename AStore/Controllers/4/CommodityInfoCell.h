//
//  CommodityInfoCell.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *commodityMoneySum;

@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *deliveryCost;
@property (weak, nonatomic) IBOutlet UILabel *getPoint;
@property (weak, nonatomic) IBOutlet UILabel *consumePoint;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTime;
@end
