//
//  CommodityDesViewController.m
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "CommodityDesViewController.h"
#import "UIViewController+LeftTitle.h"
#import "MBProgressHUD.h"
@interface CommodityDesViewController ()<UIWebViewDelegate>

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
    float floatString = [comodityInfo.price floatValue];
    NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
    self.price.text = priceStr;
    self.goods_id.text = comodityInfo.bn;
    
    //webView
    NSString *htmlContent = [self analysisStr:comodityInfo.intro];
    [self.webViewDes loadHTMLString:htmlContent baseURL:nil];
    self.webViewDes.scalesPageToFit = YES;
    [self.webViewDes setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    
    // Do any additional setup after loading the view from its nib.
}

-(NSString *)analysisStr:(NSString *)webStr
{
    NSString * replcaedStr = @"\"";
    webStr = [webStr stringByReplacingOccurrencesOfString:@"\"" withString:[NSString stringWithFormat:@"\%@",replcaedStr] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [webStr length])];
    return webStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebViewDes:nil];
    [self setGoods_id:nil];
    [self setPrice:nil];
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //重新载入一个新的string,防止内存泄露?
    [self.webViewDes loadHTMLString:@"" baseURL:nil];
}

-(void)dealloc
{
    self.webViewDes.delegate = nil;
}
#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD HUDForView:self.view];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
