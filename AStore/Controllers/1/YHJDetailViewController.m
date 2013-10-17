//
//  YHJDetailViewController.m
//  AStore
//
//  Created by vedon on 10/17/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "YHJDetailViewController.h"
#import "UIViewController+LeftTitle.h"
#import "CommodityCell.h"
#import "HttpHelper.h"
#import "Commodity.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
@interface YHJDetailViewController ()
@property (strong ,nonatomic) NSArray * dataSource;
@end

@implementation YHJDetailViewController
@synthesize dataSource;
@synthesize lTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSource = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:self.lTitle];
    [self setBackItem:nil];
    
    UINib * cellNib = [UINib nibWithNibName:@"CommodityCell" bundle:[NSBundle bundleForClass:[CommodityCell class]]];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"CommodityCell"];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate showLoginViewOnView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    //根据title获取相关内容
    [HttpHelper getCommodityWithSaleTab:self.title withStart:0 withCount:10 withSuccessBlock:^(NSArray *commoditys) {
        dataSource = commoditys;
        for (Commodity * info in dataSource) {
            [Commodity printCommodityInfo:info];
        }
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    } withErrorBlock:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
        NSLog(@"%@",[error description]);
    }];
}

-(void)refreshTableView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommodityCell";
    CommodityCell *cell = (CommodityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Commodity * info = [dataSource objectAtIndex:indexPath.row];
    
    NSString * imageUrl = [HttpHelper extractImageURLWithStr:info.small_pic];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    CommodityCell *weakCell = cell;
    [cell.productImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakCell.productImageView setImage:image];
        [weakCell setNeedsLayout];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        ;
    }];
    cell.priceLabel.text = info.price;
    cell.titleLabel.text = info.name;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
