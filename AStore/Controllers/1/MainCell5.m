//
//  MainCell5.m
//  AStore
//
//  Created by Carl on 13-9-27.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "MainCell5.h"
#import "ACPItem.h"
#import "Commodity.h"
#import "UIImageView+AFNetworking.h"
#import "HttpHelper.h"
#import "CommodityViewController.h"
@implementation MainCell5
@synthesize customiseScrollView;
@synthesize dataSource;
@synthesize array;
@synthesize itemDic;
-(void)setDataSource:(NSArray *)_dataSource
{
    if (dataSource !=_dataSource) {
        dataSource = nil;
        dataSource = [[NSMutableArray alloc]initWithArray:_dataSource];
        itemDic = [NSMutableDictionary dictionary];
        start = 11;
        count = 5;
        firstUpdate = YES;
    }
    //更新滚动的界面
}

-(void)updateScrollView
{
    if (array) {
        [array removeAllObjects];
        array = nil;
    }
    array = [[NSMutableArray alloc] init];
 
    for (int i = 0 ; i<[dataSource count]; i++) {
        Commodity * info = [dataSource objectAtIndex:i];
        NSString * imageStr = [HttpHelper extractImageURLWithStr:info.small_pic];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        //Set the items
        UIImageView * imageView = [[UIImageView alloc]init];
        [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            float floatString1 = [info.price floatValue];
            NSString * priceStr = [NSString stringWithFormat:@"￥%.1f",floatString1];
            ACPItem *item = [[ACPItem alloc]initACPItem:image iconImage:nil andLabel:priceStr];
            [itemDic setObject:item forKey:[NSString stringWithFormat:@"%d",i]];
            if ([itemDic count] == [dataSource count]) {
                if (firstUpdate) {
                    [self performSelectorOnMainThread:@selector(addPicToScrollView) withObject:nil waitUntilDone:NO];
                }else
                {
                    [self performSelectorOnMainThread:@selector(updateScrollViewItem) withObject:nil waitUntilDone:NO];
                }
            
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ;
        }];
    }
}

-(void)updateScrollViewItem
{
    for (int i =0; i<[dataSource count]; i++) {
        [array addObject:[itemDic objectForKey:[NSString stringWithFormat:@"%d",i]]];
    }
    if ([array count]) {
        [self.customiseScrollView updateScorllMenuItem:array];
    }

}

-(void)addPicToScrollView
{
    for (int i =0; i<[dataSource count]; i++) {
        [array addObject:[itemDic objectForKey:[NSString stringWithFormat:@"%d",i]]];
    }
    [self.customiseScrollView setUpACPScrollMenu:array];
    self.customiseScrollView.delegate = self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollMenu:(ACPItem *)menu didSelectIndex:(NSInteger)selectedIndex
{
	self.block([dataSource objectAtIndex:selectedIndex]);
    //DO somenthing here
}

-(void)updateScrollItems
{
    NSLog(@"%s",__func__);
    firstUpdate = NO;
     __weak MainCell5 * weakSelf = self;
    [HttpHelper getCommodityWithCatalogTabID:15 withTagName:@"热门商品" withStart:start withCount:count withSuccessBlock:^(NSArray *commoditys) {
        if ([commoditys count]) {
            [self.dataSource addObjectsFromArray:commoditys];
            [weakSelf updateScrollView];
        }
        
    } withErrorBlock:^(NSError *error) {
        NSLog(@"获取热门食品失败 %@", [error description]);
    }];
}


@end
