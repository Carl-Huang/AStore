//
//  YHJViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "YHJViewController.h"
#import "UIViewController+LeftTitle.h"
#import "YHJDetailViewController.h"
@interface YHJViewController ()
@property (nonatomic,retain) NSArray * catalogArr;
@end

@implementation YHJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _catalogArr = @[@"餐饮",@"娱乐",@"休闲",@"住宿",@"旅游",@"培训",@"快递",@"其他"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"聚优惠"];
    [self setBackItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {

    [super viewDidUnload];
}
- (IBAction)showCatalogController:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    int index = btn.tag - 1;
    NSString * title = [_catalogArr objectAtIndex:index];
    YHJDetailViewController * searchResult = [[YHJDetailViewController alloc] init];
    searchResult.lTitle = title;
    [self.navigationController pushViewController:searchResult animated:YES];
    searchResult = nil;
}
@end
