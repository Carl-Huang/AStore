//
//  TZCommodityViewController.h
//  AStore
//
//  Created by Carl on 13-10-30.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZCommodityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) NSString * lTitle;
@property (strong , nonatomic) NSString * searchStr;
@end
