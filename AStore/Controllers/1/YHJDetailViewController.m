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
{
    NSInteger start;
    NSInteger count;
}
@property (strong ,nonatomic) NSMutableArray * dataSource;
@end

@implementation YHJDetailViewController
@synthesize dataSource;
@synthesize lTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSource = [[NSMutableArray alloc]init];
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
    start = 0;
    count = 5;
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
    if ([dataSource count]==0) {
        [HttpHelper getCommodityWithSaleTab:self.title withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
            [dataSource addObjectsFromArray:commoditys];
            if ([dataSource count]) {
                [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            }
            
        } withErrorBlock:^(NSError *error) {
            [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            NSLog(@"%@",[error description]);
        }];
    }

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    __weak YHJDetailViewController * weakSelf= self;
    CGFloat offsetY=0.0;
    offsetY = scrollView.contentOffset.y;
    NSInteger contentHeight = scrollView.contentSize.height;
    NSInteger boundary =  contentHeight - scrollView.frame.size.height/1.2;
    
    if (offsetY >= boundary)
    {
        start +=count + 1;
        count +=10;
        //执行再次加载新的数据
        [HttpHelper getCommodityWithSaleTab:self.title withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
            [dataSource addObjectsFromArray:commoditys];
            [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            
        } withErrorBlock:^(NSError *error) {
            [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            NSLog(@"%@",[error description]);
        }];
    }
}

@end
