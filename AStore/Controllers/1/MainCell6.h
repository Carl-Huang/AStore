//
//  MainCell6.h
//  AStore
//
//  Created by vedon on 10/14/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPScrollMenu.h"
@interface MainCell6 : UITableViewCell<ACPScrollDelegate>
@property (weak, nonatomic) IBOutlet ACPScrollMenu *customiseScrollView;
@property (strong ,nonatomic) NSArray * dataSource;
@property (strong ,nonatomic) NSMutableArray * array;
-(void)updateScrollView;
@end
