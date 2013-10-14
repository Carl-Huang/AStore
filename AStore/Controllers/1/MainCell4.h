//
//  MainCell4.h
//  AStore
//
//  Created by Carl on 13-9-27.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MainCell4ConfigureBlock) (id item);
@interface MainCell4 : UITableViewCell
@property (strong ,nonatomic)MainCell4ConfigureBlock block;
- (IBAction)btnAction:(id)sender;

@end
