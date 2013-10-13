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
#import "UIImageView+AFNetworking.h"
#import "CommodityDesViewController.h"
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
    [self initializedInterface];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSIndexPath *tableSelection = [self.commodityTableView indexPathForSelectedRow];
    [self.commodityTableView deselectRowAtIndexPath:tableSelection animated:NO];
}
-(void)initializedInterface
{
    NSLog(@"%s",__func__);
    if (comodityInfo) {
        NSString * priceStr = [comodityInfo.price substringToIndex:[comodityInfo.price length] - 2];
        NSString * mKPriceStr = [comodityInfo.mktprice substringToIndex:[comodityInfo.price length] - 2];
        self.costLabel.text = priceStr;
        self.proceLabel.text = mKPriceStr;
        NSString * imageUrlStr = [self extractImageURLWithStr:comodityInfo.small_pic];
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [self.produceImage setImageWithURLRequest:request placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                [self.produceImage setImage:image];
                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               NSLog(@"下载图片失败");
                                           }];

    }
    [self initializeContentview];
}

-(NSString *)extractImageURLWithStr:(NSString *)str
{
    NSString * tempStr = [NSString stringWithFormat:@"%@",str];
    NSRange range = [tempStr rangeOfString:@"|" options:NSCaseInsensitiveSearch];
    NSRange strRange = NSMakeRange(0, range.location);
    return [Resource_URL_Prefix stringByAppendingString:[str substringWithRange:strRange]];
}

-(void)initializeContentview
{
    headerView = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
    //TODO:读取商品分类
    headerView.onLineTextLabel.text = @"原味";
    headerView.offLineTextLabel.text = @"芝士味";
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
    NSLog(@"%@",headerView.onLineTextLabel.text);
    [headerView.offlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];
    [headerView.onlinePayBtn setBackgroundImage:[UIImage imageNamed:@"单选btn-n@2x"] forState:UIControlStateNormal];
    
}

-(void)onlinePayAction:(id)sender
{
    payType = OnlinePaymentType;
    NSLog(@"%@",headerView.offLineTextLabel.text);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView delegate

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
    if ([comodityInfo.pdt_desc isEqualToString:@""]) {
        return 2;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1 || indexPath.section ==2) && indexPath.row ==1) {
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
    
    
    if (indexPath.section == 0) {
        NSString * tempStr = @"所得积分: ";
        NSString * str = [tempStr stringByAppendingString:comodityInfo.score];
        cell.textLabel.text = str;
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"商品信息";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            cell.textLabel.text = comodityInfo.brief;
        }
        
    }else if(indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"请选择口味";
        }else
        {
            [cell.contentView addSubview:headerView];
        }
        
    }
    else
    {
        
        cell.textLabel.text = @"hell";

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        CommodityDesViewController * viewController = [[CommodityDesViewController alloc]initWithNibName:@"CommodityDesViewController" bundle:nil];
        [viewController setComodityInfo:comodityInfo];
        [self.navigationController pushViewController:viewController animated:YES];
        viewController = nil;
    }
}

@end