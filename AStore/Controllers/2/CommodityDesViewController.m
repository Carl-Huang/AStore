//
//  CommodityDesViewController.m
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "CommodityDesViewController.h"
#import "UIViewController+LeftTitle.h"

@interface CommodityDesViewController ()

@end

@implementation CommodityDesViewController
@synthesize comodityInfo;

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
    [self setLeftTitle:comodityInfo.name];
    [self setBackItem:nil];
    NSString *htmlContent = @"<img src=\"http://www.youjianpuzi.com/images//20120915/e5023b85ae2efb8a.gif\"><br/><img src=\"http://www.youjianpuzi.com/images//20120915/3d1f3b269988863a.jpg\"><br/><img src=\"http://www.youjianpuzi.com/images//20120915/505a44d252ca7594.gif\"><br/><img src=\"http://www.youjianpuzi.com/images//20120915/03a6ffba482ef055.jpg\"><br/><img src=\"http://www.youjianpuzi.com/images//20120915/71f96d308e61b8c1.jpg\"><br/><br/><br/>";
    NSMutableString *htmlPage = [NSMutableString new];
    [htmlPage appendString:htmlContent];
    [self.webViewDes loadHTMLString:htmlPage baseURL:nil];
    self.webViewDes.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebViewDes:nil];
    [super viewDidUnload];
}
@end
