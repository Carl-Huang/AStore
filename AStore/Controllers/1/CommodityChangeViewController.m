//
//  CommodityChangeViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "CommodityChangeViewController.h"
#import "CommodityEXCell.h"
#import "GetGiftInfo.h"
#import "HttpHelper.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "PresentCommodityViewController.h"
@interface CommodityChangeViewController ()
@property (strong ,nonatomic) NSArray * dataSource;
@end

@implementation CommodityChangeViewController
@synthesize dataSource;


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
    [self setLeftTitle:@"赠品兑换"];
    [self setBackItem:nil];
    
    UINib * cellNib = [UINib nibWithNibName:@"CommodityEXCell" bundle:[NSBundle bundleForClass:[CommodityEXCell class]]];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"CommodityEXCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (dataSource == nil) {
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate showLoginViewOnView:self.view];
        CommodityChangeViewController * weakSelf = self;
        
        [HttpHelper getGiftWithCompleteBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }else
                dataSource = item;
            [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
        }];

    }
}

-(void)refreshTableView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
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
    static NSString *CellIdentifier = @"CommodityEXCell";
    CommodityEXCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    GetGiftInfo * info = [dataSource objectAtIndex:indexPath.row];
    NSString * imageUrlStr = [HttpHelper extractImageURLWithStr:info.small_pic];
    __weak CommodityEXCell *weakCell = cell;
    NSURL *url = [NSURL URLWithString:imageUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [cell.commodityImageView setImageWithURLRequest:request placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           [weakCell.commodityImageView setImage:image];
                                           [weakCell setNeedsLayout];
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"下载图片失败");
                                       }];

    cell.titleLabel.text = info.name;
    cell.pointLabel.text = info.point;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetGiftInfo * info  = [dataSource objectAtIndex:indexPath.row];
    PresentCommodityViewController * viewController = [[PresentCommodityViewController alloc]initWithNibName:@"PresentCommodityViewController" bundle:nil];
    [viewController setComodityInfo:info];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

@end
