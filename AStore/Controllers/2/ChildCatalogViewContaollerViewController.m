//
//  ChildCatalogViewContaollerViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//


#import "ChildCatalogViewContaollerViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "Commodity.h"
#import "ChildCatalogInfoCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#import "CommodityViewController.h"

static NSString * cellIdentifier = @"cellIdentifier";

@interface ChildCatalogViewContaollerViewController ()<UIAlertViewDelegate>
{
    BOOL isAlertViewCanShow;
    NSInteger start;
    NSInteger count;
    BOOL isUpdateItem;
    NSString * promptStr;
}


@property (strong ,nonatomic) MBProgressHUD * loadingView;
@end

@implementation ChildCatalogViewContaollerViewController
@synthesize cat_id;
@synthesize cat_name;
@synthesize dataSource;
@synthesize loadingView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        cat_id = [[NSString alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    [self setLeftTitle:cat_name];
    [self setBackItem:nil];
    UINib *cellNib = [UINib nibWithNibName:@"ChildCatalogInfoCell" bundle:[NSBundle bundleForClass:[ChildCatalogInfoCell class]]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    dataSource = [NSMutableArray array];
    [self fetchDataFromServer];
    isAlertViewCanShow = YES;
    isUpdateItem = NO;
    
    loadingView = [[MBProgressHUD alloc]initWithView:self.view];
    loadingView.dimBackground = YES;
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    promptStr = @"正在加载...";
    loadingView.detailsLabelText = promptStr;
    [loadingView setMode:MBProgressHUDModeDeterminate];   //圆盘的扇形进度显示
    loadingView.taskInProgress = YES;
    [loadingView hide:NO];
    [loadingView show:YES];
    [self.view addSubview:loadingView];
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    isAlertViewCanShow = NO;
}

//根据相应的cat_id从服务器获取资料
-(void)fetchDataFromServer
{
    start = 0;
    count = 10;
    if ([dataSource count]==0) {

        __weak ChildCatalogViewContaollerViewController *weakSelf =self;
        [HttpHelper getCommodityWithTab:cat_id withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
            if ([commoditys count]) {
                [dataSource addObjectsFromArray:commoditys];
                [self performSelectorOnMainThread:@selector(refreshTableview) withObject:nil waitUntilDone:NO];
            }
        } withErrorBlock:^(NSError *error) {
            promptStr = @"非常抱歉，该分类下没有找到产品！";
            [weakSelf resetLoadingText];
        }];
    }
}

-(void)resetLoadingText
{
    loadingView.detailsLabelText = promptStr;
}


-(void)refreshTableview
{
    [loadingView show:NO];
    [loadingView hide:YES];
    [self.tableView reloadData];
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    if (isAlertViewCanShow) {
        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        pAlert.delegate = self;
        [pAlert show];
        pAlert = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)extractImageURLWithStr:(NSString *)str
{
    NSString * tempStr = [NSString stringWithFormat:@"%@",str];
    NSRange range = [tempStr rangeOfString:@"|" options:NSCaseInsensitiveSearch];
    NSRange strRange = NSMakeRange(0, range.location);
    return [Resource_URL_Prefix stringByAppendingString:[str substringWithRange:strRange]];
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
    NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
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


#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self fetchDataFromServer];
            break;
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
        default:
            break;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    __weak ChildCatalogViewContaollerViewController * weakSelf= self;
    CGFloat offsetY=0.0;
    offsetY = scrollView.contentOffset.y;
    NSInteger contentHeight = scrollView.contentSize.height;
    NSInteger boundary =  contentHeight - scrollView.frame.size.height-20;
    
    if (offsetY >= boundary)
    {
        if (!isUpdateItem) {
            isUpdateItem = YES;
            start +=count;

            [loadingView hide:NO];
            [loadingView show:YES];
            //执行再次加载新的数据
            [HttpHelper getCommodityWithTab:cat_id withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
                if ([commoditys count]) {
                    [dataSource addObjectsFromArray:commoditys];
                    [weakSelf performSelectorOnMainThread:@selector(refreshTableview) withObject:nil waitUntilDone:NO];
                }
            } withErrorBlock:^(NSError *error) {
                start -=count;
                promptStr = @"商品列表已全部获取";
                [loadingView hide:YES];
                [loadingView show:NO];
                [weakSelf resetLoadingText];
            }];
            
            
            [weakSelf performSelector:@selector(resetUpdateStatus) withObject:nil afterDelay:2.0];

        }
    }
}

-(void)resetUpdateStatus
{
    isUpdateItem = NO;
}
- (void)viewDidUnload {
    [self setCatalogTableview:nil];
    [super viewDidUnload];
}
@end
