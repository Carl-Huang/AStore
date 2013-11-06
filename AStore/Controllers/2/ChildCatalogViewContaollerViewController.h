//
//  ChildCatalogViewContaollerViewController.h
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface ChildCatalogViewContaollerViewController : UITableViewController
@property (strong ,nonatomic) NSMutableArray  * dataSource;
@property (strong ,nonatomic) NSString * cat_id;
@property (strong ,nonatomic) NSString * cat_name;
@property (strong, nonatomic) IBOutlet UITableView *catalogTableview;
@property (strong ,nonatomic) MBProgressHUD * loadingView;
@end
