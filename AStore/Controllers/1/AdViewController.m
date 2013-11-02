//
//  AdViewController.m
//  AStore
//
//  Created by vedon on 28/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "AdViewController.h"
#import "UIViewController+LeftTitle.h"
@interface AdViewController ()

@end

@implementation AdViewController
@synthesize contentStr;
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
    
    [self.adWebView loadHTMLString:contentStr baseURL:nil];
    self.adWebView.userInteractionEnabled = YES;
    self.adWebView.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAdWebView:nil];
    [super viewDidUnload];
}
@end
