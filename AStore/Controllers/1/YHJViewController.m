//
//  YHJViewController.m
//  AStore
//
//  Created by Carl on 13-9-28.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "YHJViewController.h"
#import "UIViewController+LeftTitle.h"
#import "YHJDetailViewController.h"
#import "CustomScrollView.h"
#import "UIImageView+AFNetworking.h"
#import "HttpHelper.h"
#import "AdViewController.h"
@interface YHJViewController ()
{
    CustomScrollView * scrollView;
    NSMutableArray * imagesArray;
}
@property (nonatomic,retain) NSArray * catalogArr;
@end

@implementation YHJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _catalogArr = @[@"餐饮",@"娱乐",@"休闲",@"住宿",@"旅游",@"培训",@"快递",@"其他"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"聚优惠"];
    [self setBackItem:nil];
    
    
    imagesArray = [NSMutableArray array];
    scrollView = [[CustomScrollView alloc] initWithFrame:_tmpLabel.frame withViews:@[_tmpLabel]];
    [self.view addSubview:scrollView];
    [HttpHelper getAdsWithURL:@"http://www.youjianpuzi.com/?page-jyh.html" withNodeClass:@"mainColumn pageMain" withSuccessBlock:^(NSArray *items) {
        NSLog(@"%@",items);
        
        if ([items count]) {
            for (NSDictionary *dic in items) {
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 108)];
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"image"]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
                __weak UIImageView * weakImageView = imageView;
                __weak YHJViewController * weakSelf =self;
                [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    [weakImageView setImage:image];
                    [weakSelf configureImagesArrayWithObj:@{@"FecthImage": image,@"url":dic[@"url"]}];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"%@",[error description]);
                }];
            }
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {

    [self setTmpLabel:nil];
    [super viewDidUnload];
}
- (IBAction)showCatalogController:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    int index = btn.tag - 1;
    NSString * title = [_catalogArr objectAtIndex:index];
    YHJDetailViewController * searchResult = [[YHJDetailViewController alloc] init];
    searchResult.lTitle = title;
    [searchResult setLTitle:title];
    [self.navigationController pushViewController:searchResult animated:YES];
    searchResult = nil;
}



-(void)configureImagesArrayWithObj:(NSDictionary *)dic
{
    [imagesArray addObject:dic];
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i = 0 ;i < [imagesArray count];i++) {
        NSDictionary *dic = [imagesArray objectAtIndex:i];
        UIImageView * imageview = [[UIImageView alloc]initWithImage:dic[@"FecthImage"]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToAdViewcontroller:)];
        [imageview addGestureRecognizer:tapGesture];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i;
        [tempArray addObject:imageview];
    }
    
    
    if([self.view.subviews containsObject:scrollView])
    {
        [scrollView removeFromSuperview];
    }
    
    scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 108) withViews:tempArray];
    [self.view addSubview:scrollView];
    
}



-(void)pushToAdViewcontroller:(UIGestureRecognizer *)recon
{
    NSLog(@"%s",__func__);
    UIImageView * tempImg = (UIImageView *)recon.view;
    NSDictionary * dic = [imagesArray objectAtIndex:tempImg.tag];
    NSLog(@"%@",dic[@"url"]);
    __weak YHJViewController *viewController = self;
    [HttpHelper getSpecificUrlContentOfAdUrl:dic[@"url"] completedBlock:^(id item, NSError *error) {
         [viewController performSelector:@selector(adView:) withObject:item];

    }];
  }

-(void)adView:(id)obj
{
    AdViewController * viewController = [[AdViewController alloc]initWithNibName:@"AdViewController" bundle:nil];
    [viewController setContentStr:(NSString *)obj];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
}

@end
