//
//  CommodityViewController.m
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "CommodityViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HeaderView.h"

typedef NS_ENUM(NSInteger, PaymentType)
{
    OnlinePaymentType = 1,
    OfflinePaymentType,
};
static NSString * cellIdentifier = @"cellIdentifier";
@interface CommodityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (assign ,nonatomic)  PaymentType payType;
@property (strong ,nonatomic)  HeaderView * headerView;
@end

@implementation CommodityViewController
@synthesize comodityInfo;
@synthesize payType;
@synthesize headerView;

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
    [self setLeftTitle:comodityInfo.name];
    [self setBackItem:nil];
    self.commodityTableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row ==1) {
        return 50;
    }else
    {
        return 35;
    }
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = @"hell";
    return cell;
}

-(void)contentSubView
{
    headerView = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
    [headerView.offlinePayBtn addTarget:self action:@selector(offlinePayAction:) forControlEvents:UIControlEventTouchUpInside];
    //默认为货到付款
    payType = OfflinePaymentType;
    [headerView.offlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];
    [headerView.onlinePayBtn addTarget:self action:@selector(onlinePayAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView setBackgroundColor:[UIColor whiteColor]];

}

-(void)offlinePayAction:(id)sender
{
    
    payType = OfflinePaymentType;
    NSLog(@"货到付款");
    [headerView.offlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];
    [headerView.onlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-n@2x"] forState:UIControlStateNormal];
    
}

-(void)onlinePayAction:(id)sender
{
    payType = OnlinePaymentType;
    NSLog(@"在线付款");
    [headerView.offlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-n@2x"] forState:UIControlStateNormal];
    [headerView.onlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];
    NSLog(@"%s",__func__);
}

- (void)viewDidUnload {
    [self setCostLabel:nil];
    [self setProceLabel:nil];
    [self setCommodityTableView:nil];
    [self setProduceImage:nil];
    [super viewDidUnload];
}
@end
