//
//  NoticeContentViewController.h
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artical.h"
@interface NoticeContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong ,nonatomic) Artical * articalContent;
@end
