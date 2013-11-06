//
//  CatalogViewController.h
//  AStore
//
//  Created by Carl on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface CatalogViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) MBProgressHUD * loadingView;
@end
