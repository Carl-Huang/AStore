//
//  MainCell3.h
//  AStore
//
//  Created by Carl on 13-9-27.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MainCell3ConfigureBlock) (id item);
@interface MainCell3 : UITableViewCell
@property (strong ,nonatomic)MainCell3ConfigureBlock block;
- (IBAction)btnAction:(id)sender;


@end
