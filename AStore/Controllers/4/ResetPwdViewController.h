//
//  ResetPwdViewController.h
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPwdViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSString * userName;
@property (strong ,nonatomic) NSString * pwd;

@property (weak, nonatomic) IBOutlet UIButton *resetPassword;
- (IBAction)resetPasswordAction:(id)sender;

@end
