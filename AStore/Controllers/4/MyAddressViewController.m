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
#import "constants.h"
#import "ModifyAddressViewController.h"
#import "HttpHelper.h"
#import "AddressInfo.h"
static NSString * cellIdentifier = @"addressCell";
@interface MyAddressViewController ()
@property (strong ,nonatomic)NSMutableArray * dataSource;

@end

@implementation MyAddressViewController
@synthesize dataSource;
@synthesize memberId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [[NSMutableArray alloc]init];
        memberId = nil;
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

    UIImage * newItemImg = [UIImage imageNamed:@"删除btn"];
    UIButton * newItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newItemBtn setFrame:CGRectMake(0, 0, newItemImg.size.width, newItemImg.size.height)];
    [newItemBtn setBackgroundImage:newItemImg forState:UIControlStateNormal];
    [newItemBtn setTitle:@"添加" forState:UIControlStateNormal];
    [newItemBtn addTarget:self action:@selector(newItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * newItem = [[UIBarButtonItem alloc] initWithCustomView:newItemBtn];
    
    UIImage *backImg = [UIImage imageNamed:@"返回btn"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItems = @[backItem,newItem];
    backItem = nil;
    newItem = nil;

}

-(void)viewWillAppear:(BOOL)animated
{
    if (memberId) {
        NSLog(@"Member ID :%@",memberId);
        
    }
    NSString *cmdStr = [NSString stringWithFormat:@"getAddrs=%@",memberId];
    cmdStr = [SERVER_URL_Prefix stringByAppendingString:cmdStr];
    [HttpHelper requestWithString:cmdStr withClass:[AddressInfo class] successBlock:^(NSArray *items) {
        for (AddressInfo * address in items) {
            [dataSource addObject:address];
        }
        [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
    } errorBlock:^(NSError *error) {
        ;
        if (error) {
            NSLog(@"获取地址失败：%@",[error description]);
        }
    }];
}
-(void)reloadTableview
{
    NSLog(@"%s",__func__);
    [self.addressTable reloadData];
}

- (void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)newItem
{
    NSLog(@"%s",__func__);
    //TODO:增加一个地址数据
    
    //增加地址数据
    NSString *cmdStr = [NSString stringWithFormat:@"addAddrs=bb&&mid=3496&&name=carl2&&area=广东省&&addr=广州市天河区&&mobile=15018492358&&tel=15018492358"];
    
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
        ;
    } errorBlock:^(NSError *error) {
        ;
    }];
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
    AddressInfo * address = nil;
    address = [dataSource objectAtIndex:indexPath.row];
    [self configureCellBlockWithCell:cell];
    cell.userNameLabel.text = address.name;
    cell.telephoneLabel.text = address.tel;
    cell.phoneLabel.text = address.mobile;
    NSString * areaInfo = [address.area stringByAppendingString:address.addr];
    cell.addressInfoLabel.text = areaInfo;
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)configureCellBlockWithCell:(AddressCell *)cell
{
    configureAddressBlock block = ^(id item)
    {
        NSLog(@"configureAddressBlock processing");
        UIButton * btn = (UIButton *)item;
        if (btn.tag == chooseBtnTag) {
            if ([btn.titleLabel.text isEqualToString:@"选择"]) {
                [item setTitle:@"已选" forState:UIControlStateNormal];
            }else
            {
                [item setTitle:@"选择" forState:UIControlStateNormal];
            }
        }else if (btn.tag == alterBtnTag)
        {
            ModifyAddressViewController * viewController = [[ModifyAddressViewController alloc]initWithNibName:@"ModifyAddressViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            viewController = nil;
        }else if (btn.tag == deleteBtnTag)
        {
            
        }else
            NSLog(@"Other Tag");
        
        
        NSLog(@"%d",btn.tag);
    };
    [cell setConfigureBlock:block];
}
@end
