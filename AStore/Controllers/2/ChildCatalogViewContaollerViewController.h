//
//  ChildCatalogViewContaollerViewController.h
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildCatalogViewContaollerViewController : UITableViewController
@property (strong ,nonatomic) NSArray  * dataSource;
@property (strong ,nonatomic) NSString * cat_id;
@property (strong ,nonatomic) NSString * cat_name;

@end
