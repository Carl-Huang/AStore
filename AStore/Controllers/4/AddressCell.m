//
//  AddressCell.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "AddressCell.h"
#import "constants.h"
#import "AddressInfo.h"
@implementation AddressCell
@synthesize addressBlock;
@synthesize chooseBtn;
@synthesize alterBtn;
@synthesize deleteBtn;

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.isChooseBtnSelect = NO;
    self.isAlterBtnSelect = NO;
    self.isDeleteBtnSelect = NO;
    chooseBtn.tag = chooseBtnTag;
    alterBtn.tag = alterBtnTag;
    deleteBtn.tag = deleteBtnTag;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isChooseBtnSelect = NO;
        self.isAlterBtnSelect = NO;
        self.isDeleteBtnSelect = NO;
        chooseBtn.tag = chooseBtnTag;
        alterBtn.tag = alterBtnTag;
        deleteBtn.tag = deleteBtnTag;
        // Initialization code
    }
    return self;
}

-(void)setConfigureBlock:(configureAddressBlock)block
{
    addressBlock = [block copy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseBtnAction:(id)sender {
    NSLog(@"%s",__func__);
    self.addressBlock(sender,self.addressInfo);
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
    self.addressBlock(sender,self.addressInfo);
//    self.isAlterBtnSelect = !self.isAlterBtnSelect;
//    if (self.isAlterBtnSelect) {
//        [self.alterBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    }else
//    {
//        [self.alterBtn setBackgroundImage:[UIImage imageNamed:@"分类背景框-b"] forState:UIControlStateNormal];
//    }
}

- (IBAction)deleteBtnAction:(id)sender {
    NSLog(@"%s",__func__);
    self.addressBlock(sender,self.addressInfo);
//    self.isDeleteBtnSelect = !self.isDeleteBtnSelect;
//    if (self.isDeleteBtnSelect) {
//        [self.deleteBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    }else
//    {
//        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"分类背景框-b"] forState:UIControlStateNormal];
//    }
}
@end
