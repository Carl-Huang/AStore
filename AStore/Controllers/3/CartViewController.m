//
//  CartViewController.m
//  AStore
//
//  Created by Carl on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "CartViewController.h"
#import "UIViewController+LeftTitle.h"
#import "constants.h"
#import "CartCell.h"
#import "CartCellHeader.h"
#import "ConfirmOrderViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Commodity.h"
#import "HttpHelper.h"
#import "UIImageView+AFNetworking.h"
#import "NSMutableArray+SaveCustomiseData.h"
#import "GetGiftInfo.h"
typedef NS_ENUM(NSInteger, ActionType)
{
    PlusAction = 1,
    MinusAction = 2,
};

static NSString * cellIdentifier = @"cartCellIdentifier";
static NSString * cellHeaderIdentifier = @"cartCellHeaderIdentifier";
@interface CartViewController ()
{
    BOOL isSectionOneFirstShow;
    BOOL isSectionTwoFirstShow;
    BOOL isCommodityCheckout;
    BOOL isGiftCheckout;
    NSMutableDictionary * commodityDicInfo;
    NSMutableDictionary * presentDicInfo;
}
@property (strong ,nonatomic)NSArray * dataSource;
@property (strong ,nonatomic)NSArray * giftArray;
@end

@implementation CartViewController
@synthesize dataSource;
@synthesize giftArray;
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
    [self setLeftTitle:@"购物车"];
    UIImage * newItemImg = [UIImage imageNamed:@"删除btn"];
    UIButton * newItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newItemBtn setFrame:CGRectMake(0, 0, newItemImg.size.width, newItemImg.size.height)];
    [newItemBtn setBackgroundImage:newItemImg forState:UIControlStateNormal];
    [newItemBtn setTitle:@"删除" forState:UIControlStateNormal];
    [newItemBtn addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * newItem = [[UIBarButtonItem alloc] initWithCustomView:newItemBtn];
    self.navigationItem.rightBarButtonItem = newItem;
    newItem = nil;
    
    UINib * cellNib = [UINib nibWithNibName:@"CartCell" bundle:[NSBundle bundleForClass:[CartCell class]]];
    [self.cartTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    UINib * cell2Nib = [UINib nibWithNibName:@"CartCellHeader" bundle:[NSBundle bundleForClass:[CartCellHeader class]]];
    [self.cartTable registerNib:cell2Nib forCellReuseIdentifier:cellHeaderIdentifier];
    
    [self.cartTable setEditing:YES];
    
    isSectionTwoFirstShow = YES;
    isSectionOneFirstShow = YES;
    isCommodityCheckout = YES;
    isGiftCheckout = YES;
    commodityDicInfo = [NSMutableDictionary dictionary];
    presentDicInfo = [NSMutableDictionary dictionary];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![User isLogin])
    {
        LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        loginView.view.tag = 1;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        [self.navigationController.view addSubview:loginView.view];
        [self.navigationController addChildViewController:loginView];
    }
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    self.dataSource  = myDelegate.commodityArray;
    self.giftArray = myDelegate.presentArray;
    
    for (int i = 0;  i<dataSource.count; i++) {
         [commodityDicInfo setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",i+1]];
    }
    for (int i = 0;  i<giftArray.count; i++) {
        [presentDicInfo setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",i+1]];
    }
    [self.cartTable reloadData];

}


-(void)deleteItem
{
    NSLog(@"%s",__func__);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)tabImageName
{
	return @"购物车icon-n";
}

- (void)viewDidUnload {
    [self setCartTable:nil];
    [super viewDidUnload];
}


//获取订单中的物品
-(NSArray *)getCommodityProduct
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < [self.dataSource count];i++) {
        NSDictionary * dic =  [self.dataSource objectAtIndex:i];
        Commodity *com = [dic objectForKey:@"commodity"];
        if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
            [array addObject:com];
        }
    }
    return array;
}

