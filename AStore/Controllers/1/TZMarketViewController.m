//
//  TZMarketViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "TZMarketViewController.h"
#import "UIViewController+LeftTitle.h"
#import "CustomScrollView.h"
#import "TZCommodityViewController.h"
#import "HttpHelper.h"
#import "CustomScrollView.h"
#import "UIImageView+AFNetworking.h"
#import "AdViewController.h"
#import "CycleScrollView.h"
#define TABLE_CELL_HEIGHT_1 124
@interface TZMarketViewController ()<CycleScrollViewDelegate>
{
    CycleScrollView * scrollView;
    NSMutableArray * imagesArray;
    NSInteger imageCount;
}
@property (nonatomic,retain) NSArray * dataSource;
@end

@implementation TZMarketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = @[@"杭电",@"杭职",@"理工",@"计量",@"水利水电",@"金融",@"经贸",@"财经",@"杭师",@"工商",@"经济"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"跳蚤市场"];
    [self setBackItem:nil];
    
    imagesArray = [NSMutableArray array];
    scrollView = nil;
    
    [HttpHelper getAdsWithURL:@"http://www.youjianpuzi.com/?page-xyhd.html" withNodeClass:@"mainColumn pageMain" withSuccessBlock:^(NSArray *items) {
        NSLog(@"%@",items);
        
        if ([items count]) {
            imageCount = [items count];
            for (NSDictionary *dic in items) {
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, TABLE_CELL_HEIGHT_1)];
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"image"]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
                __weak UIImageView * weakImageView = imageView;
                __weak TZMarketViewController * weakSelf =self;
                [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    [weakImageView setImage:image];
                    [weakSelf configureImagesArrayWithObj:@{@"FecthImage": image,@"url":dic[@"url"]}];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"%@",[error description]);
                }];
            }
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 108)];
    view1.backgroundColor = [UIColor grayColor];
//    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 108)];
//    view2.backgroundColor = [UIColor blueColor];
//    scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 108) withViews:@[view1,view2]];
    
    [_tableView setTableHeaderView:view1];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
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



-(void)configureImagesArrayWithObj:(NSDictionary *)dic
{
    [imagesArray addObject:dic];
    if (imageCount == [imagesArray count]) {
        NSMutableArray * tempArray = [NSMutableArray array];
        for (int i = 0 ;i < [imagesArray count];i++) {
            NSDictionary *dic = [imagesArray objectAtIndex:i];
            UIImageView * imageview = [[UIImageView alloc]initWithImage:dic[@"FecthImage"]];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToAdViewcontroller:)];
            [imageview addGestureRecognizer:tapGesture];
            imageview.userInteractionEnabled = YES;
            imageview.tag = i;
            [tempArray addObject:dic[@"FecthImage"]];
        }

        scrollView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, TABLE_CELL_HEIGHT_1) cycleDirection:CycleDirectionLandscape pictures:tempArray autoScroll:YES];
        scrollView.delegate = self;
        [self.tableView setTableHeaderView:scrollView];
    }
   
}
#pragma mark - CycleScrollViewDelegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index {
    
    NSLog(@"%s",__func__);
    NSDictionary *dic = [imagesArray objectAtIndex:index-1];
    __weak TZMarketViewController * viewController = self;
    [HttpHelper getSpecificUrlContentOfAdUrl:dic[@"url"] completedBlock:^(id item, NSError *error) {
        NSString * str = (NSString *)item;
        [viewController performSelector:@selector(adView:) withObject:str];
    }];
}



-(void)pushToAdViewcontroller:(UIGestureRecognizer *)recon
{
    NSLog(@"%s",__func__);
    UIImageView * tempImg = (UIImageView *)recon.view;
    NSDictionary * dic = [imagesArray objectAtIndex:tempImg.tag];
    NSLog(@"%@",dic[@"url"]);
     __weak TZMarketViewController * viewController = self;
    [HttpHelper getSpecificUrlContentOfAdUrl:dic[@"url"] completedBlock:^(id item, NSError *error) {
        [viewController performSelector:@selector(adView:) withObject:item];

    }];
}

-(void)adView:(id)obj
{
    AdViewController * viewController = [[AdViewController alloc]initWithNibName:@"AdViewController" bundle:nil];
    [viewController setContentStr:(NSString *)obj];
    [viewController setTitleStr:@"校园跳蚤市场免费供同学们使用"];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.indentationLevel = 3;
    }
    
    [cell.textLabel setText:[_dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = [_dataSource objectAtIndex:indexPath.row];
    TZCommodityViewController * controller = [[TZCommodityViewController alloc] initWithNibName:nil bundle:nil];
    controller.lTitle = title;
    controller.searchStr = title;
    [self.navigationController pushViewController:controller animated:YES];
}



@end
