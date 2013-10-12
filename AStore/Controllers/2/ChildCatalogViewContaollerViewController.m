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

static NSString * cellIdentifier = @"cellIdentifier";

@interface ChildCatalogViewContaollerViewController ()
@property (strong ,nonatomic) NSArray  * dataSource;
@end

@implementation ChildCatalogViewContaollerViewController
@synthesize cat_id;
@synthesize cat_name;
@synthesize dataSource;
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
}


//根据相应的cat_id从服务器获取资料
-(void)fetchDataFromServer
{
    [HttpHelper getCommodityWithSaleTab:cat_id withStart:0 withCount:10 withSuccessBlock:^(NSArray *commoditys) {
        dataSource = commoditys;
        [self performSelectorOnMainThread:@selector(refreshTableview) withObject:nil waitUntilDone:NO];
        NSLog(@"%@",commoditys);
    } withErrorBlock:^(NSError *error) {
        ;
    }];
}


-(void)refreshTableview
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)extractImageURLWithStr:(NSString *)str
{
    
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
    NSString * str = [NSString stringWithFormat:@"%@",info.small_pic];
    NSRange range = [str rangeOfString:@"|" options:NSCaseInsensitiveSearch];
    NSRange strRange = NSMakeRange(0, range.location);
    NSString * imageUrlStr = [str substringWithRange:strRange];
    imageUrlStr =  [Resource_URL_Prefix stringByAppendingString:imageUrlStr];
    
    //异步获取图片
    __weak ChildCatalogInfoCell *weakCell = cell;
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    NSURL *url = [NSURL URLWithString:imageUrlStr];
                  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
                  [weakCell.imageView setImageWithURLRequest:request placeholderImage:nil
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                [weakCell.imageView setImage:image];
                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                NSLog(@"下载图片失败");
                                            }];
    
    cell.pruductName.text = info.name;
    cell.productPrice.text = info.price;
    return cell;
}



#pragma mark - Table view delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
