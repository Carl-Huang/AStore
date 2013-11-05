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
@interface MainCommodityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isAlertViewCanShow;
    BOOL isUpdateItem;
    NSInteger start;
    NSInteger count;
    BOOL isFirstLoad;
    NSString * promptStr;
}
@end

@implementation MainCommodityViewController
@synthesize dataSource;
@synthesize titleStr;
@synthesize tabId;
@synthesize loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataSource = nil;
        isFirstLoad = YES;
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
    
//    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [myDelegate  showLoginViewOnView:self.view];
    dataSource = [NSMutableArray array];
    isUpdateItem = NO;
    
    
    loadingView = [[MBProgressHUD alloc]initWithView:self.view];
    loadingView.dimBackground = YES;
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    promptStr = @"正在加载...";
    loadingView.detailsLabelText = promptStr;
    [loadingView setMode:MBProgressHUDModeDeterminate];   //圆盘的扇形进度显示
    loadingView.taskInProgress = YES;
    [self.view addSubview:loadingView];
    [loadingView hide:NO];
    [loadingView show:YES];
    // Do any additional setup after loading the view from its nib.
}

-(void)resetLoadingText
{
    loadingView.detailsLabelText = promptStr;
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
    count = 10;
    __weak MainCommodityViewController * weakSelf = self;
    if ([dataSource count]==0) {
        [HttpHelper getCommodityWithCatalogTabID:[tabId integerValue] withTagName:titleStr withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
            if ([commoditys count]) {
                [dataSource addObjectsFromArray:commoditys];
                [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            }
        } withErrorBlock:^(NSError *error) {
            promptStr = @"连接服务器失败，\n请检查网络是否可用";
            [weakSelf resetLoadingText];
        }];
    }
}

-(void)refreshTableView
{
    [loadingView show:NO];
    [loadingView hide:YES];


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
    NSInteger boundary =  contentHeight - scrollView.frame.size.height;
    
    if (offsetY >= boundary)
    {
       
        if (!isUpdateItem) {
            start +=count ;
            isUpdateItem = YES;
            [loadingView hide:NO];
            [loadingView show:YES];
            [HttpHelper getCommodityWithCatalogTabID:[tabId integerValue] withTagName:titleStr withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
                if ([commoditys count]) {
                    [dataSource addObjectsFromArray:commoditys];
                    [weakSelf performSelector:@selector(resetUpdateStatus) withObject:nil afterDelay:1.0];
                    promptStr = @"正在加载...";
                    [weakSelf resetLoadingText];
                    [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
                }else
                {
                    promptStr = @"商品列表已全部获取";
                    [weakSelf resetLoadingText];
                }
            } withErrorBlock:^(NSError *error) {
                start -=count;
                [weakSelf performSelector:@selector(resetUpdateStatus) withObject:nil afterDelay:1.0];
                 [loadingView show:NO];
                [loadingView hide:YES];
                promptStr = @"商品列表已全部获取";;
                [weakSelf resetLoadingText];
            }];
             
        }
        //执行再次加载新的数据
    }
}

-(void)resetUpdateStatus
{
    isUpdateItem = NO;
}
@end
