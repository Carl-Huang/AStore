//
//  OrderDetailViewController.m
//  AStore
//
//  Created by vedon on 27/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "HttpHelper.h"
#import "UIViewController+LeftTitle.h"
#import "GetOrderGoodInfo.h"
#import "OrderDetailCell.h"
#import "GetOrderGiftInfo.h"
#import "GetOrderInfo.h"
typedef NS_ENUM(NSInteger, OrderType)
{
    GoodOrderType = 1,
    GiftOrderType = 2,
};
static NSString * const cellIdentifier = @"cellIdentifier";
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    OrderType type;
}
@end

@implementation OrderDetailViewController
@synthesize orderInfo;
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
    [self setLeftTitle:@"我的订单"];
    [self setBackItem:nil];
    UINib * cellNib = [UINib nibWithNibName:@"OrderDetailCell" bundle:[NSBundle bundleForClass:[OrderDetailCell class]]];
    [self.orderDetailTableview registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //居然根据金额来判断是要获取订单详情，还是赠品详情！！！
    NSInteger money = orderInfo.cost_item.integerValue;
    __weak OrderDetailViewController *weakSelf = self;
    if (money > 2) {
        //获取订单详细信息
        type = GoodOrderType;
        [HttpHelper getOrderDetailWithOrderId:orderInfo.order_id withCompletedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }
            NSArray * array = item;
            if ([array count]) {
                self.dataSource = array;
                [weakSelf.orderDetailTableview reloadData];
            }
        }];
    }else
    {
        //获取赠品详细信息
        type = GiftOrderType;
        [HttpHelper getOrderDetailWithGiftId:orderInfo.order_id withCompletedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }
            NSArray * array = item;
            if ([array count]) {
                self.dataSource = array;
                [weakSelf.orderDetailTableview reloadData];
            }

        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOrderDetailTableview:nil];
    [super viewDidUnload];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    id info = [self.dataSource objectAtIndex:indexPath.row];
    if ([info isKindOfClass:[GetOrderGoodInfo class]]) {
        GetOrderGoodInfo * goodInfo = info;
        cell.name.text = goodInfo.name;
        float floatString = [goodInfo.price floatValue];
        NSString * priceStr = [NSString stringWithFormat:@"￥%0.1f",floatString];
        cell.cost.text = [NSString stringWithFormat:@"销售价 : %@",priceStr];
        cell.quantity.text = [NSString stringWithFormat:@"数量 : %@",goodInfo.nums];
    }else if ([info isKindOfClass:[GetOrderGiftInfo class]])
    {
        GetOrderGiftInfo *giftInfo = info;
        cell.name.text = giftInfo.name;
        cell.cost.text = [NSString stringWithFormat:@"消耗积分 : %@",giftInfo.point];
        cell.quantity.text = [NSString stringWithFormat:@"数量 : %@",giftInfo.nums];
    }
    
    return cell;
}
@end
