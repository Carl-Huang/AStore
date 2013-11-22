//
//  DeliveryViewController.h
//  AStore
//
//  Created by vedon on 10/4/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeliveryTypeInfo;
@interface DeliveryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *deliveryTable;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (strong ,nonatomic) DeliveryTypeInfo * deliveryMethod;
@property (weak ,nonatomic) UIViewController * weakViewController;
- (IBAction)deliveryBtnAction:(id)sender;

@end
