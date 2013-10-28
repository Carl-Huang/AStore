//
//  MainCommodityViewController.m
//  AStore
//
//  Created by vedon on 10/14/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "MainCommodityViewController.h"
#import "UIViewController+LeftTitle.h"
#import "ChildCatalogInfoCell.h"
#import "Commodity.h"
#import "HttpHelper.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "CommodityViewController.h"
static NSString * cellIdentifier = @"cellidentifier";
@interface MainCommodityViewController ()
{
    BOOL isAlertViewCanShow;
    NSInteger start;
    NSInteger count;
}
@end

@implementation MainCommodityViewController
@synthesize dataSource;
@synthesize titleStr;
@synthesize tabId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataSource = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:titleStr];
    [self setBackItem:nil];
    UINib *cellNib = [UINib nibWithNibName:@"ChildCatalogInfoCell" bundle:[NSBundle bundleForClass:[ChildCatalogInfoCell class]]];
    [self.tableview registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  showLoginViewOnView:self.view];
    dataSource = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    start = 0;
    count = 5;
    if ([dataSource count]==0) {
        [HttpHelper getCommodityWithCatalogTabID:[tabId integerValue] withTagName:titleStr withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
            if ([commoditys count]) {
                [dataSource addObjectsFromArray:commoditys];
                [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            }
        } withErrorBlock:^(NSError *error) {
            ;
        }];
    }
}

-(void)refreshTableView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  removeLoadingViewWithView:nil];

    [self.tableview reloadData];
}
#pragma mark - Table view data source

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
    ChildCatalogInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Commodity * info = [dataSource objectAtIndex:indexPath.row];
    
    //取出图片的url
    NSString * imageUrlStr =[HttpHelper extractImageURLWithStr:info.small_pic];
    
    //异步获取图片
    __weak ChildCatalogInfoCell *weakCell = cell;
    [cell.productImage setContentMode:UIViewContentModeScaleAspectFit];
    NSURL *url = [NSURL URLWithString:imageUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [cell.productImage setImageWithURLRequest:request placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          [weakCell.productImage setImage:image];
                                          [weakCell setNeedsLayout];
                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          NSLog(@"下载图片失败");
                                      }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pruductName.text = info.name;
    float floatString = [info.price floatValue];
    NSString * priceStr = [NSString stringWithFormat:@"%0.1f",floatString];
    cell.productPrice.text = priceStr;
    return cell;
}

#pragma mark - Table view delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commodity * info = [dataSource objectAtIndex:indexPath.row];
    [Commodity printCommodityInfo:info];
    CommodityViewController *viewController = [[CommodityViewController alloc]initWithNibName:@"CommodityViewController" bundle:nil];
    [viewController setComodityInfo:info];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    __weak MainCommodityViewController * weakSelf= self;
    CGFloat offsetY=0.0;
    offsetY = scrollView.contentOffset.y;
    NSInteger contentHeight = scrollView.contentSize.height;
    NSInteger boundary =  contentHeight - scrollView.frame.size.height/1.2;
    
    if (offsetY >= boundary)
    {
        start +=count + 1;
        count +=10;
        //执行再次加载新的数据
        [HttpHelper getCommodityWithCatalogTabID:[tabId integerValue] withTagName:titleStr withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
            if ([commoditys count]) {
                [dataSource addObjectsFromArray:commoditys];
                [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            }
        } withErrorBlock:^(NSError *error) {
            ;
        }];
    }
}

@end
