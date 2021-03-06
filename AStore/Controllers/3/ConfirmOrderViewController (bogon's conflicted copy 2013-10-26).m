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
#import "CommodityListViewController.h"
#import "AppDelegate.h"
#import "AKTabBarController.h"
#import "DeliveryTypeInfo.h"
#import "MyAddressViewController.h"
#import "AddressInfo.h"
#import "User.h"
#import "HttpHelper.h"
#import "Commodity.h"
typedef NS_ENUM(NSInteger, PaymentType)
{
    OnlinePaymentType = 1,
    OfflinePaymentType,
};
@interface ConfirmOrderViewController ()
{
    
    DeliveryTypeInfo * deliveryTypeInfo; //配送方式
    AddressInfo * addressTypeInfo;       //个人地址信息
    
}
@property (strong ,nonatomic)NSArray * dataSource;
@property (assign ,nonatomic)BOOL isCheck;
@property (assign ,nonatomic)PaymentType payType;
@property (strong ,nonatomic)HeaderView * headerView;
@end

@implementation ConfirmOrderViewController
@synthesize dataSource;
@synthesize isCheck;
@synthesize headerView;
@synthesize payType;
@synthesize commoditySumMoney;
@synthesize giftSumMoney;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataSource = @[@"收货人信息",@"付款方式",@"配送方式",@"查看商品清单"];
        isCheck   = NO;

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
    sumLabel.text = [NSString stringWithFormat:@"应付总额:￥%d",commoditySumMoney];
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
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSInteger totalWeight = 0;
    NSInteger totalCommodityNum = 0;
    NSInteger totalPoint = 0;
    NSMutableArray * commodityArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in myDelegate.buiedCommodityArray) {
        Commodity * info = [dic objectForKey:@"commodity"];
        NSInteger tempCount = [[dic objectForKey:@"count"]integerValue];
        NSInteger tempWeight = tempCount*info.weight.integerValue;
        totalWeight += tempWeight;
        totalCommodityNum += tempCount;
        totalPoint += info.score.integerValue;
        [commodityArray addObject:dic];
    }
    

    [myDelegate showLoginViewOnView:self.view];
    __weak ConfirmOrderViewController * weakSelf = self;
    [HttpHelper postOrderWithUserInfo:nil
                         deliveryType:deliveryTypeInfo
                               Weight: [NSString stringWithFormat:@"%d",totalWeight]
                                tostr:@""
                           productNum:[NSString stringWithFormat:@"%d",totalCommodityNum]
                              address:addressTypeInfo
                    totalProuctMomeny:[NSString stringWithFormat:@"%d",commoditySumMoney]
                         deliveryCost:@"0"
                             getPoint:[NSString stringWithFormat:@"%d",totalPoint]
                           totalMoney:[NSString stringWithFormat:@"%d",commoditySumMoney]
                                 memo:@"请快点送货"
                   withCommodityArray:commodityArray withCompletedBlock:^(id item, NSError *error) {
                       if (error) {
                           NSLog(@"%@",[error description]);
                       }
                       NSString * str = [[item objectAtIndex:0]objectForKey:RequestStatusKey];
                       
                       if ([str isEqualToString:@"1"]) {
                           NSLog(@"提交订单成功");
                           [weakSelf cleanUserDefaulstSetting];
                           //清除NSUserDefaults 数据
                           
                       }else
                       {
                           NSLog(@"提交订单失败");
                           [myDelegate removeLoadingViewWithView:nil];
                           [weakSelf showAlertViewWithTitle:@"提示" message:@"提交订单失败"];
                           
                       }

    }];
}

-(void)cleanUserDefaulstSetting
{
    //DeliveryViewController
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectDeliveryTag"];
    
    //MyAddressViewController中的关键字
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectTag"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
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


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"deliveryMethod"]) {
        //获取配送方式
        deliveryTypeInfo = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"%@",deliveryTypeInfo.dt_name);
    }else if ([keyPath isEqual:@"selectAddressInfo"])
    {
        //获取地址信息
        addressTypeInfo = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"%@",addressTypeInfo.addr);
    }
}
#pragma mark - UITableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowIndex = indexPath.row+indexPath.section*2;
    switch (rowIndex) {
        case 0:
            [self pushMyAddressViewController];
            break;
        case 1:
            
            break;
        case 2:
            [self pushDeliveryViewController];
            break;
        case 3:
            [self pushCommodityListViewcontroller];
            break;
            
        default:
            break;
    }
}

-(void)pushDeliveryViewController
{
    DeliveryViewController * viewcontroller = [[DeliveryViewController alloc]initWithNibName:@"DeliveryViewController" bundle:nil];
    [viewcontroller addObserver:self forKeyPath:@"deliveryMethod" options:NSKeyValueObservingOptionNew context:NULL];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}

-(void)pushCommodityListViewcontroller
{
    CommodityListViewController * viewcontroller = [[CommodityListViewController alloc]initWithNibName:@"CommodityListViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    viewcontroller = nil;
}

-(void)pushMyAddressViewController
{
    MyAddressViewController * viewController = [[MyAddressViewController alloc]initWithNibName:@"MyAddressViewController" bundle:nil];
    NSDictionary * localUserData = [User getUserInfo];
    NSString * str = [NSString stringWithFormat:@"%@",[localUserData objectForKey:@"area"]];
    if (![str isEqualToString:@"<null>"]) {
        NSLog(@"%@",str);
    }
    [viewController setMemberId:[localUserData objectForKey:DMemberId]];
    [viewController addObserver:self forKeyPath:@"selectAddressInfo" options:NSKeyValueObservingOptionNew context:NULL];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        headerView = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
        [headerView.offlinePayBtn addTarget:self action:@selector(offlinePayAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认为货到付款
        payType = OfflinePaymentType;
        [headerView.offlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];
        [headerView.onlinePayBtn addTarget:self action:@selector(onlinePayAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
    if (indexPath.row+2*indexPath.section != 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
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

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    pAlert.delegate = self;
    [pAlert show];
    pAlert = nil;
}
@end
