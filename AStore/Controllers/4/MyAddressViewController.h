//
//  MyAddressViewController.h
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressInfo;
@interface MyAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *addressTable;
@property (strong ,nonatomic)NSString * memberId;
@property (strong ,nonatomic) AddressInfo * selectAddressInfo;
-(void)setMyAddressDataSourece:(NSArray *)dataAry;
@end
