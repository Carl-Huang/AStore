//
//  AddAddressCell.m
//  AStore
//
//  Created by vedon on 19/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "AddAddressCell.h"
@implementation AddAddressCell

-(void) awakeFromNib
{
    self.firstTextField.adjustsFontSizeToFitWidth   = YES;
    self.secondTextfield.adjustsFontSizeToFitWidth  = YES;
    self.thirdTextfield.adjustsFontSizeToFitWidth   = YES;
    [self.fourthTextfield setReturnKeyType:UIReturnKeyDone];
    self.fourthTextfield.delegate = self;
    
}

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

- (IBAction)firstBtnAction:(id)sender {
    self.firstBlock();
    [self.firstBtn setEnabled:NO];
    [self.secBtn setEnabled:NO];
    [self.thirBtn setEnabled:NO];
    
}

- (IBAction)secondBtnAction:(id)sender {
    self.secondBlock();
    [self.firstBtn setEnabled:NO];
    [self.secBtn setEnabled:NO];
    [self.thirBtn setEnabled:NO];

}

- (IBAction)thirdBtnAction:(id)sender {
    self.thirdBlock();
    [self.firstBtn setEnabled:NO];
    [self.secBtn setEnabled:NO];
    [self.thirBtn setEnabled:NO];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textFieldBlock(textField.text);
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFieldBlock(textField.text);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
//        self.textFieldBlock(textField.text);
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
