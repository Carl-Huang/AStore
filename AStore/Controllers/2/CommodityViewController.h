//
//  CommodityViewController.h
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"
@interface CommodityViewController : UIViewController
@property (strong ,nonatomic) Commodity * comodityInfo;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *proceLabel;
@property (weak, nonatomic) IBOutlet UITableView *commodityTableView;
@property (weak, nonatomic) IBOutlet UIImageView *produceImage;

@end
