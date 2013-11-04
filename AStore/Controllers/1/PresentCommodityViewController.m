//
//  PresentCommodityViewController.m
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
#define LoginAlertViewTag  3001
#define PutInCarViewAlerViewTag 3002

#import "PresentCommodityViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "User.h"
#import "LoginViewController.h"
#import "HttpHelper.h"
#import "GetGiftInfo.h"
#import "PresentCommodityDesViewController.h"
#import "NSMutableArray+SaveCustomiseData.h"
#import "ConfirmOrderViewController.h"
#import "GiftStoreInfo.h"
typedef NS_ENUM(NSInteger, PaymentType)
{
    OnlinePaymentType = 1,
    OfflinePaymentType,
};
static NSString * cellIdentifier = @"cellIdentifier";
@interface PresentCommodityViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITextField *textField;
    UITextField *textField2;
    UIAlertView *prompt;
}
@property (assign ,nonatomic)  PaymentType payType;
@property (strong ,nonatomic)  HeaderView * headerView;
@end

@implementation PresentCommodityViewController
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
    self.commodityTableView.backgroundColor = [UIColor clearColor];
    
    
    UIImage * exchangeBtnImage = [UIImage imageNamed:@"删除btn"];
    UIButton * exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeBtn setFrame:CGRectMake(0, 0, exchangeBtnImage.size.width, exchangeBtnImage.size.height)];
    [exchangeBtn setBackgroundImage:exchangeBtnImage forState:UIControlStateNormal];
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeItem) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem * exchangeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:exchangeBtn];
    
    UIImage *backImg = [UIImage imageNamed:@"返回btn"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.rightBarButtonItems = @[backItem];
    [self initializedInterface];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSIndexPath *tableSelection = [self.commodityTableView indexPathForSelectedRow];
    [self.commodityTableView deselectRowAtIndexPath:tableSelection animated:NO];
}


-(void)exchangeItem
{
    NSLog(@"%s",__func__);
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSInteger count = 1;
    BOOL canAddObj = YES;
    if ([myDelegate.presentArray count] != 0) {
        for (int i = 0; i<[myDelegate.presentArray count] ;i++) {
            NSMutableDictionary * infoDic = [[myDelegate.presentArray objectAtIndex:i]mutableCopy];
            
            GetGiftInfo * info = [infoDic objectForKey:@"present"];
            if ([info.gift_id isEqualToString:self.comodityInfo.gift_id]) {
                count = [[infoDic objectForKey:@"count"]integerValue];
                count ++;
                infoDic[@"count"] = [NSNumber numberWithInteger:count];
                [myDelegate.presentArray replaceObjectAtIndex:i withObject:infoDic];
                canAddObj = NO;
            }
        }
        if (canAddObj) {
            [myDelegate.presentArray addObject:@{@"present": self.comodityInfo,@"count":[NSNumber numberWithInteger:count]}];
        }
    }else
    {
        [myDelegate.presentArray addObject:@{@"present": self.comodityInfo,@"count":[NSNumber numberWithInteger:1]}];
        [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
    }
}

-(void)pushBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initializedInterface
{
    NSLog(@"%s",__func__);
    if (comodityInfo) {
        float floatString1 = [comodityInfo.point floatValue];
        NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString1];
        //TODO:获取会员总积分
//        float floatString2 = [comodityInfo.mktprice floatValue];
//        NSString * mKPriceStr = [NSString stringWithFormat:@"%.1f",floatString2];
        self.costLabel.text = priceStr;
        self.proceLabel.text = comodityInfo.limit_num;
        NSString * imageUrlStr = [HttpHelper extractImageURLWithStr:comodityInfo.small_pic];
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [self.produceImage setImageWithURLRequest:request placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                [self.produceImage setImage:image];
                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               NSLog(@"下载图片失败");
                                           }];

    }
}

