//
//  AddAddressCell.h
//  AStore
//
//  Created by vedon on 19/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^firstBtnBlock) ();
typedef void(^secondBtnBlock) ();
typedef void(^thirdBtnBlock) ();

@interface AddAddressCell : UITableViewCell<UITextFieldDelegate>
- (IBAction)firstBtnAction:(id)sender;
- (IBAction)secondBtnAction:(id)sender;
- (IBAction)thirdBtnAction:(id)sender;
@property (strong ,nonatomic)firstBtnBlock firstBlock;
@property (strong ,nonatomic)firstBtnBlock secondBlock;
@property (strong ,nonatomic)firstBtnBlock thirdBlock;

@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextfield;
@property (weak, nonatomic) IBOutlet UITextField *thirdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *fourthTextfield;

@end
