//
//  DeliveryViewController.m
//  AStore
//
//  Created by vedon on 10/4/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
#define TimeToReach             @"timetoReach"
#define AdditionMoney           @"additionMoneyForDelivery"
#define DeliveryTimeLimitation  @"deliveryTimeLimitation"
#define AwardMethod             @"awardMethod"

#import "DeliveryViewController.h"
#import "DeliveryCell.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "DeliveryTypeInfo.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
static NSString * cellIdentifier = @"cellIdentifier";
static NSString * const selectKey = @"selectKey";
@interface DeliveryViewController ()
{
    NSInteger preSelectItem;
    NSInteger selectItem;
    NSMutableDictionary * selectItemsDic;
}
@property (strong ,nonatomic)NSArray * dataSourece;

@end

@implementation DeliveryViewController
@synthesize dataSourece;
@synthesize deliveryMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.dataSourece = @[@{TimeToReach: @"当日16：00-16：90  到货",AdditionMoney:@"＋￥ 2.00",DeliveryTimeLimitation:@"该到货时间，请在16：40下单",AwardMethod:@"满30 元免送费"}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"配送方式"];
    [self setBackItem:nil];
    UINib * cellNib = [UINib nibWithNibName:@"DeliveryCell" bundle:[NSBundle bundleForClass:[DeliveryCell class]]];
    [self.deliveryTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    // Do any additional setup after loading the view from its nib.
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate showLoginViewOnView:self.view];
    selectItemsDic = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated
{

    __weak DeliveryViewController * weakSelf = self;
    [HttpHelper getDeliveryTypeWithCompletedBlock:^(id item, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]);
        }
        if ([item count]) {
            weakSelf.dataSourece = item;
            for (int i = 0; i< weakSelf.dataSourece.count; i++) {
                [selectItemsDic setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            NSInteger selectTag = -1;
            selectTag = [[NSUserDefaults standardUserDefaults]integerForKey:@"selectDeliveryTag"];
            if (selectTag != -1 && selectTag < [item count]) {
                [selectItemsDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%d",selectTag]];
                 objc_setAssociatedObject(self, (__bridge const void *)(selectKey), [weakSelf.dataSourece objectAtIndex:selectTag], OBJC_ASSOCIATION_RETAIN);
            }
            
            [weakSelf.deliveryTable reloadData];
            
        }
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [myDelegate removeLoadingViewWithView:nil];

    }];
}

//去掉html 标签
-(NSString *)html:(NSString *)html TrimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDeliveryTable:nil];
    [self setDeliveryBtn:nil];
    [super viewDidUnload];
}
-(void)checkBtnAction:(id)sender
{
    NSLog(@"%s",__func__);
    UIButton * btn = (UIButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];
}

- (IBAction)deliveryBtnAction:(id)sender {
    NSLog(@"%s",__func__);
    self.deliveryMethod = objc_getAssociatedObject(self, (__bridge const void *)(selectKey));
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置全部item的标志位为0
    for (int i = 0 ;i <[selectItemsDic count]; i++) {
        [selectItemsDic setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    //设置选中item的标志位为 1
    [selectItemsDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"selectDeliveryTag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //取出对应的信息
    DeliveryTypeInfo * info = [self.dataSourece objectAtIndex:indexPath.row];
    objc_setAssociatedObject(self, (__bridge const void *)(selectKey), info, OBJC_ASSOCIATION_RETAIN);
    [tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSourece count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryCell * cell = [self.deliveryTable dequeueReusableCellWithIdentifier:cellIdentifier];
    DeliveryTypeInfo * info = [self.dataSourece objectAtIndex:indexPath.row];
    cell.timeToReach.text = info.dt_name;
    cell.timeLimitation.text = [self html:info.detail TrimWhiteSpace:YES];
    [cell.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[selectItemsDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] integerValue] == 1) {
        [cell.checkBtn setImage:[UIImage imageNamed:@"单选btn-s@2x"] forState:UIControlStateNormal];

    }else
    {
        [cell.checkBtn setImage:[UIImage imageNamed:@"单选btn-n@2x"] forState:UIControlStateNormal];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;

}

@end