-(NSArray *)getGiftProduct
{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < [self.giftArray count];i++) {
        NSDictionary * dic =  [self.giftArray objectAtIndex:i];
        GetGiftInfo *gift = [dic objectForKey:@"present"];
        if ([[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
            [array addObject:gift];
        }
    }
    return array;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        if (indexPath.section == 0) {
            BOOL bo = (BOOL)[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            [commodityDicInfo setObject:[NSNumber numberWithBool:!bo] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        }
        if (indexPath.section == 1) {
            BOOL bo = (BOOL)[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            [presentDicInfo setObject:[NSNumber numberWithBool:!bo] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];

        }
    }else
    {
        if (indexPath.section == 0) {
            isCommodityCheckout  = !isCommodityCheckout;
            isSectionOneFirstShow = !isSectionOneFirstShow;
        }else
        {
            isGiftCheckout = !isGiftCheckout;
            isSectionTwoFirstShow = !isSectionTwoFirstShow;
        }
        [tableView reloadData];
 
    }
    //    CommodityInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 45.0;
    }
    return 83.0;
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
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
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
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSLog(@"section0 have %d rows",[dataSource count]+1);
        return [dataSource count]+1;
    }else if(section == 1)
        NSLog(@"section1 have %d rows",[giftArray count]+1);
        return [giftArray count]+1;
    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell * cell = [self.cartTable dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    [cell setMunisBlock:[self cellMinusBlock]];
    [cell setPlusBlock:[self cellPlusBlock]];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CartCellHeader *headerCell = [self.cartTable dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
            headerCell.sumLabel.text = @"总额:";
            float sum = 0.0;
            for (int i = 0;i < dataSource.count;i++) {
                NSDictionary  * infoDic = [dataSource objectAtIndex:i];
                Commodity * info = [infoDic objectForKey:@"commodity"];
                NSInteger num = [[infoDic objectForKey:@"count"]integerValue];
                float price = [info.price floatValue];
                if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
                    sum += price*num;
                }
            }
            headerCell.moneyValue.text = [NSString stringWithFormat:@"%.1f",sum];
            [headerCell.closeAccountBtn addTarget:self action:@selector(closeAccount) forControlEvents:UIControlEventTouchUpInside];
            [headerCell setSelected:isCommodityCheckout animated:YES];
            return headerCell;
            
        }else
        {
            NSInteger row = indexPath.row -1;
            NSDictionary * dic = [dataSource objectAtIndex:row];
            NSNumber * produceNum = [dic objectForKey:@"count"];
            Commodity * info = [dic objectForKey:@"commodity"];
            NSString * imageUrlStr = [HttpHelper extractImageURLWithStr:info.small_pic];
            __weak CartCell *weakCell = cell;
            NSURL *url = [NSURL URLWithString:imageUrlStr];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            [cell.productImage setImageWithURLRequest:request placeholderImage:nil
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        [weakCell.productImage setImage:image];
                                                        [weakCell setNeedsLayout];
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                        NSLog(@"下载图片失败");
                                                    }];
            cell.type = CommodityCellType;
            cell.Id = info.product_id;
            cell.productName.text = info.name;
            cell.productNumber.text = [NSString stringWithFormat:@"%@",produceNum];
            float floatString = [info.price floatValue];
            NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
            
            //金额
            cell.MoneySum.text = priceStr;
            [cell.jifenLabel setHidden:YES];
            [cell.jifen setHidden:YES];
//            if (isSectionOneFirstShow) {
//                if (indexPath.row == [self.dataSource count]) {
//                    isSectionOneFirstShow = NO;
//                }
//                [commodityDicInfo setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
//            }
            if ([commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                [cell setSelected:isCommodityCheckout animated:YES];
            }
        }

    }else
    {
        if (indexPath.row == 0) {
            CartCellHeader *headerCell = [self.cartTable dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
            headerCell.sumLabel.text = @"积分:";
            headerCell.moneyValue.text = @"1000";
            float sum = 0;
            for (NSDictionary  * infoDic in giftArray) {
                GetGiftInfo * info = [infoDic objectForKey:@"present"];
                NSInteger num = [[infoDic objectForKey:@"count"]integerValue];
                float price = [info.point floatValue];
                sum += price*num;
            }
             headerCell.moneyValue.text = [NSString stringWithFormat:@"%.1f",sum];
            [headerCell.closeAccountBtn addTarget:self action:@selector(closeAccount) forControlEvents:UIControlEventTouchUpInside];
            [headerCell setSelected:isGiftCheckout animated:YES];
            return headerCell;
        }else
        {
            [cell.jifenLabel setHidden:NO];
            [cell.jifen setHidden:NO];
            NSInteger row = indexPath.row -1;
            NSDictionary * dic = [giftArray objectAtIndex:row];
            NSNumber * produceNum = [dic objectForKey:@"count"];
            GetGiftInfo * info = [dic objectForKey:@"present"];
            NSString * imageUrlStr = [HttpHelper extractImageURLWithStr:info.small_pic];
            __weak CartCell *weakCell = cell;
            NSURL *url = [NSURL URLWithString:imageUrlStr];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            [cell.productImage setImageWithURLRequest:request placeholderImage:nil
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  [weakCell.productImage setImage:image];
                                                  [weakCell setNeedsLayout];
                                              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"下载图片失败");
                                              }];
            cell.type = PresentCellType;
            cell.Id = info.gift_id;
            cell.productName.text = info.name;
            cell.productNumber.text = [NSString stringWithFormat:@"%@",produceNum];
            float floatString = [info.point floatValue];
            //积分
            NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
            cell.jifen.text = priceStr;
            //限量
            NSString * str = [NSString stringWithFormat:@"限量:%@",info.limit_num];
            cell.MoneySum.text = str;
//            if (isSectionTwoFirstShow) {
//                if (indexPath.row == [self.giftArray count]) {
//                    isSectionTwoFirstShow = NO;
//                }
//                [presentDicInfo setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
//            }
            if ([presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                [cell setSelected:YES animated:YES];
            }

        }

    }
   
    return  cell;
}

