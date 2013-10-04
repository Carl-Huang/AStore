//
//  CartCellHeader.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCellHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyValue;
@property (weak, nonatomic) IBOutlet UIButton *closeAccountBtn;

@end
