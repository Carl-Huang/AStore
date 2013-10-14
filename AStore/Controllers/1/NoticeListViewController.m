//
//  NoticeListViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "NoticeListViewController.h"
#import "UIViewController+LeftTitle.h"
#import "NoticeContentViewController.h"
#import "Artical.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "NoticeContentViewController.h"
@interface NoticeListViewController ()
@property (strong ,nonatomic) NSArray * dataSource;
@end

@implementation NoticeListViewController
@synthesize dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    [self setLeftTitle:@"店内公告"];
    [self setBackItem:nil];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate showLoginViewOnView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [HttpHelper getArticalListWithSuccessBlock:^(NSArray *commoditys) {
        dataSource = commoditys;
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    } withErrorBlock:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
        NSLog(@"%@",[error description]);
    }];
}

-(void)refreshTableView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Artical * info = [dataSource objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    [cell.textLabel setText:info.title];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Artical * info = [dataSource objectAtIndex:indexPath.row];
    NoticeContentViewController * noticeContentController = [[NoticeContentViewController alloc] initWithNibName:nil bundle:nil];
    [noticeContentController setArticalContent:info];
    [self.navigationController pushViewController:noticeContentController animated:YES];
    noticeContentController = nil;
}

@end
