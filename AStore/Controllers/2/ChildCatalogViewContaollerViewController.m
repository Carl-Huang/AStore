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
    [self fetchDataFromServer];
}

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

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    Commodity * info = [dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:info.name];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
