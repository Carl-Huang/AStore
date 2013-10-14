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
@interface SearchResultViewController ()
@property (strong ,nonatomic) NSArray * dataSource;
@end

@implementation SearchResultViewController
@synthesize dataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    [HttpHelper getCommodityWithSaleTab:self.title withStart:0 withCount:10 withSuccessBlock:^(NSArray *commoditys) {
        dataSource = commoditys;
        for (Commodity * info in dataSource) {
            [Commodity printCommodityInfo:info];
        }
    } withErrorBlock:^(NSError *error) {
        ;
    }];
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
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommodityCell";
    CommodityCell *cell = (CommodityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
