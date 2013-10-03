//
//  ModifyAddressViewController.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "ModifyAddressViewController.h"
#import "UIViewController+LeftTitle.h"
@interface ModifyAddressViewController ()

@end

@implementation ModifyAddressViewController

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
    [self setLeftTitle:@"修改地址"];
    [self setBackItem:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
