//
//  RegisterViewController.m
//  AStore
//
//  Created by Carl on 13-10-2.
//  Copyright (c) 2013年 carl. All rights reserved.
//
#define UserNameTag         1002
#define ConfirmPassWordTag  1004
#define PasswordTag         1003
#define EmailTag            1005
#define TableViewOff        60
#import "RegisterViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "User.h"
#import "UserCenterViewController.h"
#import "AppDelegate.h"
@interface RegisterViewController () <UITextFieldDelegate>
{
    NSInteger tableViewOriY;
    NSInteger tableViewAlteredY;
}
@property (nonatomic,retain) UITextField * usernameField;
@property (nonatomic,retain) UITextField * passwordField;
@property (nonatomic,retain) UITextField * confirmPwdField;
@property (nonatomic,retain) UITextField * emailField;
@property (nonatomic,assign) CGRect originTableSize;
@end

@implementation RegisterViewController
@synthesize usernameField,passwordField,confirmPwdField,emailField;
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
    self.originTableSize = self.tableView.frame;
    tableViewOriY = self.tableView.frame.origin.y;
    tableViewAlteredY = self.tableView.frame.origin.y-TableViewOff;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {

    if ((usernameField.text.length == 0))//用户名为空
    {
        [self showAlertViewWithTitle:@"提示" message:@"用户名不能为空"];
        return;
    } else {
        error_tpye RES = [User isUserNamelegal:usernameField.text];
        NSString *alertStr = nil;
        switch (RES) {
            case ALL_NUM_ERROR:
                alertStr = @"用户名不能全为数字";
                break;
            case SPECIAL_WORD_ERROR:
                alertStr = @"用户名不能存在非法字符";
                break;
            case LENGTH_ERROR:
                alertStr = @"用户名长度需为3~16个字符";
                break;
                
            default:
                break;
        }
        if (alertStr != nil) {
            [self showAlertViewWithTitle:@"提示" message:alertStr];
            return;
        }
    }
    
    if ((passwordField.text.length == 0)||(confirmPwdField.text.length ==0)||![passwordField.text isEqualToString:confirmPwdField.text]) {//密码不匹配或为空
        [self showAlertViewWithTitle:@"提示" message:@"密码输入不一致"];
        return;
    }else if (![User isPwdlegal:passwordField.text]){
        [self showAlertViewWithTitle:@"提示" message:@"密码长度不正确"];
        return;
    }else if(![User isPwdNoSpecialCharacterStr:passwordField.text])
    {
        [self showAlertViewWithTitle:@"提示" message:@"密码不能包括特殊字符"];
        return;
    }

    if([self emailcheck:usernameField.text]){
        [self showAlertViewWithTitle:@"提示" message:@"邮箱格式不正确"];
        return;
    }
    else if(![self CheckNum:usernameField.text]){
        [self showAlertViewWithTitle:@"提示" message:@"用户名不能全部使用数字"];
        return;
    }
    [self regist];
    
}

