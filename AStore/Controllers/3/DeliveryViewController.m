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

static NSString * cellIdentifier = @"cellIdentifier";
@interface DeliveryViewController ()
@property (strong ,nonatomic)NSArray * dataSourece;

@end

@implementation DeliveryViewController
@synthesize dataSourece;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSourece = @[@{TimeToReach: @"当日16：00-16：90  到货",AdditionMoney:@"＋￥ 2.00",DeliveryTimeLimitation:@"该到货时间，请在16：40下单",AwardMethod:@"满30 元免送费"}];
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
-(void)checkBtnAction
{
    NSLog(@"%s",__func__);
}

- (IBAction)deliveryBtnAction:(id)sender {
    NSLog(@"%s",__func__);
}

#pragma mark TableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    cell.timeToReach.text = [[dataSourece objectAtIndex:indexPath.row]objectForKey:TimeToReach];
    cell.timeLimitation.text = [[dataSourece objectAtIndex:indexPath.row]objectForKey:DeliveryTimeLimitation];
    cell.awardMethod.text = [[dataSourece objectAtIndex:indexPath.row]objectForKey:AwardMethod];
    cell.additionMoney.text = [[dataSourece objectAtIndex:indexPath.row]objectForKey:AdditionMoney];
    [cell.checkBtn addTarget:self action:@selector(checkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;

}

@end
