//
//  RegisterViewController.m
//  AStore
//
//  Created by Carl on 13-10-2.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+LeftTitle.h"
@interface RegisterViewController () <UITextFieldDelegate>
@property (nonatomic,retain) UITextField * usernameField;
@property (nonatomic,retain) UITextField * passwordField;
@property (nonatomic,retain) UITextField * confirmPwdField;
@property (nonatomic,retain) UITextField * emailField;
@end

@implementation RegisterViewController

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
    [self setLeftTitle:@"免费注册"];
    [self setBackItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    CGRect labelFrame = CGRectMake(8, 5, 80, 45);
    CGRect fieldFrame = CGRectMake(93, 18, 205, 30);
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
            nameLabel.text = @"账户名:";
            nameLabel.font = [UIFont systemFontOfSize:18];
            nameLabel.textColor = [UIColor darkTextColor];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            _usernameField = [[UITextField alloc] initWithFrame:fieldFrame];
            _usernameField.borderStyle = UITextBorderStyleNone;
            _usernameField.returnKeyType = UIReturnKeyNext;
            _usernameField.delegate = self;
            [cell.contentView addSubview:_usernameField];
        }
    }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PwdCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PwdCell"];
            UILabel * pwdLabel = [[UILabel alloc] initWithFrame:labelFrame];
            pwdLabel.text = @"密  码:";
            pwdLabel.font = [UIFont systemFontOfSize:18];
            pwdLabel.textColor = [UIColor darkTextColor];
            pwdLabel.textAlignment = NSTextAlignmentRight;
            pwdLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:pwdLabel];
            _passwordField = [[UITextField alloc] initWithFrame:fieldFrame];
            _passwordField.borderStyle = UITextBorderStyleNone;
            _passwordField.returnKeyType = UIReturnKeyNext;
            _passwordField.delegate = self;
            _passwordField.secureTextEntry = YES;
            
            [cell.contentView addSubview:_passwordField];
        }
    }
    else if(indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmPwdCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConfirmPwdCell"];
            UILabel * confirmLabel = [[UILabel alloc] initWithFrame:labelFrame];
            confirmLabel.text = @"确认密码:";
            confirmLabel.font = [UIFont systemFontOfSize:18];
            confirmLabel.textColor = [UIColor darkTextColor];
            confirmLabel.textAlignment = NSTextAlignmentRight;
            confirmLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:confirmLabel];
            _confirmPwdField = [[UITextField alloc] initWithFrame:fieldFrame];
            _confirmPwdField.borderStyle = UITextBorderStyleNone;
            _confirmPwdField.returnKeyType = UIReturnKeyNext;
            _confirmPwdField.delegate = self;
            _confirmPwdField.secureTextEntry = YES;
            
            [cell.contentView addSubview:_confirmPwdField];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmailCell"];
            UILabel * emalLabel = [[UILabel alloc] initWithFrame:labelFrame];
            emalLabel.text = @"电子邮箱:";
            emalLabel.font = [UIFont systemFontOfSize:18];
            emalLabel.textColor = [UIColor darkTextColor];
            emalLabel.textAlignment = NSTextAlignmentRight;
            emalLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:emalLabel];
            _emailField = [[UITextField alloc] initWithFrame:fieldFrame];
            _emailField.borderStyle = UITextBorderStyleNone;
            _emailField.returnKeyType = UIReturnKeyDone;
            _emailField.keyboardType = UIKeyboardTypeEmailAddress;
            _emailField.delegate = self;
            [cell.contentView addSubview:_emailField];
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
    else if(indexPath.row == 1)
    {
        [_passwordField becomeFirstResponder];
    }
    else if(indexPath.row == 2)
    {
        [_confirmPwdField becomeFirstResponder];
    }
    else if(indexPath.row == 3)
    {
        [_emailField becomeFirstResponder];
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
    
    if(textField == _passwordField)
    {
        [_confirmPwdField becomeFirstResponder];
        return NO;
    }
    
    if(textField == _confirmPwdField)
    {
        [_emailField becomeFirstResponder];
        return NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}


@end
