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
    NSDictionary * localUserData = [User getUserInfo];
    if (localUserData) {
        usernameLabel.text = [localUserData objectForKey:DUserName];
    }
    [self synchronizationWithServer:localUserData];
    [self setLeftTitle:@"个人中心"];
    _dataSource = @[@[@"我的订单",@"我的优惠卷",@"修改密码",@"地址管理"],@[@"检查版本"]];
}
-(void)viewWillAppear:(BOOL)animated
{
    
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

-(void)synchronizationWithServer:(NSDictionary *)userInfo
{
    NSLog(@"%s",__func__);
    NSString * cmdStr = [NSString stringWithFormat:@"getUser=%@&&pwd=%@",[userInfo objectForKey:DUserName],[userInfo objectForKey:DPassword]];
    NSLog(@"cmdStr :%@",cmdStr);
    [HttpHelper getAllCatalogWithSuffix:cmdStr SuccessBlock:^(NSArray *catInfo) {
        for (NSDictionary * dic in catInfo) {
            synDicInfo = dic;
            [self performSelectorOnMainThread:@selector(updateInterface) withObject:nil waitUntilDone:YES];
        }
    } errorBlock:^(NSError *error) {
        ;
    }];
}

-(void)updateInterface
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",synDicInfo);
    self.pointLabel.text = [synDicInfo objectForKey:@"point"];
    self.userTypeLabel.text = [synDicInfo objectForKey:@"lv_name"];
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
            ResetPwdViewController * resetPwdViewController = [[ResetPwdViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:resetPwdViewController animated:YES];
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

-(void)pushMyOrderViewController
{
    MyOrderViewController * viewController = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
-(void)pushMyCouponViewController
{
    MyCouponViewController * viewController = [[MyCouponViewController alloc]initWithNibName:@"MyCouponViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

-(void)pushMyAddressViewController
{
    MyAddressViewController * viewController = [[MyAddressViewController alloc]initWithNibName:@"MyAddressViewController" bundle:nil];
    [viewController setMyAddressDataSourece:[synDicInfo objectForKey:@"area"]];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
}

- (IBAction)loginOutAction:(id)sender
{
    LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationController.viewControllers = @[loginViewController];
    loginViewController = nil;
}
@end