-(void)regist
{
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate showLoginViewOnView:self.view];
    [HttpHelper userRegisterWithName:self.usernameField.text pwd:self.passwordField.text email:self.emailField.text completedBlock:^(id items) {
        NSString * str = (NSString * )items;
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"注册成功");
            UserCenterViewController * viewController = [[UserCenterViewController alloc]initWithNibName:@"UserCenterViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            viewController = nil;
        }else
        {
            NSLog(@"注册失败");
            [self showAlertViewWithTitle:@"提示" message:@"注册失败"];
        }
    } failedBlock:^(NSError *error) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
        [self showAlertViewWithTitle:@"提示" message:@"服务器错误"];

        NSLog(@"%@",[error description]);
    }];
    
    
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [pAlert show];
    pAlert = nil;

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
            usernameField = [[UITextField alloc] initWithFrame:fieldFrame];
            usernameField.tag = UserNameTag;
            usernameField.borderStyle = UITextBorderStyleNone;
            usernameField.returnKeyType = UIReturnKeyNext;
            usernameField.delegate = self;
            [cell.contentView addSubview:usernameField];
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
            passwordField = [[UITextField alloc] initWithFrame:fieldFrame];
            passwordField.tag = PasswordTag;
            passwordField.borderStyle = UITextBorderStyleNone;
            passwordField.returnKeyType = UIReturnKeyNext;
            passwordField.delegate = self;
            passwordField.secureTextEntry = YES;
            
            [cell.contentView addSubview:passwordField];
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
            confirmPwdField = [[UITextField alloc] initWithFrame:fieldFrame];
            confirmPwdField.tag = ConfirmPassWordTag;
            confirmPwdField.borderStyle = UITextBorderStyleNone;
            confirmPwdField.returnKeyType = UIReturnKeyNext;
            confirmPwdField.delegate = self;
            confirmPwdField.secureTextEntry = YES;
            
            [cell.contentView addSubview:confirmPwdField];
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
            emailField = [[UITextField alloc] initWithFrame:fieldFrame];
            emailField.tag = EmailTag;
            emailField.borderStyle = UITextBorderStyleNone;
            emailField.returnKeyType = UIReturnKeyDone;
            emailField.keyboardType = UIKeyboardTypeEmailAddress;
            emailField.delegate = self;
            [cell.contentView addSubview:emailField];
        }
    }
    
    cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:234.0/255.0 alpha:1.0];
    return cell;
}


-(BOOL)CheckNum:(NSString*)nameStr
{
    NSString *mystring = [NSString stringWithFormat:@"%@",nameStr];
    NSString *regex = [NSString stringWithFormat:@"[0-9]{%d}",mystring.length];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:mystring]) {
        return NO;
    }
    return YES;
}

-(BOOL)emailcheck:(NSString*)email
{
    
    if ((email == nil) || (email.length <= 0)) {
        return NO;
    }
    
    const char* mail = [email UTF8String];
    
    char* attag = strstr( mail, "@");
    if ((attag == NULL) || ((attag - mail) <= 0)){
        return NO;
    }
    
    char* point = strstr(attag, ".");
    
    if ((point-attag) <= 1) {
        return NO;
    }
    if ((point - mail) >= (strlen(mail) - 1)) {
        return NO;
    }
    return YES;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [usernameField becomeFirstResponder];
    }
    else if(indexPath.row == 1)
    {
        [passwordField becomeFirstResponder];
    }
    else if(indexPath.row == 2)
    {
        [confirmPwdField becomeFirstResponder];
        [self.tableView setFrame:CGRectOffset(self.tableView.frame, 0, -50)];
    }
    else if(indexPath.row == 3)
    {
        [emailField becomeFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
    if (textField.tag == UserNameTag||textField.tag == PasswordTag) {
        [self resizeTableViewDown];
    }
    if (textField.tag == EmailTag ||textField.tag == ConfirmPassWordTag) {
        [self resizeTableViewUp];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == usernameField)
    {
        [passwordField becomeFirstResponder];
        return NO;
    }
    
    if(textField == passwordField)
    {
        [confirmPwdField becomeFirstResponder];
        return NO;
    }
    
    if(textField == confirmPwdField)
    {
        [emailField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == EmailTag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = self.originTableSize;
        }];

    }
    
    return YES;
}

-(void)resizeTableViewUp
{
    CGRect rect = self.tableView.frame;
    if (!IS_SCREEN_4_INCH) {
        if (rect.origin.y == tableViewOriY) {
            rect.origin.y -=TableViewOff;
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView setFrame:rect];
            }];
        }
    }
}

-(void)resizeTableViewDown
{
    CGRect rect = self.tableView.frame;
    if (!IS_SCREEN_4_INCH) {
        if(rect.origin.y == tableViewAlteredY)
        {
            rect.origin.y +=TableViewOff;
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView setFrame:rect];
            }];
        }
    }
}

@end
