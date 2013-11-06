//
//  SearchResultViewController.h
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) NSString * lTitle;
@property (strong , nonatomic) NSString * searchStr;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet UILabel *netWorkStatusText;
@property (weak, nonatomic) IBOutlet UILabel *searchStatusText;
@end
