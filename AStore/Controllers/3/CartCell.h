//
//  CartCell.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"

typedef NS_ENUM(NSInteger, CellType)
{
    CommodityCellType = 1,
    PresentCellType = 2,
    DefaultCellType = 3,
};

typedef void (^CarCellMinusBlock)(id item,CellType type);
typedef void (^CarCellPlusBlock)(id item,CellType type);
@interface CartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *MoneySum;
@property (weak, nonatomic) IBOutlet UILabel *productNumber;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (assign ,nonatomic) CellType type;
@property (assign , nonatomic)BOOL isSelected;
@property (strong ,nonatomic) NSString * Id;
@property (strong ,nonatomic) CarCellPlusBlock plusBlock;
@property (strong ,nonatomic) CarCellMinusBlock munisBlock;
- (IBAction)minusAction:(id)sender;
- (IBAction)plusAction:(id)sender;
@end
