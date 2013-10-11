//
//  MyOrderViewController.m
//  AStore
//
//  Created by vedon on 10/2/13.
//  Copyright (c) 2013 carl. All rights reserved.
//




#import "MyOrderViewController.h"
#import "CommodityInfoCell.h"
#import "UIViewController+LeftTitle.h"
#import "constants.h"
#import "HttpHelper.h"
#import "User.h"
#import "GetOrderInfo.h"
#import "GetGiftInfo.h"
@interface MyOrderViewController ()
@property (strong ,nonatomic)NSMutableArray * commoditiesArray;
@property (strong ,nonatomic)NSMutableArray * giftArray;
@end

@implementation MyOrderViewController
@synthesize commoditiesArray;
@synthesize giftArray;

 static NSString * cellIdentifier = @"commodityInfoCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        commoditiesArray = [[NSMutableArray alloc]init];
        giftArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib * cellNib = [UINib nibWithNibName:@"CommodityInfoCell" bundle:[NSBundle bundleForClass:[CommodityInfoCell class]]];
    [self.commodityTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    [self setLeftTitle:@"我的订单"];
    [self setBackItem:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary * userInfoDic = [User getUserInfo];
    NSLog(@"OrderView userInfo :%@",userInfoDic);
    //获取订单
    NSString * cmdStr = [NSString stringWithFormat:@"getOrders=%@",[userInfoDic objectForKey:DMemberId]];
    cmdStr = [SERVER_URL_Prefix stringByAppendingString:cmdStr];
    NSLog(@"cmdStr :%@",cmdStr);
    [HttpHelper requestWithString:cmdStr withClass:[GetOrderInfo class] successBlock:^(NSArray *items) {
        [commoditiesArray addObject:items];
        [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
    } errorBlock:^(NSError *error) {
        ;
    }];
    
    
    //获取赠品
//    NSString * giftStr = [NSString stringWithFormat:@"getGift&&start=0&&count=1"];
//    giftStr = [SERVER_URL_Prefix stringByAppendingString:giftStr];
//    [HttpHelper requestWithString:giftStr withClass:[GetGiftInfo class] successBlock:^(NSArray *items) {
//        [giftArray addObject:items];
//        [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
//    } errorBlock:^(NSError *error) {
//        ;
//    }];

}

-(void)reloadTableview
{
    [self.commodityTable reloadData];
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
    return  40.0;
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
  
    if (section == 0 ) {
        label.text = @"购买的商品";
    } else if(section == 1){
        label.text = @"赠品";
    }
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    imageView = nil;
    label = nil;
    return headerView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [commoditiesArray count];
    }else if(section == 1)
        return [giftArray count];
    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommodityInfoCell *cell = nil;
    cell = [self.commodityTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section == 0) {
        GetOrderInfo * orderInfo = [commoditiesArray objectAtIndex:indexPath.row];
        cell.orderNum.text          = orderInfo.order_id;
        cell.orderTime.text         = orderInfo.acttime;
        cell.orderStatus.text       = orderInfo.status;
        cell.commodityName.text     = orderInfo.tostr;
        cell.commodityMoneySum.text = orderInfo.cost_item;
        cell.sum.text = @"总金额:";
    }else if(indexPath.section == 1)
    {
//        GetGiftInfo * gitfInfo = [giftArray objectAtIndex:indexPath.row];
//        cell.orderNum.text = gitfInfo.gift_id;
//        cell.orderTime.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:VOrderTime];
//        cell.orderStatus.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:VOrderStatus];
//        cell.commodityName.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:VCommodityName];
//        cell.commodityMoneySum.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:VTotalCredits];
//        cell.sum.text = @"所需积分:";
    }
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
