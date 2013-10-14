//
//  MainCell5.m
//  AStore
//
//  Created by Carl on 13-9-27.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "MainCell5.h"
#import "ACPItem.h"

@implementation MainCell5
@synthesize customiseScrollView;
-(void)awakeFromNib
{
    [super awakeFromNib];
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

- (void)setUpACPScroll {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 1; i < 5; i++) {
		NSString *imgName = [NSString stringWithFormat:@"%d.png", i];
		NSString *imgSelectedName = [NSString stringWithFormat:@"%ds.png", i];
        
		//Set the items
		ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:@"bg.png"] iconImage:[UIImage imageNamed:imgName] andLabel:@"Test"];
        
		//Set highlighted behaviour
		[item setHighlightedBackground:nil iconHighlighted:[UIImage imageNamed:imgSelectedName] textColorHighlighted:[UIColor redColor]];
        
		[array addObject:item];
	}
    
	[customiseScrollView setUpACPScrollMenu:array];
	[customiseScrollView setAnimationType:ACPZoomOut];
    
	customiseScrollView.delegate = self;
}

- (void)scrollMenu:(ACPItem *)menu didSelectIndex:(NSInteger)selectedIndex {
	NSLog(@"Item %d", selectedIndex);
    //DO somenthing here
}
@end
