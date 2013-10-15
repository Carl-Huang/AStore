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
@implementation MainCell5
@synthesize customiseScrollView;
@synthesize dataSource;
@synthesize array;
-(void)setDataSource:(NSArray *)_dataSource
{
    if (dataSource !=_dataSource) {
        dataSource = nil;
        dataSource = [[NSArray alloc]initWithArray:_dataSource];
    }
    //更新滚动的界面
}

-(void)updateScrollView
{
    array = [[NSMutableArray alloc] init];
    for (Commodity * info in dataSource) {
        NSString * imageStr = [HttpHelper extractImageURLWithStr:info.small_pic];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        //Set the items
        UIImageView * imageView = [[UIImageView alloc]init];
        __block UIImageView * weakImageView = imageView;
        [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSString * priceStr = [NSString stringWithFormat:@"￥%@",[info.price substringToIndex:[info.price length]-2]];
            ACPItem *item = [[ACPItem alloc]initACPItem:image iconImage:nil andLabel:priceStr];
            [array addObject:item];
            if ([array count] == [dataSource count]) {
                [self performSelectorOnMainThread:@selector(addPicToScrollView) withObject:nil waitUntilDone:NO];
            }
            weakImageView = nil;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ;
        }];
    }
}

-(void)addPicToScrollView
{
    [self.customiseScrollView setUpACPScrollMenu:array];
    self.customiseScrollView.delegate = self;
    array = nil;
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

- (void)scrollMenu:(ACPItem *)menu didSelectIndex:(NSInteger)selectedIndex {
	NSLog(@"Item %d", selectedIndex);
    //DO somenthing here
}
@end
