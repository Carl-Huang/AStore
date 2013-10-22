//
//  ModifyAddressViewController.m
//  AStore
//
//  Created by vedon on 10/3/13.
//  Copyright (c) 2013 carl. All rights reserved.
//
#define FirstPickerViewTag      101
#define SecondPickerViewTag     102
#define ThirdPickerViewTag      103
#define FixedTextFieldTag       201
#define PickerViewOffsetY       (([[UIScreen mainScreen] bounds].size.height == 568)?0:-140)
#define AssociateObjcKey        @"associateobjkey"


#import "ModifyAddressViewController.h"
#import "UIViewController+LeftTitle.h"
#import "HttpHelper.h"
#import "AddAddressCell.h"
#import "Region.h"
#import "constants.h"
#import "User.h"
#import "AppDelegate.h"
#import "AddressInfo.h"
#import "MyAddressViewController.h"
static NSString * const cellIdentifier = @"cellIdentifier";
@interface ModifyAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    UITextField * nameField;
    UITextField * phoneField;
    UITextField * fixedTelField;
    NSMutableSet * set;
    NSString * firstPickerViewSelectedStr;
    NSString * secondPickerViewSelectedStr;
    NSString * thirdPickerViewSelectedStr;
    NSString * name;
    NSString * phone;
    NSString * tel;
    
    NSString * addressTextFieldText;
    UIView * viewforPickerView;
    CGRect originTableFrame;
}
@property (strong ,nonatomic)UIPickerView * pickerViewOne;
@property (strong ,nonatomic)UIPickerView * pickerViewTwo;
@property (strong ,nonatomic)UIPickerView * pickerViewThree;
@property (strong ,nonatomic)NSMutableArray * dataSourceOne;
@property (strong ,nonatomic)NSMutableArray * dataSourceTwo;
@property (strong ,nonatomic)NSMutableArray * dataSourceThree;


@property (nonatomic ,strong) __block NSArray * regionInfoDic;
@end

@implementation ModifyAddressViewController
@synthesize pickerViewOne,pickerViewTwo,pickerViewThree;
@synthesize dataSourceOne,dataSourceTwo,dataSourceThree;
@synthesize modifitedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSourceOne   = [NSMutableArray array];
        dataSourceTwo   = [NSMutableArray array];
        dataSourceThree = [NSMutableArray array];
        
        modifitedData = nil;
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
    if (modifitedData) {
        name    = modifitedData.name;
        phone   = modifitedData.mobile;
        tel     = modifitedData.tel;
        addressTextFieldText = modifitedData.addr;
        
        firstPickerViewSelectedStr  = @"";
        secondPickerViewSelectedStr = @"";
        thirdPickerViewSelectedStr  = @"";
    }else
    {
        name    = nil;
        phone   = nil;
        tel     = nil;
        addressTextFieldText = nil;
        firstPickerViewSelectedStr  = @"";
        secondPickerViewSelectedStr = @"";
        thirdPickerViewSelectedStr  = @"";
    }
    [self setupTextField];
    originTableFrame = self.addressTable.frame;
}

-(void)viewWillAppear:(BOOL)animated
{
    ModifyAddressViewController * weakSelf = self;
    [HttpHelper getRegionWithSuccessBlock:^(NSArray * array) {
        [weakSelf getRegionTyepWithDataArray:array];
    } failedBlock:^(NSError *error) {
        ;
    }];
}

-(void)resetTableviewFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        self.addressTable.frame = CGRectOffset(self.addressTable.frame, 0, -PickerViewOffsetY);
    }];
}

-(void)getRegionTyepWithDataArray:(NSArray *)array
{
    set = [NSMutableSet set];
    for (Region * region in array) {
        [set addObject:region.region_grade];
    }
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSString * str = (NSString * )obj;
        for (Region * region in array) {
            if ([region.region_grade isEqualToString:str]) {
                switch ([str integerValue]) {
                    case 1:
                        [dataSourceOne addObject:region];
                        break;
                    case 2:
                        [dataSourceTwo addObject:region];
                        break;
                    case 3:
                        [dataSourceThree addObject:region];
                        break;
                    default:
                        break;
                }
            }
        }
        NSInteger sumCount = [dataSourceOne count]+[dataSourceTwo count]+ [dataSourceThree count];
        if (sumCount == [array count]) {
            
            //默认选中数据中的第一项
            Region * region1 = [dataSourceOne objectAtIndex:0];
            firstPickerViewSelectedStr = region1.local_name;
            Region * region2 = [dataSourceTwo objectAtIndex:0];
            secondPickerViewSelectedStr = region2.local_name;
            Region * region3 = [dataSourceThree objectAtIndex:0];
            thirdPickerViewSelectedStr = region3.local_name;
            [self.addressTable reloadData];
            
            //初始化pickerView
            [self setupPicketView];
        }
    }];
    
}

