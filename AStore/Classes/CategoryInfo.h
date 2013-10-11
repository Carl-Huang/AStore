//
//  CategoryInfo.h
//  AStore
//
//  Created by vedon on 10/11/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfo : NSObject
@property (strong ,nonatomic) NSString * cat_id;    //分类ID
@property (strong ,nonatomic) NSString * parent_id; //上级分类ID  （ 0代表主分类）
@property (strong ,nonatomic) NSString * cat_name;  //分类名称
@property (strong ,nonatomic) NSString * disabled;

@end
