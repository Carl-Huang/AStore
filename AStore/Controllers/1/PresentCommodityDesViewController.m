//
//  CommodityDesViewController.m
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "PresentCommodityDesViewController.h"
#import "UIViewController+LeftTitle.h"
#import "MBProgressHUD.h"
#import "GetGiftInfo.h"
@interface PresentCommodityDesViewController ()<UIWebViewDelegate>

@end

@implementation PresentCommodityDesViewController
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
    float floatString = [comodityInfo.point floatValue];
    NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
    self.price.text = priceStr;
    self.goods_id.text = comodityInfo.gift_id;
    
    //webView
//    NSString *htmlContent = [self analysisStr:comodityInfo.intro];
    [self.webViewDes loadHTMLString:comodityInfo.gift_describe baseURL:nil];
    [self.webViewDes setScalesPageToFit:YES];
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
    CGSize contentSize = self.webViewDes.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    _webViewDes.scrollView.minimumZoomScale = rw;
    _webViewDes.scrollView.maximumZoomScale = rw;
    _webViewDes.scrollView.zoomScale = rw;
}
@end
