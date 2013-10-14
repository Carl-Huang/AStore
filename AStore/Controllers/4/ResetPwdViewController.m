//
//  ResetPwdViewController.m
//  AStore
//
//  Created by Carl on 13-10-3.
//  Copyright (c) 2013年 carl. All rights reserved.
//
#define ResetPwdAlerMessage @"修改密码失败"
#import "ResetPwdViewController.h"
#import "UIViewController+LeftTitle.h"
#import "LoginViewController.h"
#import "User.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface ResetPwdViewController () <UITextFieldDelegate>
{
    BOOL isAlertViewCanShow;
}

@property (nonatomic,retain) UITextField * oldPwdField;
@property (nonatomic,retain) UITextField * nPwdField;
@property (nonatomic,retain) UITextField * confirmPwdField;

@end

@implementation ResetPwdViewController
@synthesize userName;
@synthesize pwd;

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
    NSDictionary * dic = [User getUserInfo];
    if ([dic count]) {
        userName = [[NSString alloc]initWithString:[dic objectForKey:DUserName]];
        pwd = [[NSString alloc]initWithString:[dic objectForKey:DPassword]];
        NSLog(@"UserName: %@,   pwd:%@",userName,pwd);
    }
    isAlertViewCanShow = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setResetPassword:nil];
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



- (IBAction)resetPasswordAction:(id)sender {
    NSLog(@"%s",__func__);
    if (![self.oldPwdField.text isEqualToString:pwd]) {
        NSLog(@"输入旧密码不对");
    }else if ((self.nPwdField.text.length == 0)||(self.confirmPwdField.text.length ==0)||![self.nPwdField.text isEqualToString:self.confirmPwdField.text]) {//密码不匹配或为空
        [self showAlertViewWithTitle:@"提示" message:@"密码输入不一致"];
    }else if (![User isPwdlegal:self.nPwdField.text]){
        [self showAlertViewWithTitle:@"提示" message:@"密码长度不正确"];
    }else if(![User isPwdNoSpecialCharacterStr:self.nPwdField.text])
    {
        [self showAlertViewWithTitle:@"提示" message:@"密码不能包括特殊字符"];
    }else
    {
        NSString * cmdStr = [NSString stringWithFormat:@"updatepwd=%@&&Uname=%@",self.nPwdField.text,userName];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate  showLoginViewOnView:self.view];
        [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
            NSLog(@"%@",resultInfo);
            if ([resultInfo count]) {
                NSDictionary * dic = [resultInfo objectAtIndex:0];
                if ([[dic objectForKey:RequestStatusKey] isEqualToString:@"1"]) {
                    NSLog(@"修改密码成功");
                    [self pushToLoginViewcontroller];
                }else
                {
                    NSLog(@"修改密码失败");
                    [self showAlertViewWithTitle:@"提示" message:ResetPwdAlerMessage];
                    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    [myDelegate  removeLoadingViewWithView:nil];
                }
            }
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",[error description]);
        }];
    }

}

-(void)pushToLoginViewcontroller
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  removeLoadingViewWithView:nil];
    NSLog(@"%s",__func__);
    NSArray *ary = self.navigationController.viewControllers;
    for (UIViewController * viewcontroller in ary) {
        if ([viewcontroller isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:viewcontroller animated:YES];
            return;
        }
    }
    LoginViewController * loginViewcontroller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewcontroller animated:YES];
    loginViewcontroller = nil;
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    if (isAlertViewCanShow) {
        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pAlert show];
        pAlert = nil;
    }
    
}
@end
