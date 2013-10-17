//
//  YHJDetailViewController.h
//  AStore
//
//  Created by vedon on 10/17/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHJDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString * lTitle;
@end
