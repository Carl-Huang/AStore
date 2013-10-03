//
//  MyOrderViewController.m
//  AStore
//
//  Created by vedon on 10/2/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#define VCouponNum          @"couponNumber"
#define VValidityTime       @"validityTime"
#define VCouponName         @"couponName"
#define VCanUseTime         @"canUseTime"
#define VCouponStatus       @"couponStatus"
#define VUseMethod          @"userMethod"


#import "MyCouponViewController.h"
#import "CouponCell.h"
#import "UIViewController+LeftTitle.h"
@interface MyCouponViewController ()
@property (strong ,nonatomic)NSArray * commoditiesArray;
@property (strong ,nonatomic)NSArray * giftArray;
@end

@implementation MyCouponViewController
@synthesize commoditiesArray;
@synthesize giftArray;

 static NSString * cellIdentifier = @"commodityInfoCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        commoditiesArray = @[@{VCouponNum: @"201309111020342",VValidityTime:@"2013/10/11",VCouponName:@"10元优惠券",VCanUseTime:@"2/5",VCouponStatus:@"可用",VUseMethod:@"满20送10元"}];
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


@end
