//
//  LoginViewController.m
//  AStore
//
//  Created by Carl on 13-10-2.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+LeftTitle.h"
#import "RegisterViewController.h"
@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic,retain) UITextField * usernameField;
@property (nonatomic,retain) UITextField * passwordField;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"登陆"];
    
    UIView * bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    [_tableView setBackgroundView:bgView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (NSString *)tabImageName
{
	return @"个人中心icon-n";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 45)];
            nameLabel.text = @"账户名:";
            nameLabel.font = [UIFont systemFontOfSize:18];
            nameLabel.textColor = [UIColor darkTextColor];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(93, 18, 205, 30)];
            _usernameField.borderStyle = UITextBorderStyleNone;
            _usernameField.returnKeyType = UIReturnKeyNext;
            _usernameField.delegate = self;
            [cell.contentView addSubview:_usernameField];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PwdCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PwdCell"];
            UILabel * pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 80, 45)];
            pwdLabel.text = @"密  码:";
            pwdLabel.font = [UIFont systemFontOfSize:18];
            pwdLabel.textColor = [UIColor darkTextColor];
            pwdLabel.textAlignment = NSTextAlignmentRight;
            pwdLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:pwdLabel];
            _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(93, 18, 205, 30)];
            _passwordField.borderStyle = UITextBorderStyleNone;
            _passwordField.returnKeyType = UIReturnKeyDefault;
            _passwordField.delegate = self;
            _passwordField.secureTextEntry = YES;
            
            [cell.contentView addSubview:_passwordField];
        }
    }
    
    cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:234.0/255.0 alpha:1.0];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [_usernameField becomeFirstResponder];
    }
    else
    {
        [_passwordField becomeFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _usernameField)
    {
        [_passwordField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)loginAction:(id)sender {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    
}

- (IBAction)registerAction:(id)sender
{
    RegisterViewController * registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
}
@end
