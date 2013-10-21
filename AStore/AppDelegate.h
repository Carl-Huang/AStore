//
//  AppDelegate.h
//  AStore
//
//  Created by Carl on 13-9-24.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class AKTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKTabBarController * akTabBarController;
@property (strong ,nonatomic) MBProgressHUD * loadingView;
@property (strong ,nonatomic) NSMutableArray * commodityArray;
@property (strong ,nonatomic) NSMutableArray * presentArray;
-(void)showLoginViewOnView:(UIView *)view;
-(void)removeLoadingViewWithView:(UIView *)view;
@end
