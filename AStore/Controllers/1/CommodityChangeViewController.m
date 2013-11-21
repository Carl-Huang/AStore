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
{
    NSInteger start;
    NSInteger count;
    BOOL   isUpdateItem;
    NSString * promptStr;
}
@property (strong ,nonatomic) NSMutableArray * dataSource;
@end

@implementation CommodityChangeViewController
@synthesize dataSource;
@synthesize loadingView;

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

}

-(void)viewWillAppear:(BOOL)animated
{
    start = 0;
    count = 10;
    if ([dataSource count] == 0) {
        __weak CommodityChangeViewController * weakSelf = self;
        [HttpHelper getGiftStart:start count:count  WithCompleteBlock:^(id item, NSError *error) {
            if (error) {
                if ([[error domain] isEqualToString:@"NSURLErrorDomain"]) {
                    promptStr = @"请检查网络";
                }else
                {
                    promptStr = @"非常抱歉，分类没有产品！";
                }
                [self resetLoadingText];
            }else if([item count])
            {
                [dataSource addObjectsFromArray:item];
                 [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
            }
           
        }];

    }
}
-(void)resetLoadingText
{
    loadingView.detailsLabelText = promptStr;
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:2.0];
    
}

-(void)hideLoadingView
{
    [loadingView show:NO];
    [loadingView hide:YES];
}


-(void)refreshTableView
{
    [loadingView show:NO];
    [loadingView hide:YES];
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
    if (![info.small_pic isKindOfClass:[NSNull class]]) {
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
    }
   

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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    __weak CommodityChangeViewController * weakSelf= self;
    CGFloat offsetY=0.0;
    offsetY = scrollView.contentOffset.y;
    NSInteger contentHeight = scrollView.contentSize.height;
    NSInteger boundary =  contentHeight - scrollView.frame.size.height/1.2;
    
    if (offsetY >= boundary)
    {
        if (!isUpdateItem) {
            isUpdateItem = YES;
            start +=count;
            [loadingView hide:NO];
            [loadingView show:YES];

            //执行再次加载新的数据
            [HttpHelper getGiftStart:start count:count  WithCompleteBlock:^(id item, NSError *error) {
                if (error) {
                    start -=count;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        promptStr = @"商品列表已全部获取";
                        [weakSelf resetLoadingText];
                        [loadingView hide:YES];
                        [loadingView show:NO];
                    });
//                    [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
//                    NSLog(@"%@",[error description]);
                }else if([item count])
                {
                    [dataSource addObjectsFromArray:item];
                    [weakSelf performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
                    
                }else
                {
                    promptStr = @"商品列表已全部获取";
                    [weakSelf resetLoadingText];
                }
                
            }];
            [weakSelf performSelector:@selector(resetUpdateStatus) withObject:nil afterDelay:1.0];
        }
    }
}
-(void)resetUpdateStatus
{
    isUpdateItem = NO;
}
@end
