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
#import "AppDelegate.h"
#import "User.h"
#import "LoginViewController.h"
#import "HttpHelper.h"
typedef NS_ENUM(NSInteger, PaymentType)
{
    OnlinePaymentType = 1,
    OfflinePaymentType,
};
static NSString * cellIdentifier = @"cellIdentifier";
@interface CommodityViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITextField *textField;
    UITextField *textField2;
    UIAlertView *prompt;
}
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
    NSLog(@"pdt_desc :%@" ,comodityInfo.pdt_desc);
    NSLog(@"spec: %@" ,comodityInfo.spec);
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

- (IBAction)putInCartAction:(id)sender {
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate.commodityArray addObject:self.comodityInfo];
    NSLog(@"购物车里物品数量：%d",[myDelegate.commodityArray count]);
}

- (IBAction)buyImmediatelyAction:(id)sender {
    //提交订单
    if ([User isLogin]) {
        //清空购物车信息
        [Commodity removeCommodityArray];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate.commodityArray removeAllObjects];
    }else
    {
        prompt = [[UIAlertView alloc] initWithTitle:@"请先登陆"
                                                         message:@"\n\n\n"
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Enter", nil];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setPlaceholder:@"username"];
        [prompt addSubview:textField];
        textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
        [textField2 setBackgroundColor:[UIColor whiteColor]];
        [textField2 setPlaceholder:@"password"];
        [textField2 setSecureTextEntry:YES];
        [prompt addSubview:textField2];
        prompt.delegate = self;
        [prompt show];
      
    }
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消登陆");
            [self hideProcessingView];
            break;
        case 1:
            NSLog(@"正在登陆");
            [self loginAction];
            break;
        default:
            break;
    }
}

-(void)hideProcessingView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
}

-(void)loginAction
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.loadingView.labelText = @"正在登陆";
    [myDelegate showLoginViewOnView:self.view];
    [HttpHelper userLoginWithName:textField.text pwd:textField2.text completedBlock:^(id items) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
        for (NSDictionary * dic in items) {
            if ([dic count]==1) {
                NSLog(@"登陆失败");
                [prompt show];
            }else
            {
                NSLog(@"登陆成功");
                [User saveUserInfo:textField.text password:textField2.text memberId:@"0000"];
                //TODO:去到订单页面
                
            }
        }
    } failedBlock:^(NSError *error) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
    }];
}
@end
