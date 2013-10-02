//
//  RegisterViewController.h
//  AStore
//
//  Created by Carl on 13-10-2.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
