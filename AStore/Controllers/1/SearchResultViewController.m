//
//  SearchResultViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "SearchResultViewController.h"
#import "UIViewController+LeftTitle.h"
#import "CommodityCell.h"
#import "HttpHelper.h"
#import "Commodity.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
@interface SearchResultViewController ()
@property (strong ,nonatomic) NSArray * dataSource;
@end

@implementation SearchResultViewController
@synthesize dataSource;
@synthesize searchStr;

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
    [self setNoResultView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.noResultView setHidden:YES];
    //根据title获取相关内容
    [HttpHelper searchCommodityWithKeyworkd:searchStr withStart:0 withCount:10 withSuccessBlock:^(NSArray *commoditys) {
        dataSource = commoditys;
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    } withErrorBlock:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
        NSLog(@"%@",[error description]);

    }];
    
}

-(void)refreshTableView
{
    if ([dataSource count]== 0) {
        NSLog(@"没有找到商品");
        [self.noResultView setHidden:NO];
    }else
    {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];
        [self.tableView reloadData];
    }
   
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
    float floatString = [info.price floatValue];
    NSString * priceStr = [NSString stringWithFormat:@"%0.1f",floatString];

    cell.priceLabel.text = priceStr;
    cell.titleLabel.text = info.name;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
