//
//  MainCommodityViewController.h
//  AStore
//
//  Created by vedon on 10/14/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCommodityViewController : UIViewController
@property (strong ,nonatomic) NSMutableArray  * dataSource;
@property (strong ,nonatomic) NSString * titleStr;
@property (strong ,nonatomic) NSString * tabId;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
