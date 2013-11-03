//
//  DeliveryCell.h
//  AStore
//
//  Created by vedon on 10/4/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeToReach;
@property (weak, nonatomic) IBOutlet UILabel *additionMoney;
@property (weak, nonatomic) IBOutlet UIWebView * addressDescription;
@property (weak, nonatomic) IBOutlet UILabel *awardMethod;

@end
