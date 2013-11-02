//
//  ModifyAddressViewController.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressInfo;
@interface ModifyAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *addressTable;
@property (strong ,nonatomic) AddressInfo * modifitedData;
@property (strong ,nonatomic) NSString * titleStr;
- (IBAction)saveBtnAction:(id)sender;

@end
