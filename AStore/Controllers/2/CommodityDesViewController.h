//
//  CommodityDesViewController.h
//  AStore
//
//  Created by vedon on 10/12/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"
@interface CommodityDesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webViewDes;
@property (strong ,nonatomic) Commodity * comodityInfo;
@property (weak, nonatomic) IBOutlet UILabel *goods_id;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
