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
@interface TZMarketViewController ()
@property (nonatomic,retain) NSArray * dataSource;
@end

@implementation TZMarketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = @[@"杭电",@"杭职",@"理工",@"计量",@"水利水电",@"其他"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"跳蚤市场"];
    [self setBackItem:nil];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 108)];
    view1.backgroundColor = [UIColor grayColor];
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 108)];
    view2.backgroundColor = [UIColor blueColor];
    CustomScrollView * scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 108) withViews:@[view1,view2]];
    
    [_tableView setTableHeaderView:scrollView];
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
    
}



@end
