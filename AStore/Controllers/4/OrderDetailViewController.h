//
//  OrderDetailViewController.h
//  AStore
//
//  Created by vedon on 27/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetOrderInfo;
@interface OrderDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *orderDetailTableview;
@property (strong ,nonatomic) NSArray * dataSource;
@property (strong ,nonatomic) GetOrderInfo * orderInfo;
@end
