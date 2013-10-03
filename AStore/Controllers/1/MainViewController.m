//
//  MainViewController.m
//  AStore
//
//  Created by Carl on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "MainViewController.h"
#import "NoticeListViewController.h"
#import "YHJViewController.h"
#import "CommodityChangeViewController.h"
#import "TZMarketViewController.h"
#import "SearchResultViewController.h"
#import "CustomScrollView.h"
#import "MainCell2.h"
#import "MainCell3.h"
#import "MainCell4.h"
#import "MainCell5.h"
#define TABLE_CELL_HEIGHT_1 124
#define TABLE_CELL_HEIGHT_2 122
#define TABLE_CELL_HEIGHT_3 94
#define TABLE_CELL_HEIGHT_4 94
#define TABLE_CELL_HEIGHT_5 145
#define TABLE_CELL_HEIGHT_6 145
@interface MainViewController ()<UITextFieldDelegate>
{
    UITextField * searchField;
}
@end

@implementation MainViewController

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
    
    UIImage * logo = [UIImage imageNamed:@"logo"];
    UIImageView * logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)];
    logoView.image = logo;
    UIBarButtonItem * logoItem = [[UIBarButtonItem alloc] initWithCustomView:logoView];
    self.navigationItem.leftBarButtonItem = logoItem;
    
    
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 165, 35)];
    searchField.delegate = self;
    [searchField setBackground:[UIImage imageNamed:@"search背景"]];
    searchField.returnKeyType = UIReturnKeySearch;
    self.navigationItem.titleView = searchField;
    
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 54, 53)];
    [searchBtn setImage:[UIImage imageNamed:@"搜索btn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    
    UINib * cell2NIb = [UINib nibWithNibName:@"MainCell2" bundle:[NSBundle bundleForClass:[MainCell2 class]]];
    [_tableView registerNib:cell2NIb forCellReuseIdentifier:@"MainCell2"];
    
    UINib * cell3Nib = [UINib nibWithNibName:@"MainCell3" bundle:[NSBundle bundleForClass:[MainCell3 class]]];
    [_tableView registerNib:cell3Nib forCellReuseIdentifier:@"MainCell3"];
    
    UINib * cell4Nib = [UINib nibWithNibName:@"MainCell4" bundle:[NSBundle bundleForClass:[MainCell4 class]]];
    [_tableView registerNib:cell4Nib forCellReuseIdentifier:@"MainCell4"];
    
    UINib * cell5Nib = [UINib nibWithNibName:@"MainCell5" bundle:[NSBundle bundleForClass:[MainCell5 class]]];
    [_tableView registerNib:cell5Nib forCellReuseIdentifier:@"MainCell5"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"首页icon-n";
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}




- (void)search:(id)sender
{
    [searchField resignFirstResponder];
    SearchResultViewController * searchResultController = [[SearchResultViewController alloc] initWithNibName:nil bundle:nil];
    searchResultController.lTitle = @"搜索结果";
    [self.navigationController pushViewController:searchResultController animated:YES];
}


#pragma mark - UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return TABLE_CELL_HEIGHT_1;
    }
    else if(indexPath.row == 1)
    {
        return TABLE_CELL_HEIGHT_2;
    }
    else if (indexPath.row == 2)
    {
        return TABLE_CELL_HEIGHT_3;
    }
    else if(indexPath.row == 3)
    {
        return TABLE_CELL_HEIGHT_4;
    }
    else if(indexPath.row == 4)
    {
        return TABLE_CELL_HEIGHT_5;
    }
    else
    {
        return TABLE_CELL_HEIGHT_6;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLE_CELL_HEIGHT_1)];
        view1.backgroundColor = [UIColor grayColor];
        UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLE_CELL_HEIGHT_1)];
        view2.backgroundColor = [UIColor blueColor];
        CustomScrollView * scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLE_CELL_HEIGHT_1) withViews:@[view1,view2]];
        UITableViewCell * cell_1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScrollCell"];
        [cell_1.contentView addSubview:scrollView];
        return cell_1;
        
    }
    else if(indexPath.row == 1)
    {
        MainCell2 * cell_2 = (MainCell2 *)[_tableView dequeueReusableCellWithIdentifier:@"MainCell2"];
        [cell_2.button_1 addTarget:self action:@selector(cell2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell_2.button_2 addTarget:self action:@selector(cell2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell_2.button_3 addTarget:self action:@selector(cell2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell_2.button_4 addTarget:self action:@selector(cell2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell_2;
        
    }
    else if (indexPath.row == 2)
    {
        MainCell3 * cell_3 = (MainCell3 *)[_tableView dequeueReusableCellWithIdentifier:@"MainCell3"];
        return cell_3;
    }
    else if(indexPath.row == 3)
    {
        MainCell4 * cell_4 = (MainCell4 *)[_tableView dequeueReusableCellWithIdentifier:@"MainCell4"];
        return cell_4;
    }
    else 
    {
        MainCell5 * cell_5 = (MainCell5 *)[_tableView dequeueReusableCellWithIdentifier:@"MainCell5"];
        if(indexPath.row == 4)
        {
            [cell_5.titleLabel setText:@"热卖食品推荐"];
        }
        else if(indexPath.row == 5)
        {
            [cell_5.titleLabel setText:@"热卖日用品推荐"];
        }
        return cell_5;

    }
    
    return nil;
}



#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)cell2BtnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        CommodityChangeViewController * commodityChange = [[CommodityChangeViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:commodityChange animated:YES];
    }
    else if(btn.tag == 2)
    {
        YHJViewController * yhjViewController = [[YHJViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:yhjViewController animated:YES];
    }
    else if(btn.tag == 3)
    {
        TZMarketViewController * marketViewController = [[TZMarketViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:marketViewController animated:YES];
    }
    else if(btn.tag == 4)
    {
        NoticeListViewController * noticeList = [[NoticeListViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:noticeList animated:YES];
    }
}

@end