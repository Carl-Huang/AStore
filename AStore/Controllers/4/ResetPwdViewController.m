//
//  ResetPwdViewController.m
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "UIViewController+LeftTitle.h"
@interface ResetPwdViewController () <UITextFieldDelegate>
@property (nonatomic,retain) UITextField * oldPwdField;
@property (nonatomic,retain) UITextField * nPwdField;
@property (nonatomic,retain) UITextField * confirmPwdField;

@end

@implementation ResetPwdViewController


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
    [self setLeftTitle:@"修改密码"];
    [self setBackItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
            nameLabel.text = @"旧密码:";
            nameLabel.font = [UIFont systemFontOfSize:18];
            nameLabel.textColor = [UIColor darkTextColor];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            _oldPwdField = [[UITextField alloc] initWithFrame:fieldFrame];
            _oldPwdField.borderStyle = UITextBorderStyleNone;
            _oldPwdField.returnKeyType = UIReturnKeyNext;
            _oldPwdField.delegate = self;
            _oldPwdField.secureTextEntry = YES;
            [cell.contentView addSubview:_oldPwdField];
        }
    }
    else if(indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PwdCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PwdCell"];
            UILabel * pwdLabel = [[UILabel alloc] initWithFrame:labelFrame];
            pwdLabel.text = @"新密码:";
            pwdLabel.font = [UIFont systemFontOfSize:18];
            pwdLabel.textColor = [UIColor darkTextColor];
            pwdLabel.textAlignment = NSTextAlignmentRight;
            pwdLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:pwdLabel];
            _nPwdField = [[UITextField alloc] initWithFrame:fieldFrame];
            _nPwdField.borderStyle = UITextBorderStyleNone;
            _nPwdField.returnKeyType = UIReturnKeyNext;
            _nPwdField.delegate = self;
            _nPwdField.secureTextEntry = YES;
            [cell.contentView addSubview:_nPwdField];
        }
    }
    else 
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
            _confirmPwdField.returnKeyType = UIReturnKeyDone;
            _confirmPwdField.delegate = self;
            _confirmPwdField.secureTextEntry = YES;
            [cell.contentView addSubview:_confirmPwdField];
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
        [_oldPwdField becomeFirstResponder];
    }
    else if(indexPath.row == 1)
    {
        [_nPwdField becomeFirstResponder];
    }
    else if(indexPath.row == 2)
    {
        [_confirmPwdField becomeFirstResponder];
    }

}


#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _oldPwdField)
    {
        [_nPwdField becomeFirstResponder];
        return NO;
    }
    
    if(textField == _nPwdField)
    {
        [_confirmPwdField becomeFirstResponder];
        return NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)resetPwd:(id)sender
{
    
}
@end
