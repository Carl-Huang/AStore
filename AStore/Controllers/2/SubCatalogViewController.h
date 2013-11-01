//
//  SubCatalogViewController.h
//  AStore
//
//  Created by Vedon on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCatalogViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSArray * dataSource;
@property (strong ,nonatomic) NSString * titleStr;
@end
