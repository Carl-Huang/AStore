//
//  MainCell6.h
//  AStore
//
//  Created by vedon on 10/14/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPScrollMenu.h"
typedef void (^MainCell6Block) (id item);
@interface MainCell6 : UITableViewCell<ACPScrollDelegate>
{
    NSInteger start;
    NSInteger count;
    BOOL firstUpdate;
    BOOL isUpdatingItem;
}
@property (weak, nonatomic) IBOutlet ACPScrollMenu *customiseScrollView;
@property (strong ,nonatomic) NSMutableArray * dataSource;
@property (strong ,nonatomic) NSMutableArray * array;
@property (strong ,nonatomic) MainCell6Block block;
@property (strong ,nonatomic) NSMutableDictionary * itemDic;
-(void)updateScrollView;
@end
