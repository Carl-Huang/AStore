//
//  HeaderView.h
//  AStore
//
//  Created by vedon on 10/4/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *onlinePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *offlinePayBtn;
@property (weak, nonatomic) IBOutlet UILabel *onLineTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLineTextLabel;

@end
