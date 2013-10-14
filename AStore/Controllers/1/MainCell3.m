//
//  MainCell3.m
//  AStore
//
//  Created by Carl on 13-9-27.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "MainCell3.h"
@implementation MainCell3

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


- (IBAction)btnAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    //根据相应的title，获取相应的商品
    self.block(btn.titleLabel.text);
}
@end
