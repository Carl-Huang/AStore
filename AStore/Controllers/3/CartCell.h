//
//  CartCell.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"
typedef void (^CarCellMinusBlock)(id item);
typedef void (^CarCellPlusBlock)(id item);
@interface CartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *MoneySum;
@property (weak, nonatomic) IBOutlet UILabel *productNumber;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (strong ,nonatomic) NSString * commodityId;
@property (strong ,nonatomic) CarCellPlusBlock plusBlock;
@property (strong ,nonatomic) CarCellMinusBlock munisBlock;
- (IBAction)minusAction:(id)sender;
- (IBAction)plusAction:(id)sender;
@end
