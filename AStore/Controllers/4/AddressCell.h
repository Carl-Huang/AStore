//
//  AddressCell.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^configureAddressBlock) (id item);
@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *alterBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (assign, nonatomic) BOOL isChooseBtnSelect;
@property (assign, nonatomic) BOOL isAlterBtnSelect;
@property (assign, nonatomic) BOOL isDeleteBtnSelect;
- (IBAction)chooseBtnAction:(id)sender;
- (IBAction)alterBtnAction:(id)sender;
- (IBAction)deleteBtnAction:(id)sender;


@property (strong ,nonatomic) configureAddressBlock addressBlock;
-(void)setConfigureBlock:(configureAddressBlock)block;
@end
