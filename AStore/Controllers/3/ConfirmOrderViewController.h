//
//  ConfirmOrderViewController.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *confirmTable;
@property (assign,nonatomic) float commoditySumMoney;
@property (assign,nonatomic) float giftSumMoney;
@end
