//
//  UserOrderViewController.m
//  AStore
//
//  Created by vedon on 10/2/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "UserOrderViewController.h"
#import "UIViewController+LeftTitle.h"
#import "MyOrderViewController.h"
#import "MyCouponViewController.h"
@interface UserOrderViewController ()
@property (strong ,nonatomic)NSArray * dataSource;
@end

@implementation UserOrderViewController
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSource = @[@"我的订单",@"我的优惠券",@"修改密码",@"地址管理",@"检查版本"];
        // Custm initialization
    }
   return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"个人中心"];
    [self.orderTableView setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOrderTableView:nil];
    [self setLogoutBtn:nil];
    [self setUserNameLabel:nil];
    [self setUserTypeLabel:nil];
    [self setUserScoreLabel:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            NSLog(@"%@",cell.textLabel.text);
            [self pushMyOrderViewController];
            break;
        case 1:
            NSLog(@"%@",cell.textLabel.text);
            [self pushMyCouponViewController];
            break;
        case 2:
            NSLog(@"%@",cell.textLabel.text);
            break;
        case 3:
            NSLog(@"%@",cell.textLabel.text);
            break;
        case 4:
            NSLog(@"%@",cell.textLabel.text);
            break;
        default:
            break;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString * cellIdentifier = @"orderCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [dataSource lastObject];
    }else
    {
        cell.textLabel.text = [dataSource objectAtIndex:indexPath.row]; 
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (IBAction)logoutAction:(id)sender {
    NSLog(@"%s",__func__);
}
@end
