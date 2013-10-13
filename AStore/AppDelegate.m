//
//  AppDelegate.m
//  AStore
//
//  Created by Carl on 13-9-24.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "AppDelegate.h"
#import "AKTabBarController.h"
#import "MainViewController.h"
#import "CatalogViewController.h"
#import "CartViewController.h"
#import "UserCenterViewController.h"
#import "LoginViewController.h"
@implementation AppDelegate
@synthesize loadingView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self customUI];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    _akTabBarController = [[AKTabBarController alloc] initWithTabBarHeight:49.0];
    //首页界面
    MainViewController * mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * nav_a = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    //分类列表界面
    CatalogViewController * catalogViewController = [[CatalogViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * nav_b = [[UINavigationController alloc] initWithRootViewController:catalogViewController];
    //购物车界面
    CartViewController * cartViewController = [[CartViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * nav_c = [[UINavigationController alloc] initWithRootViewController:cartViewController];
    //用户中心界面
    UserCenterViewController * userViewController = [[UserCenterViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * nav_d = [[UINavigationController alloc] initWithRootViewController:userViewController];
    //用户登陆界面
//    LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
//    UINavigationController * nav_d = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    _akTabBarController.viewControllers = [NSMutableArray arrayWithObjects:nav_a,nav_b,nav_c,nav_d,nil];
    [_akTabBarController setBackgroundImageName:@"未选中bg"];
    [_akTabBarController setSelectedBackgroundImageName:@"选中bg"];
    [_akTabBarController setSelectedIconColors:@[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1],
     [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]]];
    self.window.rootViewController = _akTabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)customUI
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"导航背景"] forBarMetrics:UIBarMetricsDefault];
}

-(void)showLoginViewOnView:(UIView *)view
{
    loadingView = [[MBProgressHUD alloc]initWithView:view];
    loadingView.dimBackground = YES;
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    loadingView.labelText = @"正在加载...";
    [view addSubview:loadingView];
    [loadingView setMode:MBProgressHUDModeDeterminate];   //圆盘的扇形进度显示
    loadingView.taskInProgress = YES;
    UITapGestureRecognizer *HUDSingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [loadingView addGestureRecognizer:HUDSingleTap];
    HUDSingleTap = nil;
    [loadingView show:YES];
}

-(void)singleTap:(UIGestureRecognizer *)gest
{
    [self removeLoadingViewWithView:nil];
}
-(void)removeLoadingViewWithView:(UIView *)view
{
    NSLog(@"%s",__func__);
    [loadingView hide:YES];
    loadingView = nil;
}
@end
