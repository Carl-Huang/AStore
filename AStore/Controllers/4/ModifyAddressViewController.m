//
//  ModifyAddressViewController.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//

#import "ModifyAddressViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "AddAddressCell.h"
static NSString * const cellIdentifier = @"cellIdentifier";
@interface ModifyAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITextField * nameField;
    UITextField * phoneField;
    UITextField * fixedTelField;
}
@property (nonatomic ,strong) __block NSArray * regionInfoDic;
@end

@implementation ModifyAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"修改地址"];
    [self setBackItem:nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"AddAddressCell" bundle:[NSBundle bundleForClass:[AddAddressCell class]]];
    [self.addressTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    UIView * bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    [self.addressTable setBackgroundView:bgView];
    //获取地区信息
    NSString *cmdStr = [NSString stringWithFormat:@"getRegion=getregion"];
    cmdStr = [cmdStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpHelper postRequestWithCmdStr:cmdStr SuccessBlock:^(NSArray *resultInfo) {
        self.regionInfoDic = resultInfo;
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)saveBtnAction:(id)sender {
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 130.0f;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma  mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    if (normalCell==nil) {
        normalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row == 0)
    {
        normalCell.textLabel.text = @"*姓名: ";
        nameField = [[UITextField alloc]initWithFrame:CGRectMake(95, 15, 260, 40)];
        [normalCell.contentView addSubview:nameField];
        
    }
    if(indexPath.row == 1)
    {
        normalCell.textLabel.text = @"*手机: ";
        phoneField = [[UITextField alloc]initWithFrame:CGRectMake(95, 15, 260, 40)];
        [normalCell.contentView addSubview:phoneField];
    }
    if(indexPath.row == 2)
    {
        normalCell.textLabel.text = @"固定电话: ";
        fixedTelField = [[UITextField alloc]initWithFrame:CGRectMake(95,15, 200, 40)];
        [normalCell.contentView addSubview:fixedTelField];
    }
    if (indexPath.row == 3) {
        AddAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    normalCell.backgroundColor = [UIColor clearColor];
    return normalCell;
}

@end
