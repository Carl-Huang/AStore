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
        dataSource = [[NSArray alloc]init];
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
    
    [self fetchDataFromServer];
    isAlertViewCanShow = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    isAlertViewCanShow = NO;
}

//根据相应的cat_id从服务器获取资料
-(void)fetchDataFromServer
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  showLoginViewOnView:self.view];

    [HttpHelper getCommodityWithSaleTab:cat_id withStart:0 withCount:10 withSuccessBlock:^(NSArray *commoditys) {
        dataSource = commoditys;
        [self performSelectorOnMainThread:@selector(refreshTableview) withObject:nil waitUntilDone:NO];
        NSLog(@"%@",commoditys);
    } withErrorBlock:^(NSError *error) {
        [self showAlertViewWithTitle:@"提示" message:@"获取列表失败，是否重新获取"];
    }];
}


-(void)refreshTableview
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  removeLoadingViewWithView:nil];
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
@end
