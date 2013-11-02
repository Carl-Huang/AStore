//
//  AdViewController.h
//  AStore
//
//  Created by vedon on 28/10/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *adWebView;
@property (strong ,nonatomic) NSString * contentStr;
@property (strong, nonatomic) NSString * titleStr;
@end
