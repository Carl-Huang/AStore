//
//  MainCell6.m
//  AStore
//
//  Created by vedon on 10/14/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "MainCell6.h"
#import "ACPItem.h"
#import "Commodity.h"
#import "UIImageView+AFNetworking.h"
#import "HttpHelper.h"

@implementation MainCell6
@synthesize dataSource,array;
@synthesize customiseScrollView;
@synthesize itemDic;
-(void)setDataSource:(NSArray *)_dataSource
{
    if (dataSource !=_dataSource) {
        dataSource = nil;
        dataSource = [[NSArray alloc]initWithArray:_dataSource];
        itemDic = [NSMutableDictionary dictionary];
    }
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
        __block UIImageView * weakImageView = imageView;
        [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSString * priceStr = [NSString stringWithFormat:@"￥%@",[info.price substringToIndex:[info.price length]-2]];
            ACPItem *item = [[ACPItem alloc]initACPItem:image iconImage:nil andLabel:priceStr];
            [itemDic setObject:item forKey:[NSString stringWithFormat:@"%d",i]];
            if ([itemDic count] == [dataSource count]) {
                [self performSelectorOnMainThread:@selector(addPicToScrollView) withObject:nil waitUntilDone:NO];
            }
            weakImageView = nil;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            ;
        }];
    }}

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


- (void)scrollMenu:(ACPItem *)menu didSelectIndex:(NSInteger)selectedIndex {
	NSLog(@"Item %d", selectedIndex);
    self.block([dataSource objectAtIndex:selectedIndex]);
}
@end
