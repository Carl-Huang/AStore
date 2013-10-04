//
//  DeliveryViewController.h
//  AStore
//
//  Created by vedon on 10/4/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *deliveryTable;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
- (IBAction)deliveryBtnAction:(id)sender;

@end