- (void)viewDidUnload {
    [self setCostLabel:nil];
    [self setProceLabel:nil];
    [self setCommodityTableView:nil];
    [self setProduceImage:nil];
    [self setPutInCarBtn:nil];
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
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 3;
//            break;
//        default:
//            return 1;
//            break;
//    }
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
//    if (indexPath.section == 0 && indexPath.row ==0) {
//        NSString * tempStr = @"库存数量: ";
//        NSString * str = [tempStr stringByAppendingString:comodityInfo.storage];
//        cell.textLabel.text = str;
//    }else if (indexPath.section == 1)
//    {
//        NSInteger row = indexPath.row;
//        if (row == 0) {
//            cell.textLabel.text = @"赠品详情";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }else if(row == 1)
//        {
//            cell.textLabel.text = comodityInfo.intro;
//           
//        }else if(row == 2)
//        {
//            NSString * tempStr = @"库存: ";
//            NSString * str = [tempStr stringByAppendingString:comodityInfo.storage];
//            cell.textLabel.text = str;
//        }else if(row == 3)
//        {
//            NSString * tempStr = @"截止时间: ";
//            NSString * str = [tempStr stringByAppendingString:comodityInfo.limit_end_time];
//            cell.textLabel.text = str;
//        }else if(row == 4)
//        {
//            
//        }
//        
//    }
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"赠品详情";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(row == 1)
    {
        cell.textLabel.text = comodityInfo.intro;
        
    }else if(row == 2)
    {
        NSString * tempStr = @"库存: ";
        NSString * str = [tempStr stringByAppendingString:comodityInfo.storage];
        cell.textLabel.text = str;
    }else if(row == 3)
    {
        NSString * tempStr = @"截止时间: ";
        NSString * str = [tempStr stringByAppendingString:comodityInfo.limit_end_time];
        cell.textLabel.text = str;
    }else if(row == 4)
    {
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PresentCommodityDesViewController * viewController = [[PresentCommodityDesViewController alloc]initWithNibName:@"PresentCommodityDesViewController" bundle:nil];
        [viewController setComodityInfo:comodityInfo];
        [self.navigationController pushViewController:viewController animated:YES];
        viewController = nil;
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
    [HttpHelper userLoginWithName:textField.text pwd:textField2.text completedBlock:^(id items) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
        if ([items count]) {
            for (NSDictionary * dic in items) {
                if ([dic count]==1) {
                    NSLog(@"登陆失败");
                    [prompt show];
                }else
                {
                    NSLog(@"登陆成功");
                    [User saveUserInfo:textField.text password:textField2.text memberId:@"0000"];
                }
            }
        }

    } failedBlock:^(NSError *error) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
    }];
}
- (IBAction)putInCarAction:(id)sender {
    NSLog(@"%s",__func__);
    //判断时候有库存
    [HttpHelper getGiftStoreWithGiftId:@[self.comodityInfo.gift_id] withCompletedBlock:^(id item, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]);
        }
        NSArray *array = item;
        if ([array count]) {
            AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            for (GiftStoreInfo * info in item) {
                NSLog(@"%@",info.storage);
                
                
                //判断是否超过限额和库存
                BOOL isReachtStoreNum = YES;
                if ([myDelegate.presentArray count]) {
                    for (NSDictionary * dic in myDelegate.presentArray) {
                        GetGiftInfo * presentInfo = dic[@"present"];
                        if ([presentInfo.gift_id isEqualToString:self.comodityInfo.gift_id]) {
                            if (info.storage.integerValue <= [dic[@"count"]integerValue]||presentInfo.limit_num.integerValue <=[dic[@"count"]integerValue]) {
                                isReachtStoreNum  = NO;
                            }
                        }
                    }

                }
                if (info.storage.integerValue > 0&&isReachtStoreNum) {
                    
                    NSInteger count = 1;
                    BOOL canAddObj = YES;
                    if ([myDelegate.presentArray count] != 0) {
                        for (int i = 0; i<[myDelegate.presentArray count] ;i++) {
                            NSMutableDictionary * infoDic = [[myDelegate.presentArray objectAtIndex:i]mutableCopy];
                            
                            GetGiftInfo * info = [infoDic objectForKey:@"present"];
                            if ([info.gift_id isEqualToString:self.comodityInfo.gift_id]) {
                                count = [[infoDic objectForKey:@"count"]integerValue];
                                count ++;
                                infoDic[@"count"] = [NSNumber numberWithInteger:count];
                                [myDelegate.presentArray replaceObjectAtIndex:i withObject:infoDic];
                                canAddObj = NO;
                            }
                        }
                        if (canAddObj) {
//                             [[NSNotificationCenter defaultCenter]postNotificationName:UpdateBadgeViewTitle object:@"puls"];
                            [myDelegate.presentArray addObject:@{@"present": self.comodityInfo,@"count":[NSNumber numberWithInteger:count]}];
                        }
                    }else
                    {
                         [[NSNotificationCenter defaultCenter]postNotificationName:UpdateBadgeViewTitle object:@"puls"];
                        [myDelegate.presentArray addObject:@{@"present": self.comodityInfo,@"count":[NSNumber numberWithInteger:1]}];
                        [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
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

- (IBAction)exchangeImmediately:(id)sender {
    if ([User isLogin]) {
        
        [HttpHelper getGiftStoreWithGiftId:@[self.comodityInfo.gift_id] withCompletedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }
            NSArray *array = item;
            if ([array count]) {
                for (GiftStoreInfo * info in item) {
                    NSLog(@"%@",info.storage);
                    if (info.storage.integerValue > 0) {
                        ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
                        NSInteger point = comodityInfo.point.integerValue;
                        [viewController setCommoditySumMoney:0];
                        [viewController setGiftSumMoney:point];
                        
                        [self.navigationController pushViewController:viewController animated:YES];
                        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                        myDelegate.buiedPresentArray = @[@{@"present": comodityInfo,@"count":[NSNumber numberWithInt:1]}];
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
        prompt.tag = LoginAlertViewTag;
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

-(void)buyImmediatelyAfterPutInCar
{
    if ([User isLogin]) {
        //清空购物车信息
        ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        NSInteger point = comodityInfo.point.integerValue;
        [viewController setCommoditySumMoney:0];
        [viewController setGiftSumMoney:point];
        
        [self.navigationController pushViewController:viewController animated:YES];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        myDelegate.buiedPresentArray = @[@{@"present": comodityInfo,@"count":[NSNumber numberWithInt:1]}];
        viewController = nil;
    }else
    {
        prompt = [[UIAlertView alloc] initWithTitle:@"请先登陆"
                                            message:@"\n\n\n"
                                           delegate:nil
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Enter", nil];
        prompt.tag = LoginAlertViewTag;
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
@end
