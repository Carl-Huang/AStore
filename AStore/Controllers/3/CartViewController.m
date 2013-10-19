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
#import <objc/runtime.h>
static NSString * cellIdentifier = @"cartCellIdentifier";
static NSString * cellHeaderIdentifier = @"cartCellHeaderIdentifier";
@interface CartViewController ()
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
        dataSource = @[@{ProductName: @"果粒橙 500 ml",ProductImage:@"食品logo",ProductNumber:@"12",ProductPrice:@"5"}];
        
        giftArray = @[@{ProductName: @"果粒橙 500 ml",ProductImage:@"食品logo",ProductNumber:@"12",ProductPrice:@"限量:20",JiFen:@"1000"}];
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CartCellHeader *headerCell = [self.cartTable dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
            headerCell.sumLabel.text = @"总额:";
            float sum = 0;
            for (NSDictionary  * infoDic in dataSource) {
                Commodity * info = [infoDic objectForKey:@"commodity"];
                NSInteger num = [[infoDic objectForKey:@"count"]integerValue];
                float price = [info.price floatValue];
                sum += price*num;
            }
            headerCell.moneyValue.text = [NSString stringWithFormat:@"%.1f",sum];
            [headerCell.closeAccountBtn addTarget:self action:@selector(closeAccount) forControlEvents:UIControlEventTouchUpInside];
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

            cell.productName.text = info.name;
            cell.productNumber.text = [NSString stringWithFormat:@"%@",produceNum];
            float floatString = [info.price floatValue];
            NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
            cell.MoneySum.text = priceStr;
            [cell.jifenLabel setHidden:YES];
            [cell.jifen setHidden:YES];
            NSNumber * number = objc_getAssociatedObject(info, (__bridge const void *)(info.product_id));
            NSLog(@"%d",[number intValue]);
            
        }

    }else
    {
        if (indexPath.row == 0) {
            CartCellHeader *headerCell = [self.cartTable dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
            headerCell.sumLabel.text = @"积分:";
            headerCell.moneyValue.text = @"1000";
            [headerCell.closeAccountBtn addTarget:self action:@selector(closeAccount) forControlEvents:UIControlEventTouchUpInside];
            return headerCell;
        }else
        {
            NSInteger row = indexPath.row -1;
            cell.productImage.image = [UIImage imageNamed:[[giftArray objectAtIndex:row]objectForKey:ProductImage]];
            cell.productName.text = [[giftArray objectAtIndex:row]objectForKey:ProductName];
            cell.productNumber.text = [[giftArray objectAtIndex:row]objectForKey:ProductNumber];
            cell.MoneySum.text = [[giftArray objectAtIndex:row]objectForKey:ProductPrice];
            [cell.jifenLabel setHidden:NO];
            cell.jifen.text = [[giftArray objectAtIndex:row]objectForKey:JiFen];
        }

    }
    return  cell;
}


-(void)closeAccount
{
    NSLog(@"%s",__func__);
    ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}
@end
