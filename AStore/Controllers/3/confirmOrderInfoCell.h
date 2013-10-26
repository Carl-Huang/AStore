//
//  confirmOrderInfoCell.h
//  AStore
//
//  Created by vedon on 26/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface confirmOrderInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalProductMoney;
@property (weak, nonatomic) IBOutlet UILabel *getPoint;
@property (weak, nonatomic) IBOutlet UILabel *deliveryCost;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@end
