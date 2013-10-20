//
//  CommodityDesViewController.h
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetGiftInfo;
@interface PresentCommodityDesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewDes;
@property (strong ,nonatomic) GetGiftInfo * comodityInfo;
@property (weak, nonatomic) IBOutlet UILabel *goods_id;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
