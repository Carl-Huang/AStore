//
//  UIViewController+LeftTitle.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "UIViewController+LeftTitle.h"

@implementation UIViewController (LeftTitle)
- (void) setLeftTitle:(NSString *)title
{
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if(size.width >= 200)
    {
        size.width = 200;
    }
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, size.width+30, 38)];
    
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont boldSystemFontOfSize:16];
//    titleLable.adjustsFontSizeToFitWidth = YES;
    titleLable.backgroundColor = [UIColor clearColor];
    [titleLable setText:title];
    UIBarButtonItem * titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLable];
    self.navigationItem.leftBarButtonItem = titleItem;
}

- (void) setBackItem:(SEL)action
{
    UIImage * backImg = [UIImage imageNamed:@"返回btn"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backBtn setImage:backImg forState:UIControlStateNormal];
    if (action == nil)
    {
        [backBtn addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
}

- (void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
