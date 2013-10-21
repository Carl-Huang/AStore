//
//  NoticeContentViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "NoticeContentViewController.h"
#import "UIViewController+LeftTitle.h"
#import "MBProgressHUD.h"
@interface NoticeContentViewController ()<UIWebViewDelegate>

@end

@implementation NoticeContentViewController
@synthesize articalContent;

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
    [self setLeftTitle:@"公告内容"];
    [self setBackItem:nil];
    NSString * contentStr = [self analysisStr:articalContent.content];
    [self.contentWebView loadHTMLString:contentStr baseURL:nil];
    self.contentWebView.delegate = self;
    self.contentWebView.scalesPageToFit = YES;
    [self.contentWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    //重新载入一个新的string,防止内存泄露?
    [self.contentWebView loadHTMLString:@"" baseURL:nil];
}

- (void)viewDidUnload {
    [self setContentWebView:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    self.contentWebView.delegate = nil;
}

-(NSString *)analysisStr:(NSString *)webStr
{
    NSString * replcaedStr = @"\"";
    webStr = [webStr stringByReplacingOccurrencesOfString:@"\"" withString:[NSString stringWithFormat:@"\%@",replcaedStr] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [webStr length])];
    return webStr;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD HUDForView:self.view];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
