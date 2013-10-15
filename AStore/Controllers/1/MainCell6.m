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

//- (void)setUpACPScroll {
//	NSMutableArray *array = [[NSMutableArray alloc] init];
//	for (int i = 1; i < 5; i++) {
//		NSString *imgName = [NSString stringWithFormat:@"%d.png", i];
//		NSString *imgSelectedName = [NSString stringWithFormat:@"%ds.png", i];
//
//		//Set the items
//		ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:@"bg.png"] iconImage:[UIImage imageNamed:imgName] andLabel:@"Test"];
//
//		//Set highlighted behaviour
//		[item setHighlightedBackground:nil iconHighlighted:[UIImage imageNamed:imgSelectedName] textColorHighlighted:[UIColor redColor]];
//
//		[array addObject:item];
//	}
//
//	[customiseScrollView setUpACPScrollMenu:array];
//	[customiseScrollView setAnimationType:ACPZoomOut];
//
//	customiseScrollView.delegate = self;
//}

- (void)scrollMenu:(ACPItem *)menu didSelectIndex:(NSInteger)selectedIndex {
	NSLog(@"Item %d", selectedIndex);
    //DO somenthing here
}
@end
