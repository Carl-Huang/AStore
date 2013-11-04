//
//  CommodityViewController.m
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#define LoginAlertViewTag  3001
#define PutInCarViewAlerViewTag 3002 
#import "CommodityViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "CommodityDesViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "LoginViewController.h"
#import "HttpHelper.h"
#import <objc/runtime.h>
#import "NSMutableArray+SaveCustomiseData.h"
#import "ConfirmOrderViewController.h"
#import "NSString+MD5_32.h"
#import "constants.h"
#import "ProductStoreInfo.h"
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

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [Commodity archivingCommodityArray:myDelegate.commodityArray];
    [NSMutableArray archivingObjArray:myDelegate.commodityArray withKey:@"CommodityArray"];

}
-(void)initializedInterface
{
    NSLog(@"%s",__func__);
    if (comodityInfo) {
        float floatString1 = [comodityInfo.price floatValue];
        NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString1];
        float floatString2 = [comodityInfo.mktprice floatValue];
        NSString * mKPriceStr = [NSString stringWithFormat:@"%.1f",floatString2];
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
            cell.textLabel.text = @"商品详情";
            UIImageView * imageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头@2x"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setFrame:CGRectMake(245, 10, 13, 13)];
            [cell.contentView addSubview:imageView];
            
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            [cell.textLabel setNumberOfLines:2];
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
    
    NSLog(@"%s",__func__);
    //增加判断时候有库存
    [HttpHelper getProductStoreWithProductId:@[self.comodityInfo.product_id] withCompletedBlock:^(id item, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]);
        }
        NSArray *array = item;
        if ([array count]) {
            for (ProductStoreInfo * info in item) {
                NSLog(@"%@",info.store);
                if (info.store.integerValue >0) {
                    NSLog(@"成功加入购物车");
                    
                    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    NSInteger count = 1;
                    BOOL canAddObj = YES;
                    if ([myDelegate.commodityArray count] != 0) {
                        for (int i = 0; i<[myDelegate.commodityArray count] ;i++) {
                            NSMutableDictionary * infoDic = [[myDelegate.commodityArray objectAtIndex:i]mutableCopy];
                            
                            Commodity * info = [infoDic objectForKey:@"commodity"];
                            if ([info.product_id isEqualToString:self.comodityInfo.product_id]) {
                                count = [[infoDic objectForKey:@"count"]integerValue];
                                count ++;
                                infoDic[@"count"] = [NSNumber numberWithInteger:count];
                                [myDelegate.commodityArray replaceObjectAtIndex:i withObject:infoDic];
                                canAddObj = NO;
                            }
                        }
                        if (canAddObj) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:UpdateBadgeViewTitle object:@"puls"];
                            [myDelegate.commodityArray addObject:@{@"commodity": self.comodityInfo,@"count":[NSNumber numberWithInteger:count]}];
                        }
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:UpdateBadgeViewTitle object:@"puls"];
                        [myDelegate.commodityArray addObject:@{@"commodity": self.comodityInfo,@"count":[NSNumber numberWithInteger:1]}];
                        [NSMutableArray archivingObjArray:myDelegate.commodityArray withKey:@"CommodityArray"];
                    }
                    
                    UIAlertView * carAlerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加入购物车成功，去结算？" delegate:self cancelButtonTitle:@"马上" otherButtonTitles:@"再逛逛", nil];
                    carAlerView.tag = PutInCarViewAlerViewTag;
                    [carAlerView show];
                    carAlerView = nil;
                }else
                {
                    UIAlertView * carAlerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"库存不足，加入购物车失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [carAlerView show];
                    carAlerView = nil;
                }
            }

        }else{
            UIAlertView * carAlerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [carAlerView show];
            carAlerView = nil;

        }
        
    }];

}

- (IBAction)buyImmediatelyAction:(id)sender {
    //提交订单

    if ([User isLogin]) {
        [HttpHelper getProductStoreWithProductId:@[self.comodityInfo.product_id] withCompletedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
                return ;
            }
            NSArray *array = item;
            if ([array count]) {
                for (ProductStoreInfo * info in item) {
                    NSLog(@"%@",info.store);
                    if (info.store.integerValue >0) {
                        NSLog(@"成功加入购物车");
                        
                        ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
                        float money = comodityInfo.price.floatValue;
                        [viewController setCommoditySumMoney:money];
                        [viewController setGiftSumMoney:0];
                        
                        [self.navigationController pushViewController:viewController animated:YES];
                        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                        myDelegate.buiedCommodityArray = @[@{@"commodity": comodityInfo,@"count":[NSNumber numberWithInt:1]}];
                        viewController = nil;

                    }else
                    {
                        UIAlertView * carAlerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"库存不足，提交订单失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [carAlerView show];
                        carAlerView = nil;
                    }
                }
            }
        }];

    }else
    {
        
        prompt = [[UIAlertView alloc] initWithTitle:@"请先登陆"
                                                         message:@"\n\n\n"
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Enter", nil];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
        prompt.tag= LoginAlertViewTag;
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
            if (alertView.tag == LoginAlertViewTag) {
                NSLog(@"取消登陆");
                [self hideProcessingView];
            }else if (alertView.tag == PutInCarViewAlerViewTag)
            {
                [self buyImmediatelyAfterPutInCar];
            }
           
            break;
        case 1:
            if (alertView.tag == LoginAlertViewTag) {
                NSLog(@"正在登陆");
                [self loginAction];
            }else if (alertView.tag == PutInCarViewAlerViewTag)
            {
                NSLog(@"再逛逛");
            }
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
    [textField resignFirstResponder];
    [textField2 resignFirstResponder];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    myDelegate.loadingView.labelText = @"正在登陆";
    [myDelegate showLoginViewOnView:self.view];
    [HttpHelper userLoginWithName:textField.text pwd:[NSString md5:textField2.text] completedBlock:^(id items) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
        NSArray * array = items;
        if ([array count]) {
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
        }
    } failedBlock:^(NSError *error) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
    }];
}

-(void)buyImmediatelyAfterPutInCar
{
    if ([User isLogin]) {
        ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        NSInteger money = comodityInfo.price.integerValue;
        [viewController setCommoditySumMoney:money];
        [viewController setGiftSumMoney:0];
        
        [self.navigationController pushViewController:viewController animated:YES];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        myDelegate.buiedCommodityArray = @[@{@"commodity": comodityInfo,@"count":[NSNumber numberWithInt:1]}];
        viewController = nil;
    }else
    {
        prompt = [[UIAlertView alloc] initWithTitle:@"请先登陆"
                                            message:@"\n\n\n"
                                           delegate:nil
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Enter", nil];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
        prompt.tag= LoginAlertViewTag;
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
@end
