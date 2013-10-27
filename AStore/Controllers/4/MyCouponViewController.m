//
//  MyOrderViewController.m
//  AStore
//
//  Created by vedon on 10/2/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
#define CouponAlerMessage @"获取优惠券失败,是否重新获取"

#define VCouponNum          @"couponNumber"
#define VValidityTime       @"validityTime"
#define VCouponName         @"couponName"
#define VCanUseTime         @"canUseTime"
#define VCouponStatus       @"couponStatus"
#define VUseMethod          @"userMethod"


#import "MyCouponViewController.h"
#import "CouponCell.h"
#import "UIViewController+LeftTitle.h"
#import "CouponInfo.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
@interface MyCouponViewController ()<UIAlertViewDelegate>
{
    BOOL isAlertViewCanShow;
}
@property (strong ,nonatomic)NSMutableArray * commoditiesArray;
@end

@implementation MyCouponViewController
@synthesize commoditiesArray;
@synthesize memberId;
 static NSString * cellIdentifier = @"commodityInfoCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        commoditiesArray = [[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib * cellNib = [UINib nibWithNibName:@"CouponCell" bundle:[NSBundle bundleForClass:[CouponCell class]]];
    [self.commodityTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    [self setLeftTitle:@"我的优惠券"];
    [self setBackItem:nil];
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  showLoginViewOnView:self.view];
    isAlertViewCanShow = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCommodityTable:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchDataFromServer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    isAlertViewCanShow = NO;
}

-(void)fetchDataFromServer
{
    NSString *cmdStr = [NSString stringWithFormat:@"getcpns=%@",memberId];
    cmdStr = [SERVER_URL_Prefix stringByAppendingString:cmdStr];
    [HttpHelper requestWithString:cmdStr withClass:[CouponInfo class] successBlock:^(NSArray *items) {
        if ([items count]) {
            commoditiesArray = items;
        }
        [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
    } errorBlock:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
        [self showAlertViewWithTitle:@"提示" message:CouponAlerMessage];
        if (error) {
            NSLog(@"获取优惠券失败：%@",[error description]);
        }
    }];
}
-(void)reloadTableview
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  removeLoadingViewWithView:nil];
    [self.commodityTable reloadData];
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    if (isAlertViewCanShow) {
        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        pAlert.delegate = self;
        [pAlert show];
        pAlert = nil;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CommodityInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分类背景"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 120, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    label.text = @"购买的商品";
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    imageView = nil;
    label = nil;
    return headerView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commoditiesArray count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell = nil;
    cell = [self.commodityTable dequeueReusableCellWithIdentifier:cellIdentifier];
        
    cell.orderNum.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:VCouponNum];
    cell.validityTime.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:VValidityTime];
    cell.couponStatus.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:VCouponStatus];
    cell.couponName.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:VCouponName];
    cell.canUseTime.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:VCanUseTime];
    cell.userMethod.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:VUseMethod];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self fetchDataFromServer];
            break;
        case 0:
//            [self.navigationController popViewControllerAnimated:YES];
        default:
            break;
    }
}
@end
