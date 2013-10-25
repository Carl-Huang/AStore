//
//  CommodityListViewController.m
//  AStore
//
//  Created by vedon on 10/4/13.
//  Copyright (c) 2013 carl. All rights reserved.
//



#import "CommodityListViewController.h"
#import "UIViewController+LeftTitle.h"
#import "CommodityListCell.h"
#import "constants.h"
#import "Commodity.h"
#import "AppDelegate.h"
#import "GetGiftInfo.h"
#import "HttpHelper.h"
#import "UIImageView+AFNetworking.h"
static NSString * cellIdentifier = @"commodityListCell";
@interface CommodityListViewController ()


@end

@implementation CommodityListViewController
@synthesize commoditiesArray,giftArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        commoditiesArray = @[@{ProductName: @"果粒橙 500 ml",ProductImage:@"食品logo",ProductNumber:@"12",ProductPrice:@"￥5"}];
//        
//        giftArray = @[@{ProductName: @"果粒橙 500 ml",ProductImage:@"食品logo",ProductNumber:@"12",ProductPrice:@"￥20"}];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"查看商品清单"];
    [self setBackItem:nil];
    
    UINib * cellNib = [UINib nibWithNibName:@"CommodityListCell" bundle:[NSBundle bundleForClass:[CommodityListCell class]]];
    [self.commodityListTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (myDelegate.buiedCommodityArray) {
        self.commoditiesArray = myDelegate.buiedCommodityArray;
    }
    if (myDelegate.buiedPresentArray) {
        self.giftArray = myDelegate.buiedPresentArray;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCommodityListTable:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  45.0;
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
    CommodityListCell *cell = nil;
    cell = [self.commodityListTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 0) {
        NSDictionary * dic = [self.commoditiesArray objectAtIndex:indexPath.row];
        Commodity * info = [dic objectForKey:@"commodity"];
        cell.productName.text = info.name;
        float floatString = [info.price floatValue];
        NSString * priceStr = [NSString stringWithFormat:@"￥%.1f",floatString];
        cell.productPrice.text = priceStr;
        NSString * imageStr = [HttpHelper extractImageURLWithStr:info.small_pic];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        //Set the items
        __weak  CommodityListCell *weakCell = cell;
        [weakCell.productImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakCell.productImage setImage:image];
            [weakCell setNeedsLayout];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ;
        }];
        
        cell.productQuantity.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    }else if(indexPath.section == 1)
    {
        NSDictionary * dic = [self.giftArray objectAtIndex:indexPath.row];
        GetGiftInfo * info = [dic objectForKey:@"present"];
        cell.productName.text = info.name;
        cell.productPrice.text = info.point;
        cell.productQuantity.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
        cell.productImage.image =[UIImage imageNamed:[[giftArray objectAtIndex:indexPath.row]objectForKey:ProductImage]];
        NSString * imageStr = [HttpHelper extractImageURLWithStr:info.small_pic];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        __weak  CommodityListCell *weakCell = cell;
        [weakCell.productImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakCell.productImage setImage:image];
            [weakCell setNeedsLayout];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ;
        }];
//        cell.productName.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:ProductName];
//        cell.productPrice.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:ProductPrice];
//        cell.productQuantity.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:ProductNumber];
//        cell.productImage.image =[UIImage imageNamed:[[giftArray objectAtIndex:indexPath.row]objectForKey:ProductImage]];
    }
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
