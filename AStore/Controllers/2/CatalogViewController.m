//
//  CatalogViewController.m
//  AStore
//
//  Created by Carl on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "CatalogViewController.h"
#import "ChildCatalogViewContaollerViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "CategoryInfo.h"
#import "AppDelegate.h"
#import "SubCatalogViewController.h"
@interface CatalogViewController ()
{
    NSMutableArray * totalCatalogData;
}
@property (strong, nonatomic) NSArray *firstSectionData;
@property (strong, nonatomic) NSArray *secondSectionData;
@property (strong, nonatomic) NSString * firstSectionKey;
@property (strong, nonatomic) NSString * secondSectionKey;
@property (strong,nonatomic) NSMutableDictionary * dictionary;
@end

@implementation CatalogViewController
@synthesize firstSectionData,secondSectionData;


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
    [self setLeftTitle:@"全部分类"];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  showLoginViewOnView:self.view];
}


-(void)viewWillAppear:(BOOL)animated
{
    [HttpHelper getAllCatalogWithSuccessBlock:^(NSDictionary *catInfo) {
        if ([catInfo count]) {
            totalCatalogData = [catInfo objectForKey:@"totalObj"];
            NSDictionary * catalogInfo = [catInfo objectForKey:@"catalogInfo"];
            _dictionary = (NSMutableDictionary *)catalogInfo;
            _firstSectionKey = [[_dictionary allKeys]objectAtIndex:0];
            _secondSectionKey = [[_dictionary allKeys]objectAtIndex:1];
            firstSectionData = (NSArray *)[_dictionary objectForKey:_firstSectionKey];
            secondSectionData = (NSArray *)[_dictionary objectForKey:_secondSectionKey];
            [self performSelectorOnMainThread:@selector(refreshTableview) withObject:nil waitUntilDone:NO];
        }
        
    } errorBlock:^(NSError *error) {
         NSLog(@"%@",[error description]);
    }];
}

-(void)refreshTableview
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  removeLoadingViewWithView:nil];
    [self.tableView reloadData];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_dictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    NSString * key = [[_dictionary allKeys] objectAtIndex:section];
    return ((NSArray *)[_dictionary objectForKey:key]).count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分类背景"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 120, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0 ) {
        label.text = _firstSectionKey;
    } else if(section == 1){
        label.text = _secondSectionKey;
    }
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    imageView = nil;
    label = nil;
    return headerView;

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
   
    NSString * key = [[_dictionary allKeys] objectAtIndex:indexPath.section];
    NSArray * array = (NSArray *)[_dictionary objectForKey:key];
    ;
    cell.textLabel.text = [[array objectAtIndex:indexPath.row]objectForKey:@"cat_name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NSDictionary * tempDic = [firstSectionData objectAtIndex:indexPath.row];
        NSString * parent_idStr = [tempDic objectForKey:@"cat_id"];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * dic in totalCatalogData) {
            if ([[dic objectForKey:@"parent_id"] isEqualToString:parent_idStr])
            {
                [tempArray addObject:dic];
            }
        }

        if ([tempArray count]) {
            SubCatalogViewController * subViewController = [[SubCatalogViewController alloc]initWithNibName:@"SubCatalogViewController" bundle:nil];
            [subViewController setDataSource:tempArray];
            tempArray = nil;
            [subViewController setTitleStr:[tempDic objectForKey:@"cat_name"]];
            [self.navigationController pushViewController:subViewController animated:YES];
        }else
        {
            ChildCatalogViewContaollerViewController * cCatList = [[ChildCatalogViewContaollerViewController alloc] initWithNibName:nil bundle:nil];

            [cCatList setCat_id:[[firstSectionData objectAtIndex:indexPath.row]objectForKey:@"cat_id"]];
            [cCatList setCat_name:[[firstSectionData objectAtIndex:indexPath.row]objectForKey:@"cat_name"]];
            [self.navigationController pushViewController:cCatList animated:YES];
        }
        
    }else
    {
        NSDictionary * tempDic = [secondSectionData objectAtIndex:indexPath.row];
        NSString * parent_idStr = [tempDic objectForKey:@"cat_id"];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * dic in totalCatalogData) {
            if ([[dic objectForKey:@"parent_id"] isEqualToString:parent_idStr])
            {
                [tempArray addObject:dic];
            }
        }
        
        if ([tempArray count]) {
            SubCatalogViewController * subViewController = [[SubCatalogViewController alloc]initWithNibName:@"SubCatalogViewController" bundle:nil];
            [subViewController setDataSource:tempArray];
            tempArray = nil;
            [subViewController setTitleStr:[tempDic objectForKey:@"cat_name"]];
            [self.navigationController pushViewController:subViewController animated:YES];
        }else
        {
            ChildCatalogViewContaollerViewController * cCatList = [[ChildCatalogViewContaollerViewController alloc] initWithNibName:nil bundle:nil];
            
            [cCatList setCat_id:[[secondSectionData objectAtIndex:indexPath.row]objectForKey:@"cat_id"]];
            [cCatList setCat_name:[[secondSectionData objectAtIndex:indexPath.row]objectForKey:@"cat_name"]];
             [self.navigationController pushViewController:cCatList animated:YES];
        }
       
    }
}

@end
