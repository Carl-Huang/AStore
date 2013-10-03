//
//  MyOrderViewController.h
//  AStore
//
//  Created by vedon on 10/2/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commodityTable;

@end
