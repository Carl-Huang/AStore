//
//  DetailCatalogInfoViewController.m
//  AStore
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "DetailCatalogInfoViewController.h"
#import "UIViewController+LeftTitle.h"
@interface DetailCatalogInfoViewController ()

@end

@implementation DetailCatalogInfoViewController

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
    [self setLeftTitle:@"食品"];
    [self setBackItem:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
