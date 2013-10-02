//
//  CustomScrollView.m
//  iCtrl
//
//  Created by Carl on 13-2-19.
//  Copyright (c) 2013年 Carl. All rights reserved.
//

#import "CustomScrollView.h"


@interface CustomScrollView()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@end

@implementation CustomScrollView



-(id)initWithFrame:(CGRect)frame withViews:(NSArray *)views {
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        int viewCount = 0;
        if(views != nil)
        {
            viewCount = [views count];
        }

        
        for(int i = 0; i < viewCount; i++)
        {
            UIView *view = [views objectAtIndex:i];
            view.frame = CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height);
            [_scrollView addSubview:view];

        }
        
        _scrollView.contentSize = CGSizeMake(viewCount * frame.size.width, frame.size.height);
        
        [self addSubview:_scrollView];
        
        
        int pageControlWidth = viewCount * 20;
        int pageControlHeight = 30;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((frame.size.width-pageControlWidth)/2, frame.size.height - pageControlHeight, pageControlWidth , pageControlHeight)];
        
        _pageControl.numberOfPages = viewCount;
        _pageControl.currentPage = 0;
        
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
 
    }
    
    
    
    return self;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)pageTurn:(UIPageControl *)sender
{
    CGSize viewSize = _scrollView.frame.size;
    CGRect contentRect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:contentRect animated:YES];
}


#pragma mark -
#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    for (UIView *view in [_scrollView subviews]) {
        view.userInteractionEnabled = NO;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offSet = _scrollView.contentOffset;
    CGRect bounds = _scrollView.frame;
    int currentPage = offSet.x / bounds.size.width;
    _pageControl.currentPage = currentPage;
    for (UIView *view in [_scrollView subviews]) {
        view.userInteractionEnabled = YES;
    }
    
    
}



@end