-(void)setupPicketView
{
    CGRect rect;
    CGRect rectViewForPickerView;
    if (!IS_SCREEN_4_INCH) {
        rect  = CGRectMake(0, 44, 320, 256);
        rectViewForPickerView = CGRectMake(0, 150, 320, 300);
    }else
    {
        rect  = CGRectMake(0, 44, 320, 256);
        rectViewForPickerView = CGRectMake(0, 240, 320, 300);
    }

    viewforPickerView = [[UIView alloc]initWithFrame:rectViewForPickerView];

    UIToolbar * toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320.0,44.0)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(hidePickerView)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = [[NSArray alloc] initWithObjects:flexibleSpaceLeft,barButtonDone,nil];
    barButtonDone.tintColor=[UIColor blackColor];
    [viewforPickerView addSubview:toolBar];
    
    pickerViewOne = [[UIPickerView alloc] initWithFrame:rect];
    pickerViewOne.dataSource = self;
    pickerViewOne.delegate = self;
    pickerViewOne.tag = FirstPickerViewTag;
    pickerViewOne.showsSelectionIndicator = YES;
    [pickerViewOne setHidden:YES];
    [viewforPickerView addSubview:pickerViewOne];
    
    
    pickerViewTwo = [[UIPickerView alloc] initWithFrame:rect];
    pickerViewTwo.dataSource = self;
    pickerViewTwo.delegate = self;
    pickerViewTwo.tag = SecondPickerViewTag;
    pickerViewTwo.showsSelectionIndicator = YES;
    [pickerViewTwo setHidden:YES];
    [viewforPickerView addSubview:pickerViewTwo];
    
    
    pickerViewThree = [[UIPickerView alloc] initWithFrame:rect];
    pickerViewThree.dataSource = self;
    pickerViewThree.delegate = self;
    pickerViewThree.tag = ThirdPickerViewTag;
    pickerViewThree.showsSelectionIndicator = YES;
    [pickerViewThree setHidden:YES];
    [viewforPickerView addSubview:pickerViewThree];
    
    
    [viewforPickerView setHidden:YES];
    [self.view addSubview:viewforPickerView];

}

-(void)hidePickerView
{
    [self resetTableviewFrame];
    [viewforPickerView setHidden:YES];
    [pickerViewThree setHidden:YES];
    [pickerViewTwo setHidden:YES];
    [pickerViewOne setHidden:YES];
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
- (IBAction)saveBtnAction:(id)sender
{
    NSString * areaStr = [NSString stringWithFormat:@"%@%@%@",firstPickerViewSelectedStr,secondPickerViewSelectedStr,thirdPickerViewSelectedStr];
    NSString * fixedPhoneNum = nil;
    if (fixedTelField.text) {
        fixedPhoneNum = fixedTelField.text;
    }else
        fixedPhoneNum = @"";
    ModifyAddressViewController *weakSelf = self;
    if (fixedTelField.text) {
        fixedPhoneNum = fixedTelField.text;
    }else
        fixedPhoneNum = @"";
    
    
    if (modifitedData == nil) {
        //新增地址信息
        if (!nameField.text) {
            [self showAlertViewWithTitle:@"提示" message:@"名字不能为空"];
            return;
        }
        if (!phoneField.text) {
            [self showAlertViewWithTitle:@"提示" message:@"手机不能为空"];
            return;
        }
        
        //TODO: memberId 有问题
        [self showProcessingView];
        NSDictionary * userInfoDic = [User getUserInfo];
        
        [HttpHelper addNewAddress:[userInfoDic objectForKey:DMemberId] name:nameField.text area:areaStr addr:addressTextFieldText mobile:phoneField.text tel:fixedPhoneNum withCompletedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }
            NSArray * array = item;
            for (NSDictionary * dic in array) {
                if ([[dic objectForKey:RequestStatusKey]integerValue] == 1) {
                    NSLog(@"添加地址成功");
                    [weakSelf performSelectorOnMainThread:@selector(hideProcessingViewAndBackToParentView) withObject:nil waitUntilDone:NO];
                }else
                {
                    NSLog(@"添加地址失败");
                    [weakSelf hideprocessingView];
                    [weakSelf showAlertViewWithTitle:@"提示" message:@"添加地址失败"];
                }
            }
        }];
    }else
    {
        //修改地址信息
        [self showProcessingView];
        [HttpHelper updateAddressId:modifitedData.addr_id name:nameField.text area:areaStr addrs:addressTextFieldText mobile:phoneField.text tel:fixedPhoneNum withCompletedBlock:^(id item, NSError *error) {
            if (error) {
                NSLog(@"%@",[error description]);
            }
            NSArray * array = item;
            for (NSDictionary * dic in array) {
                if ([[dic objectForKey:RequestStatusKey]integerValue] == 1) {
                    NSLog(@"更新地址成功");
                    [weakSelf performSelectorOnMainThread:@selector(hideProcessingViewAndBackToParentView) withObject:nil waitUntilDone:NO];
                }else
                {
                    NSLog(@"更新地址失败");
                    [weakSelf hideprocessingView];
                    [weakSelf showAlertViewWithTitle:@"提示" message:@"更新地址失败"];
                }
            }

        }];
    }
    
}

-(void)showProcessingView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate showLoginViewOnView:self.view];

}

-(void)hideprocessingView
{
    NSLog(@"%s",__func__);
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
    //回到上一层界面
}

