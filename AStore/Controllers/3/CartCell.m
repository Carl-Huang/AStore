//
//  CartCell.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell
@synthesize commodityId;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)minusAction:(id)sender {
    self.munisBlock(commodityId);
}

- (IBAction)plusAction:(id)sender {
    self.plusBlock(commodityId);
}
@end
