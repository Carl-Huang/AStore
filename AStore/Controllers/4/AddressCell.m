//
//  AddressCell.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isChooseBtnSelect = NO;
        self.isAlterBtnSelect = NO;
        self.isDeleteBtnSelect = NO;
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseBtnAction:(id)sender {
    NSLog(@"%s",__func__);
    self.isChooseBtnSelect = !self.isChooseBtnSelect;
    if (self.isChooseBtnSelect) {
        [self.chooseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }else
    {
        [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"分类背景框-b"] forState:UIControlStateNormal];
    }

}

- (IBAction)alterBtnAction:(id)sender {
    NSLog(@"%s",__func__);
    self.isAlterBtnSelect = !self.isAlterBtnSelect;
    if (self.isAlterBtnSelect) {
        [self.alterBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }else
    {
        [self.alterBtn setBackgroundImage:[UIImage imageNamed:@"分类背景框-b"] forState:UIControlStateNormal];
    }
}

- (IBAction)deleteBtnAction:(id)sender {
    NSLog(@"%s",__func__);
    self.isDeleteBtnSelect = !self.isDeleteBtnSelect;
    if (self.isDeleteBtnSelect) {
        [self.deleteBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }else
    {
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"分类背景框-b"] forState:UIControlStateNormal];
    }
}
@end