-(void)hideProcessingViewAndBackToParentView
{
    NSLog(@"%s",__func__);
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [myDelegate removeLoadingViewWithView:nil];
    NSArray * viewControllers = self.navigationController.viewControllers;
    for (UIViewController * viewController in viewControllers) {
        if ([viewController isKindOfClass:[MyAddressViewController class]]) {
            [viewController performSelector:@selector(fetchDataFromServer)];
        }
    }
    
    //回到上一层界面
    [self.navigationController popViewControllerAnimated:YES];
}
-(textFieldConfigureBlock)configureTextFieldBlock
{
    textFieldConfigureBlock block = ^(id item)
    {
        if (originTableFrame.origin.y == self.addressTable.frame.origin.y) {
            if (!IS_SCREEN_4_INCH) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.addressTable.frame = CGRectOffset(self.addressTable.frame, 0,PickerViewOffsetY+40);
                }];
            }
        
        }else
        {
            if (!IS_SCREEN_4_INCH) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.addressTable.frame = CGRectOffset(self.addressTable.frame, 0,-PickerViewOffsetY-40);
                }];
            }
        
        }
        
        addressTextFieldText = (NSString *)item;
    };
    return block;
}

-(void)setupTextField
{
    CGRect textFieldRect = CGRectMake(95, 10, 260, 50);
    nameField = [[UITextField alloc]initWithFrame:textFieldRect];
    nameField.text = name;
    nameField.delegate = self;
    
    phoneField = [[UITextField alloc]initWithFrame:textFieldRect];
    phoneField.text = phone;
    phoneField.delegate =self;
    
    fixedTelField = [[UITextField alloc]initWithFrame:textFieldRect];
    fixedTelField.delegate = self;
    fixedTelField.text = tel;
    fixedTelField.tag = FixedTextFieldTag;
    fixedTelField.returnKeyType = UIReturnKeyDone;
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
        [normalCell.contentView addSubview:nameField];
    }
    if(indexPath.row == 1)
    {
        normalCell.textLabel.text = @"*手机: ";
        [normalCell.contentView addSubview:phoneField];
    }
    if(indexPath.row == 2)
    {
        normalCell.textLabel.text = @"固定电话: ";
        [normalCell.contentView addSubview:fixedTelField];
    }
    if (indexPath.row == 3) {
        AddAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFirstBlock:^()
         {
             [UIView animateWithDuration:0.3 animations:^{
                 self.addressTable.frame = CGRectOffset(self.addressTable.frame, 0,PickerViewOffsetY);
             }];
             [viewforPickerView setHidden:NO];
             [pickerViewOne setHidden:NO];
         }
         ];
        [cell setSecondBlock:^()
         {
             [UIView animateWithDuration:0.3 animations:^{
                 self.addressTable.frame = CGRectOffset(self.addressTable.frame, 0,PickerViewOffsetY);
             }];
             [viewforPickerView setHidden:NO];
             [pickerViewTwo setHidden:NO];
         }];
        [cell setThirdBlock:^()
         {
             [UIView animateWithDuration:0.3 animations:^{
                 self.addressTable.frame = CGRectOffset(self.addressTable.frame, 0,PickerViewOffsetY);
             }];
             [viewforPickerView setHidden:NO];
             [pickerViewThree setHidden:NO];
         }];
        [cell setTextFieldBlock:[self configureTextFieldBlock]];
        cell.firstTextField.text    = firstPickerViewSelectedStr;
        cell.secondTextfield.text   = secondPickerViewSelectedStr;
        cell.thirdTextfield.text    = thirdPickerViewSelectedStr;
        cell.fourthTextfield.text   = addressTextFieldText;
        return cell;
    }
    normalCell.backgroundColor = [UIColor clearColor];
    return normalCell;
}


#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Region * region = nil;
    if (pickerView.tag == FirstPickerViewTag) {
        region = [dataSourceOne objectAtIndex:row];
    }else if (pickerView.tag == SecondPickerViewTag)
    {
        region = [dataSourceTwo objectAtIndex:row];
    }else
    {
        region = [dataSourceThree objectAtIndex:row];
    }
    return region.local_name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Region * region = nil;
    if (pickerView.tag == FirstPickerViewTag) {
        region = [dataSourceOne objectAtIndex:row];
        firstPickerViewSelectedStr = region.local_name;
    }else if (pickerView.tag == SecondPickerViewTag)
    {
        region = [dataSourceTwo objectAtIndex:row];
        secondPickerViewSelectedStr = region.local_name;
    }else
    {
        region = [dataSourceThree objectAtIndex:row];
        thirdPickerViewSelectedStr = region.local_name;
    }
    [self.addressTable reloadData];
    NSLog(@"地址选择了: %@",region.local_name);
}

#pragma mark - UIPickerViewDataSourceDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == FirstPickerViewTag) {
        return [dataSourceOne count];
    }else if (pickerView.tag == SecondPickerViewTag)
    {
        return [dataSourceTwo count];
    }else
    {
        return  [dataSourceThree count];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [pAlert show];
    pAlert = nil;
    
}
@end
