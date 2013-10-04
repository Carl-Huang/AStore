//
//  ConfirmOrderViewController.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
static NSString * cellIdentifier = @"cellIdentifier";
#import "ConfirmOrderViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HeaderView.h"
#import "DeliveryViewController.h"
@interface ConfirmOrderViewController ()
@property (strong ,nonatomic)NSArray * dataSource;
@end

@implementation ConfirmOrderViewController
@synthesize dataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataSource = @[@"收货人信息",@"付款方式",@"配送方式",@"查看商品清单"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"订单确认"];
    [self setBackItem:nil];
    self.confirmTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView * imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分类背景"]];
    imageview.contentMode = UIViewContentModeScaleToFill;
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 330, 320, 50)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    UIButton * posForm = [UIButton buttonWithType:UIButtonTypeCustom];
    [posForm setFrame:CGRectMake(230, 5, 80, 30)];
    [posForm setBackgroundImage:[UIImage imageNamed:@"加入购物车-红-bg"] forState:UIControlStateNormal];
    [posForm addTarget:self action:@selector(postFormAction) forControlEvents:UIControlEventTouchUpInside];
    [posForm setTitle:@"提交订单" forState:UIControlStateNormal];
    UILabel * sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 30)];
    sumLabel.text = @"应付总额:￥4.2";
    [sumLabel setBackgroundColor:[UIColor clearColor]];
    [footerView addSubview:imageview];
    [footerView addSubview:posForm];
    [footerView addSubview:sumLabel];
    [self.view addSubview:footerView];
    imageview = nil;
    sumLabel = nil;
    footerView = nil;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)postFormAction
{
    NSLog(@"%s",__func__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setConfirmTable:nil];
    [super viewDidUnload];
}

-(void)offlinePayAction
{
    NSLog(@"%s",__func__);
}


-(void)onlinePayAction
{
    NSLog(@"%s",__func__);
}
#pragma mark - UITableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger rowIndex = indexPath.row+indexPath.section*2;
    switch (rowIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            [self pushDeliveryViewController];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

-(void)pushDeliveryViewController
{
    DeliveryViewController * viewcontroller = [[DeliveryViewController alloc]initWithNibName:@"DeliveryViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
//        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//        [headerView setBackgroundColor:[UIColor whiteColor]];
//        return headerView;
        HeaderView * headerView = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
        [headerView.offlinePayBtn addTarget:self action:@selector(offlinePayAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView.onlinePayBtn addTarget:self action:@selector(onlinePayAction) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView setBackgroundColor:[UIColor whiteColor]];
        return headerView;
    }else
        return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    }else
        return 40.0;
}

#pragma mark - UITableDataSourceDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 40)];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    descriptionLabel.text = [self.dataSource objectAtIndex:indexPath.row+2*indexPath.section];
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView * imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购买流程bg"]];
    [imageview setFrame:CGRectMake(8, 5, 310, 40)];
    [cell.contentView addSubview:imageview];
    [cell.contentView addSubview:descriptionLabel];
    imageview = nil;
    descriptionLabel = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1)
        return 2;
    return  [self.dataSource count];
    
}
@end
