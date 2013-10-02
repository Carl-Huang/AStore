//
//  UIViewController+LeftTitle.h
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LeftTitle)
- (void) setLeftTitle:(NSString *)title;
- (void) setBackItem:(SEL)action;
@end
