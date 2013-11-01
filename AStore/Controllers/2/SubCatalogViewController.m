//
//  SubCatalogViewController.m
//  AStore
//
//  Created by vedon on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "SubCatalogViewController.h"
#import "ChildCatalogViewContaollerViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "CategoryInfo.h"
#import "AppDelegate.h"
@interface SubCatalogViewController ()
{
    NSMutableArray * totalCatalogData;
}
@end

@implementation SubCatalogViewController
@synthesize dataSource;
@synthesize titleStr;
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
    [self setLeftTitle:titleStr];
    [self setBackItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"分类icon-n";
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewDataSource Methods
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.indentationLevel = 3;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
   
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row]objectForKey:@"cat_name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildCatalogViewContaollerViewController * cCatList = [[ChildCatalogViewContaollerViewController alloc] initWithNibName:nil bundle:nil];
    [cCatList setCat_id:[[dataSource objectAtIndex:indexPath.row]objectForKey:@"cat_id"]];
    [cCatList setCat_name:[[dataSource objectAtIndex:indexPath.row]objectForKey:@"cat_name"]];
    [self.navigationController pushViewController:cCatList animated:YES];
}

@end
