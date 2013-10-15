//
//  MainCell5.h
//  AStore
//
//  Created by Carl on 13-9-27.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPScrollMenu.h"
@interface MainCell5 : UITableViewCell<ACPScrollDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet ACPScrollMenu *customiseScrollView;
@property (strong ,nonatomic) NSArray * dataSource;
@property (strong ,nonatomic) NSMutableArray * array;
-(void)updateScrollView;
@end
