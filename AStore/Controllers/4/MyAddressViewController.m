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
#define AddressAlerMessage @"获取地址失败，是否重新获取"


#import "MyAddressViewController.h"
#import "UIViewController+LeftTitle.h"
#import "AddressCell.h"
#import "constants.h"
#import "ModifyAddressViewController.h"
#import "HttpHelper.h"
#import "AddressInfo.h"
#import "AppDelegate.h"
static NSString * cellIdentifier = @"addressCell";
@interface MyAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isAlertViewCanShow;
    UIBarButtonItem * newItem;
    UIBarButtonItem * deleteItem;
    UIBarButtonItem * backItem;
}
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
    newItem = [[UIBarButtonItem alloc] initWithCustomView:newItemBtn];
    
    UIImage * deleteItemImg = [UIImage imageNamed:@"删除btn"];
    UIButton * deleteItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteItemBtn setFrame:CGRectMake(0, 0, deleteItemImg.size.width, deleteItemImg.size.height)];
    [deleteItemBtn setBackgroundImage:newItemImg forState:UIControlStateNormal];
    [deleteItemBtn setTitle:@"完成" forState:UIControlStateNormal];
    [deleteItemBtn addTarget:self action:@selector(endDeleteMode) forControlEvents:UIControlEventTouchUpInside];
    deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteItemBtn];
    
    UIImage *backImg = [UIImage imageNamed:@"返回btn"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItems = @[backItem,newItem];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  showLoginViewOnView:self.view];
    isAlertViewCanShow = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
     if ([dataSource count] == 0) {
         [self fetchDataFromServer];
     }
}

-(void)fetchDataFromServer
{
    MyAddressViewController *weakSelf= self;
    if (memberId) {
        NSLog(@"Member ID :%@",memberId);
        
    }
    NSString *cmdStr = [NSString stringWithFormat:@"getAddrs=%@",memberId];
    cmdStr = [SERVER_URL_Prefix stringByAppendingString:cmdStr];
    [HttpHelper requestWithString:cmdStr withClass:[AddressInfo class] successBlock:^(NSArray *items) {
        [weakSelf.dataSource removeAllObjects];
        for (AddressInfo * address in items) {
            [dataSource addObject:address];
        }
        [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
    } errorBlock:^(NSError *error) {
        ;
        if (error) {
            [self performSelectorOnMainThread:@selector(reloadTableview) withObject:nil waitUntilDone:YES];
            [self showAlertViewWithTitle:@"提示" message:AddressAlerMessage];
            NSLog(@"获取地址失败：%@",[error description]);
        }
    }];
}

-(void)reloadTableview
{
    NSLog(@"%s",__func__);
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate  removeLoadingViewWithView:nil];
    [self.addressTable reloadData];
}

- (void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    if (isAlertViewCanShow) {
        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        pAlert.delegate = self;
        [pAlert show];
        pAlert = nil;
    }
}
-(void)newItem
{
    NSLog(@"%s",__func__);
    ModifyAddressViewController * viewcontroller = [[ModifyAddressViewController alloc]initWithNibName:@"ModifyAddressViewController" bundle:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    viewcontroller  = nil;

}

-(void)endDeleteMode
{
    self.navigationItem.rightBarButtonItems = @[backItem,newItem];
    [self.addressTable setEditing:NO animated:YES];
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
    [cell setAddressInfo:address];
    cell.userNameLabel.text = address.name;
    cell.telephoneLabel.text = address.tel;
    cell.phoneLabel.text = address.mobile;
    NSString * areaInfo = [address.area stringByAppendingString:address.addr];
    cell.addressInfoLabel.text = areaInfo;
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressInfo *cellInfo = [dataSource objectAtIndex:indexPath.row];
        [HttpHelper deleteAddressWithAddressId:cellInfo.addr_id completedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }
            NSArray * array = item;
            for (NSDictionary * dic in array) {
                if ([[dic objectForKey:RequestStatusKey]integerValue] == 1) {
                    NSLog(@"删除地址成功");
                }else
                {
                    NSLog(@"删除地址失败");
                }
            }
            
        }];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.addressTable reloadData];
    }
}

-(void)configureCellBlockWithCell:(AddressCell *)cell
{
    configureAddressBlock block = ^(id item1,id item2)
    {
        NSLog(@"configureAddressBlock processing");
        UIButton * btn = (UIButton *)item1;
        if (btn.tag == chooseBtnTag) {
            if ([btn.titleLabel.text isEqualToString:@"选择"]) {
                [item1 setTitle:@"已选" forState:UIControlStateNormal];
            }else
            {
                [item1 setTitle:@"选择" forState:UIControlStateNormal];
            }
        }else if (btn.tag == alterBtnTag)
        {
            ModifyAddressViewController * viewController = [[ModifyAddressViewController alloc]initWithNibName:@"ModifyAddressViewController" bundle:nil];
            [viewController setModifitedData:item2];
            [self.navigationController pushViewController:viewController animated:YES];
            viewController = nil;
        }else if (btn.tag == deleteBtnTag)
        {
            self.navigationItem.rightBarButtonItems = @[backItem,deleteItem];
            [self.addressTable setEditing:YES animated:YES];
        }else
            NSLog(@"Other Tag");
        
        
        NSLog(@"%d",btn.tag);
    };
    [cell setConfigureBlock:block];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self fetchDataFromServer];
            break;
        case 0:
//            [self.navigationController popViewControllerAnimated:YES];
        default:
            break;
    }
}
@end
