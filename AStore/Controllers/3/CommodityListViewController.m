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
static NSString * cellIdentifier = @"commodityListCell";
@interface CommodityListViewController ()
@property (strong ,nonatomic)NSArray * commoditiesArray;
@property (strong ,nonatomic)NSArray * giftArray;

@end

@implementation CommodityListViewController
@synthesize commoditiesArray,giftArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        commoditiesArray = @[@{ProductName: @"果粒橙 500 ml",ProductImage:@"食品logo",ProductNumber:@"12",ProductPrice:@"￥5"}];
        
        giftArray = @[@{ProductName: @"果粒橙 500 ml",ProductImage:@"食品logo",ProductNumber:@"12",ProductPrice:@"￥20"}];

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
    return  30.0;
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
        
        cell.productName.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:ProductName];
        cell.productPrice.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:ProductPrice];
        cell.productQuantity.text = [[commoditiesArray objectAtIndex:indexPath.row]objectForKey:ProductNumber];
        cell.productImage.image = [UIImage imageNamed:[[commoditiesArray objectAtIndex:indexPath.row]objectForKey:ProductImage]];
    }else if(indexPath.section == 1)
    {
        cell.productName.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:ProductName];
        cell.productPrice.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:ProductPrice];
        cell.productQuantity.text = [[giftArray objectAtIndex:indexPath.row]objectForKey:ProductNumber];
        cell.productImage.image =[UIImage imageNamed:[[giftArray objectAtIndex:indexPath.row]objectForKey:ProductImage]];
    }
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