-(CarCellMinusBlock)cellMinusBlock
{
    CarCellMinusBlock block = ^(id item,CellType type)
    {
        NSLog(@"%s",__func__);
        if (type == CommodityCellType) {
             [self alterCommodityNumWithId:(NSString *)item withAction:MinusAction];
        }else
        {
            [self alterPresentNumWithId:(NSString *)item withAction:MinusAction];
        }
    };
    return block;
}

-(CarCellPlusBlock)cellPlusBlock
{
    CarCellPlusBlock block = ^(id item,CellType type)
    {
        NSLog(@"%s",__func__);
        if (type == CommodityCellType) {
            [self alterCommodityNumWithId:(NSString *)item withAction:PlusAction];
        }else
        {
            [self alterPresentNumWithId:(NSString *)item withAction:PlusAction];
        }
    };
    return block;
}

-(void)alterCommodityNumWithId:(NSString * )productId withAction:(NSInteger)action
{
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    for (int i = 0;i<[myDelegate.commodityArray count];i++) {
        NSMutableDictionary * dic = [[myDelegate.commodityArray objectAtIndex:i]mutableCopy];
        Commodity * info = [dic objectForKey:@"commodity"];
        if ([productId isEqualToString:info.product_id] ) {
            if (action == MinusAction) {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                if (num == 1) {
                    //当货物数量到0件时，删除该数据
                    [myDelegate.commodityArray removeObjectAtIndex:i];
                     [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
                    [self.cartTable reloadData];
                    return;
                }else
                {
                    //减少货物数量
                    num -= 1;
                    dic[@"count"] = [NSNumber numberWithInteger:num];
                    [myDelegate.commodityArray replaceObjectAtIndex:i withObject:dic];
                }
                               
            }else
            {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                num += 1;
                dic[@"count"] = [NSNumber numberWithInteger:num];
                [myDelegate.commodityArray replaceObjectAtIndex:i withObject:dic];
            }
            [NSMutableArray archivingObjArray:myDelegate.commodityArray withKey:@"CommodityArray"];
            [self.cartTable beginUpdates];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable endUpdates];
        }
    }
}


-(void)alterPresentNumWithId:(NSString * )productId withAction:(NSInteger)action
{
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    for (int i = 0;i<[myDelegate.presentArray count];i++) {
        NSMutableDictionary * dic = [[myDelegate.presentArray objectAtIndex:i]mutableCopy];
        GetGiftInfo * info = [dic objectForKey:@"present"];
        if ([productId isEqualToString:info.gift_id] ) {
            if (action == MinusAction) {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                if (num == 1) {
                    //当货物数量到0件时，删除该数据
                    [myDelegate.presentArray removeObjectAtIndex:i];
                     [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
                    [self.cartTable reloadData];
                    return;
                }else
                {
                    //减少货物数量
                    num -= 1;
                    dic[@"count"] = [NSNumber numberWithInteger:num];
                    [myDelegate.presentArray replaceObjectAtIndex:i withObject:dic];
                }
                
            }else
            {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                num += 1;
                dic[@"count"] = [NSNumber numberWithInteger:num];
                [myDelegate.presentArray replaceObjectAtIndex:i withObject:dic];
            }
            [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
            [self.cartTable beginUpdates];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i+1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable endUpdates];
        }
    }
}

-(void)closeAccount
{
    NSLog(@"%s",__func__);
    ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
@end
