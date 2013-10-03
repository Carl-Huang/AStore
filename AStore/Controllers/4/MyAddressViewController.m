//
//  MyAddressViewController.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
#define VUserName           @"userName"
#define VTelePhone          @"vtelephone"
#define VPhone              @"vphone"
#define VAddress            @"vaddress"



#import "MyAddressViewController.h"
#import "UIViewController+LeftTitle.h"
#import "AddressCell.h"

static NSString * cellIdentifier = @"addressCell";
@interface MyAddressViewController ()
@property (strong ,nonatomic)NSArray * dataSource;
@end

@implementation MyAddressViewController
@synthesize dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = @[@{VUserName: @"carl",VTelePhone:@"1233423523",VAddress:@"广州市天河区收购领路是打飞机你是",VPhone:@"8886666"}];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"地址管理"];
    UINib * cellNib = [UINib nibWithNibName:@"AddressCell" bundle:[NSBundle bundleForClass:[AddressCell class]]];
    [self.addressTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];

    UIImage * backImg = [UIImage imageNamed:@"删除btn"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(newItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;

    // Do any additional setup after loading the view from its nib.
}

-(void)newItem
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAddressTable:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    CommodityInfoCell * cell = [tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = nil;
    cell = [self.addressTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.userNameLabel.text = [[dataSource objectAtIndex:indexPath.row]objectForKey:VUserName];
    cell.telephoneLabel.text = [[dataSource objectAtIndex:indexPath.row]objectForKey:VTelePhone];
    cell.phoneLabel.text = [[dataSource objectAtIndex:indexPath.row]objectForKey:VPhone];
    cell.addressInfoLabel.text = [[dataSource objectAtIndex:indexPath.row]objectForKey:VAddress];
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
