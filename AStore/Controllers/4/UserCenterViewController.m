//
//  UserCenterViewController.m
//  AStore
//
//  Created by Carl on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UIViewController+LeftTitle.h"
#import "ResetPwdViewController.h"
#import "MyOrderViewController.h"
#import "MyCouponViewController.h"
#import "MyAddressViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "HttpHelper.h"
#import "userInfo.h"
#import "NSMutableArray+SaveCustomiseData.h"
#import "NSString+MD5_32.h"
@interface UserCenterViewController ()
@property (nonatomic,retain)NSArray * dataSource;
@property (nonatomic, strong)__block NSDictionary * synDicInfo;
@end

@implementation UserCenterViewController
@synthesize usernameLabel,userTypeLabel,pointLabel;
@synthesize synDicInfo;
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
    //查询本地是否有用户已经登录
    synDicInfo = [[NSDictionary alloc]init];
    [self setLeftTitle:@"个人中心"];
    _dataSource = @[@[@"我的订单",@"我的优惠卷",@"修改密码",@"地址管理"]];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    NSDictionary * localUserData = [User getUserInfo];
    if (localUserData) {
        
        userInfo * localServerData = [userInfo unarchivingUserInfo];
        usernameLabel.text = [localUserData objectForKey:DUserName];
        if (localServerData) {
            self.pointLabel.text = localServerData.point;
            self.userTypeLabel.text = localServerData.lv_name;
            usernameLabel.text =  localServerData.uname;
        }

        [self synchronizationWithServer:localUserData];
    }else
    {
        //本地没有用户数据，则调到登陆界面
        LoginViewController *viewcontroller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:viewcontroller animated:YES];
        viewcontroller  = nil;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSString *)tabImageName
{
	return @"个人中心icon-n";
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setUsernameLabel:nil];
    [self setUserTypeLabel:nil];
    [self setPointLabel:nil];
    [super viewDidUnload];
}

-(void)synchronizationWithServer:(NSDictionary *)infoDic
{
    synDicInfo = infoDic;
    NSLog(@"%s",__func__);
    
    [HttpHelper getUserInfoWithUserName:[infoDic objectForKey:DUserName] pwd:[NSString md5:[infoDic objectForKey:DPassword]] completedBlock:^(id item, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]);
        }
        NSArray * array = item;
        if ([array count]) {
            userInfo *info = [array objectAtIndex:0];
            [userInfo archivingUserInfo:info];
            [self performSelectorOnMainThread:@selector(updateInterface:) withObject:info waitUntilDone:YES];
        }
    }];

}

-(void)updateInterface:(id)object
{
    NSLog(@"%s",__func__);
    userInfo * info = object;
    self.pointLabel.text = info.point;
    self.userTypeLabel.text = info.lv_name;
}
#pragma mark - UITableViewDateSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataSource objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.0;
    }
    return 13.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSString * title = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [self pushMyOrderViewController];
        }
        else if(indexPath.row == 1)
        {
            [self pushMyCouponViewController];
        }
        else if(indexPath.row ==2)
        {
            [self pushResetPassworkViewcontroller];
        }
        else if(indexPath.row == 3)
        {
            [self pushMyAddressViewController];
        }
    }
    else if (indexPath.section == 1)
    {
        
    }
}

-(void)pushResetPassworkViewcontroller
{
    ResetPwdViewController * resetPwdViewController = [[ResetPwdViewController alloc] initWithNibName:@"ResetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:resetPwdViewController animated:YES];
    resetPwdViewController = nil;
}

-(void)pushMyOrderViewController
{
    NSLog(@"%s",__func__);
    MyOrderViewController * viewController = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
-(void)pushMyCouponViewController
{
    MyCouponViewController * viewController = [[MyCouponViewController alloc]initWithNibName:@"MyCouponViewController" bundle:nil];
    [viewController setMemberId:[synDicInfo objectForKey:DMemberId]];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

-(void)pushMyAddressViewController
{
    NSLog(@"%s",__func__);
    MyAddressViewController * viewController = [[MyAddressViewController alloc]initWithNibName:@"MyAddressViewController" bundle:nil];
    NSString * str = [NSString stringWithFormat:@"%@",[synDicInfo objectForKey:@"area"]];
    if (![str isEqualToString:@"<null>"]) {
        NSLog(@"%@",str);
    }
    [viewController setMemberId:[synDicInfo objectForKey:DMemberId]];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
}

- (IBAction)loginOutAction:(id)sender
{
    //清理用户数据
    [User deleteUserInfo];
    [userInfo removeUserInfo];
    [NSMutableArray removeObjArrayWithkey:@"CommodityArray"];
    [NSMutableArray removeObjArrayWithkey:@"PresentArray"];

//    NSArray *ary = self.navigationController.viewControllers;
//    for (UIViewController *viewcontroller in ary) {
//        if ([ary isKindOfClass:[LoginViewController class]]) {
//            [self.navigationController popToViewController:viewcontroller animated:YES];
//            return;
//        }
//    }
    LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    loginViewController = nil;
}
@end
