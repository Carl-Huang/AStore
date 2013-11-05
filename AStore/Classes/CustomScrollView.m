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
    int viewCount;
    CGRect rect;
}

@end

@implementation CustomScrollView



-(id)initWithFrame:(CGRect)frame withViews:(NSArray *)views {
    self = [super initWithFrame:frame];
    
    if(self)
    {
        rect = frame;
        // 定时器 循环
//        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        viewCount = 0;
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
        
//        UIImageView *imageView = [views objectAtIndex:([views count]-1)];
//        imageView.frame = CGRectMake(0, 0, 320, rect.size.height); 
//        [_scrollView addSubview:imageView];
//        imageView = [views objectAtIndex:0];
//        imageView.frame = CGRectMake((320 * ([views count]-1)) , 0, 320,  rect.size.height); 
//        [_scrollView addSubview:imageView];
//        
//        [_scrollView setContentSize:CGSizeMake(320 * ([views count] + 2),   rect.size.height)];
//        [_scrollView setContentOffset:CGPointMake(0, 0)];
//        [_scrollView scrollRectToVisible:CGRectMake(0,0,320, rect.size.height) animated:NO];
    }
    return self;
}



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

//
//- (void)turnPage
//{
//    int page = _pageControl.currentPage; 
//    [_scrollView scrollRectToVisible:CGRectMake(320*(page),0,320, rect.size.height) animated:NO];
//}
//
//- (void)runTimePage
//{
//    int page = _pageControl.currentPage; 
//    page++;
//    page = page > viewCount-1 ? 0 : page ;
//    _pageControl.currentPage = page;
//    [self turnPage];
//}
@end
