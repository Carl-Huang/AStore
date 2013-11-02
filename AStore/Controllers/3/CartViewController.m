//
//  CartViewController.m
//  AStore
//
//  Created by Carl on 13-9-26.
//  Copyright (c) 2013年 carl. All rights reserved.
//

#import "CartViewController.h"
#import "UIViewController+LeftTitle.h"
#import "constants.h"
#import "CartCell.h"
#import "CartCellHeader.h"
#import "ConfirmOrderViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Commodity.h"
#import "HttpHelper.h"
#import "UIImageView+AFNetworking.h"
#import "NSMutableArray+SaveCustomiseData.h"
#import "GetGiftInfo.h"
#import "ProductStoreInfo.h"
#import "GiftStoreInfo.h"

typedef NS_ENUM(NSInteger, ActionType)
{
    PlusAction = 1,
    MinusAction = 2,
};

static NSString * cellIdentifier = @"cartCellIdentifier";
static NSString * cellHeaderIdentifier = @"cartCellHeaderIdentifier";
@interface CartViewController ()
{
    BOOL isSectionOneFirstShow;
    BOOL isSectionTwoFirstShow;
    BOOL isCommodityCheckout;
    BOOL isGiftCheckout;
    BOOL isShouldShowSectionOneRows;
    BOOL isShouldShowSectionTwoRows;
    BOOL isViewFirstShow;
    NSMutableDictionary * commodityDicInfo;
    NSMutableDictionary * presentDicInfo;
    float commoditySumMoney;
    float giftSumMoney;
    NSMutableArray * productIdStoreArray;
    NSMutableArray * giftIdStoreArray;
}
@property (strong ,nonatomic)NSArray * dataSource;
@property (strong ,nonatomic)NSArray * giftArray;
@end

@implementation CartViewController
@synthesize dataSource;
@synthesize giftArray;

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
    [self setLeftTitle:@"购物车"];
    UIImage * newItemImg = [UIImage imageNamed:@"删除btn"];
    UIButton * newItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newItemBtn setFrame:CGRectMake(0, 0, newItemImg.size.width, newItemImg.size.height)];
    [newItemBtn setBackgroundImage:newItemImg forState:UIControlStateNormal];
    [newItemBtn setTitle:@"删除" forState:UIControlStateNormal];
    [newItemBtn addTarget:self action:@selector(deleteItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * newItem = [[UIBarButtonItem alloc] initWithCustomView:newItemBtn];
    self.navigationItem.rightBarButtonItem = newItem;
    newItem = nil;
    
    UINib * cellNib = [UINib nibWithNibName:@"CartCell" bundle:[NSBundle bundleForClass:[CartCell class]]];
    [self.cartTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    
    UINib * cell2Nib = [UINib nibWithNibName:@"CartCellHeader" bundle:[NSBundle bundleForClass:[CartCellHeader class]]];
    [self.cartTable registerNib:cell2Nib forCellReuseIdentifier:cellHeaderIdentifier];
    
    [self.cartTable setEditing:YES];
    
    isSectionTwoFirstShow = YES;
    isSectionOneFirstShow = YES;
    isCommodityCheckout = YES;
    isGiftCheckout = YES;
    isShouldShowSectionOneRows = YES;
    isShouldShowSectionTwoRows = YES;
    isViewFirstShow = YES;
    commodityDicInfo = [[NSMutableDictionary alloc]init];
    presentDicInfo = [NSMutableDictionary dictionary];
    giftSumMoney = 0.0;
    commoditySumMoney = 0.0;
    
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    self.dataSource  = myDelegate.commodityArray;
    self.giftArray = myDelegate.presentArray;
    
  
    
    //注册一个通知，当商品，或赠品提交后更新tableivew 中cell的选中状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCommodityCellStatus:) name:CommodityCellStatus object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePresentCellStatus:) name:PresentCellStatus object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateCommodityCellStatus:(NSNotification *)notification
{
    //更新cell的状态
    for (int i = 0; i < [self.dataSource count];i++) {
        if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
            NSLog(@"removeObj at index :%d",i);
            NSString * key = [NSString stringWithFormat:@"%d",i+1];
            [commodityDicInfo removeObjectForKey:key];
        }
    }
}

-(void)updatePresentCellStatus:(NSNotification *)notification
{
    //更新cell的状态
    for (int i = 0; i < [self.dataSource count];i++) {
        if ([[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
            NSLog(@"removeObj at index :%d",i);
            NSString * key = [NSString stringWithFormat:@"%d",i+1];
            [presentDicInfo removeObjectForKey:key];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取商品,赠品 对应的库存量
    [self getStoreInfo];
    
    if (isViewFirstShow) {
        isViewFirstShow = NO;
        for (int i = 0;  i<dataSource.count; i++) {
            [commodityDicInfo setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        for (int i = 0;  i<giftArray.count; i++) {
            [presentDicInfo setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        
    }
    [self.cartTable reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)getStoreInfo
{
    productIdStoreArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.dataSource count]; i++) {
        NSDictionary * dic = [dataSource objectAtIndex:i];
        Commodity * info = [dic objectForKey:@"commodity"];
        [productIdStoreArray addObject:info.product_id];
    }
    [HttpHelper getProductStoreWithProductId:productIdStoreArray withCompletedBlock:^(id item, NSError *error) {
        ;
        if (error) {
            NSLog(@"%@",[error description]);
            return ;
        }
        [productIdStoreArray removeAllObjects];
        productIdStoreArray =item;
        if ([productIdStoreArray count]) {
            for (ProductStoreInfo * info in productIdStoreArray) {
                NSLog(@"%@: %@",info.product_id,info.store);
            }
        }
    }];
    
    
    giftIdStoreArray = [NSMutableArray array];
    for (int i = 0; i < [self.giftArray count]; i++) {
        NSDictionary * dic = [giftArray objectAtIndex:i];
        GetGiftInfo * info = [dic objectForKey:@"present"];
        [giftIdStoreArray addObject:info.point];
    }
    [HttpHelper getGiftStoreWithGiftId:giftIdStoreArray withCompletedBlock:^(id item, NSError *error) {
        ;
        if (error) {
            NSLog(@"%@",[error description]);
            return ;
        }
        [giftIdStoreArray removeAllObjects];
        giftIdStoreArray =item;
        if ([giftIdStoreArray count]) {
            for (GiftStoreInfo * info in giftIdStoreArray) {
                NSLog(@"%@: %@",info.gift_id,info.storage);
            }
        }
    }];
}

-(void)deleteItemAction
{
    NSLog(@"%s",__func__);
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];

    //清理选中的商品或者
    for (int i = 0; i < [self.dataSource count];i++) {
        if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
            [myDelegate.commodityArray removeObjectAtIndex:i];
            [commodityDicInfo setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    for (int i = 0; i < [self.giftArray count];i++) {
        if ([[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
            [myDelegate.presentArray removeObjectAtIndex:i];
            [presentDicInfo setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    
    //写回本地数据
    [NSMutableArray archivingObjArray:myDelegate.commodityArray withKey:@"CommodityArray"];
    [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
    
    //刷新tableview
    [self.cartTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)tabImageName
{
	return @"购物车icon-n";
}

- (void)viewDidUnload {
    [self setCartTable:nil];
    [super viewDidUnload];
}

-(void)hideSectionOneRows
{
    NSLog(@"%s",__func__);
    isShouldShowSectionOneRows = !isShouldShowSectionOneRows;
    [self.cartTable reloadData];
}

-(void)hideSectionTwoRows
{
    NSLog(@"%s",__func__);
    isShouldShowSectionTwoRows = !isShouldShowSectionTwoRows;
    [self.cartTable reloadData];
}

//获取订单中的物品
-(NSArray *)getCommodityProduct
{
    NSMutableArray * array = [NSMutableArray array];
    if (isCommodityCheckout) {
        for (int i = 0; i < [self.dataSource count];i++) {
            NSDictionary * dic =  [self.dataSource objectAtIndex:i];
            if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
                [array addObject:dic];
            }
        }
        return array;
    }
    return nil;
    
}

-(NSArray *)getGiftProduct
{
    NSMutableArray * array = [NSMutableArray array];
    if (isGiftCheckout) {
        for (int i = 0; i < [self.giftArray count];i++) {
            NSDictionary * dic =  [self.giftArray objectAtIndex:i];
            if ([[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
                [array addObject:dic];
            }
        }
        return array;
    }
    return nil;
}

-(CartCell *)configureCommodityCell:(CartCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];

    [cell setMunisBlock:[self cellMinusBlock]];
    [cell setPlusBlock:[self cellPlusBlock]];
    NSInteger row = indexPath.row -1;
    NSDictionary * dic = [dataSource objectAtIndex:row];
    NSNumber * produceNum = [dic objectForKey:@"count"];
    Commodity * info = [dic objectForKey:@"commodity"];
    NSString * imageUrlStr = [HttpHelper extractImageURLWithStr:info.small_pic];
    __weak CartCell *weakCell = cell;
    NSURL *url = [NSURL URLWithString:imageUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [cell.productImage setImageWithURLRequest:request placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          [weakCell.productImage setImage:image];
                                          [weakCell setNeedsLayout];
                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          NSLog(@"下载图片失败");
                                      }];
    cell.type = CommodityCellType;
    cell.Id = info.product_id;
    cell.productName.text = info.name;
    cell.productNumber.text = [NSString stringWithFormat:@"%@",produceNum];
    float floatString = [info.price floatValue];
    NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
    
    //金额
    cell.MoneySum.text = priceStr;
    [cell.jifenLabel setHidden:YES];
    [cell.jifen setHidden:YES];
    if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]boolValue]) {
        [cell setSelected:isCommodityCheckout animated:YES];
    }
    return cell;
}

-(CartCell *)configurePresentCell:(CartCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];

    [cell setMunisBlock:[self cellMinusBlock]];
    [cell setPlusBlock:[self cellPlusBlock]];
    [cell.jifenLabel setHidden:NO];
    [cell.jifen setHidden:NO];
    NSInteger row = indexPath.row -1;
    NSDictionary * dic = [giftArray objectAtIndex:row];
    NSNumber * produceNum = [dic objectForKey:@"count"];
    GetGiftInfo * info = [dic objectForKey:@"present"];
    NSString * imageUrlStr = [HttpHelper extractImageURLWithStr:info.small_pic];
    __weak CartCell *weakCell = cell;
    NSURL *url = [NSURL URLWithString:imageUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [cell.productImage setImageWithURLRequest:request placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          [weakCell.productImage setImage:image];
                                          [weakCell setNeedsLayout];
                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          NSLog(@"下载图片失败");
                                      }];
    cell.type = PresentCellType;
    cell.Id = info.gift_id;
    cell.productName.text = info.name;
    cell.productNumber.text = [NSString stringWithFormat:@"%@",produceNum];
    float floatString = [info.point floatValue];
    //积分
    NSString * priceStr = [NSString stringWithFormat:@"%.1f",floatString];
    cell.jifen.text = priceStr;
    //限量
    NSString * str = [NSString stringWithFormat:@"限量:%@",info.limit_num];
    cell.MoneySum.text = str;
    if ([[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]boolValue]) {
        [cell setSelected:isGiftCheckout animated:YES];
    }
    return cell;
}

#pragma  mark - Cell Block
-(CarCellMinusBlock)cellMinusBlock
{
    CarCellMinusBlock block = ^(id item,CellType type)
    {
        NSLog(@"%s",__func__);
        if (type == CommodityCellType) {
            [self alterCommodityNumWithId:(NSString *)item withAction:MinusAction];
        }else
        {
            [self alterPresentNumWithId:(NSString *)item withAction:MinusAction];
        }
    };
    return block;
}

-(CarCellPlusBlock)cellPlusBlock
{
    CarCellPlusBlock block = ^(id item,CellType type)
    {
        NSLog(@"%s",__func__);
        if (type == CommodityCellType) {
            [self alterCommodityNumWithId:(NSString *)item withAction:PlusAction];
        }else
        {
            [self alterPresentNumWithId:(NSString *)item withAction:PlusAction];
        }
    };
    return block;
}

-(CloseAccountActionBlock)configureCloseAccountBlock
{
    CloseAccountActionBlock block = ^()
    {
        if(![User isLogin])
        {
            LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginView.view.tag = 1;
            [loginView setWeakViewController:self];
            [self.navigationController pushViewController:loginView animated:YES];
            loginView = nil;
            return ;
        }

        NSLog(@"%s",__func__);
        ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        [viewController setCommoditySumMoney:commoditySumMoney];
        [viewController setGiftSumMoney:0];
        
        [self.navigationController pushViewController:viewController animated:YES];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        myDelegate.buiedCommodityArray = [self getCommodityProduct];
        viewController = nil;

    };
    return block;
}

-(CloseAccountActionBlock)configureCloseAccountGiftBlock
{
    CloseAccountActionBlock block = ^()
    {
        if(![User isLogin])
        {
            LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginView.view.tag = 1;
            [loginView setWeakViewController:self];
            [self.navigationController pushViewController:loginView animated:YES];
            loginView = nil;
            return ;
        }
        
        NSLog(@"%s",__func__);
        ConfirmOrderViewController *viewController = [[ConfirmOrderViewController alloc]initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        [viewController setGiftSumMoney:giftSumMoney];
        [viewController setCommoditySumMoney:0];
        [self.navigationController pushViewController:viewController animated:YES];
        AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        myDelegate.buiedPresentArray = [self getGiftProduct];
        viewController = nil;
    };
    return block;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        if (indexPath.section == 0) {
            BOOL bo = [[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]boolValue];
            bo = !bo;
            NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
            NSNumber * ber =[NSNumber numberWithBool:bo];
            commodityDicInfo[key] = ber;
        }
        if (indexPath.section == 1) {
            BOOL bo = [[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]boolValue];
            NSString *key = [NSString stringWithFormat:@"%d",indexPath.row];
            NSNumber * ber =[NSNumber numberWithBool:!bo];
            [presentDicInfo setObject:ber forKey:key];

        }
    }else
    {
        if (indexPath.section == 0) {
            isCommodityCheckout  = !isCommodityCheckout;
            isSectionOneFirstShow = !isSectionOneFirstShow;
        }else
        {
            isGiftCheckout = !isGiftCheckout;
            isSectionTwoFirstShow = !isSectionTwoFirstShow;
        }
       [tableView reloadData];
        return;
 
    }
    [self.cartTable beginUpdates];
    [self.cartTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    [self.cartTable endUpdates];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 45.0;
    }
    return 83.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  40.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分类背景"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 120, 35)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0 ) {
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSectionOneRows)];
        [headerView addGestureRecognizer:tapGesture];
        tapGesture = nil;
        label.text = @"购买的商品";
    } else if(section == 1){
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSectionTwoRows)];
        [headerView addGestureRecognizer:tapGesture];
        tapGesture = nil;
        label.text = @"赠品";
    }
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    imageView = nil;
    label = nil;
    return headerView;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (isShouldShowSectionOneRows) {
            return [dataSource count]+1;
        }
    }else if(section == 1)
    {
        if (isShouldShowSectionTwoRows) {
              return [giftArray count]+1;
        }
    }
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell * cell = [self.cartTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            commoditySumMoney = 0.0;
            CartCellHeader *headerCell = [self.cartTable dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
            headerCell.sumLabel.text = @"总额:";
            //算出总价格
            for (int i = 0;i < dataSource.count;i++) {
                NSDictionary  * infoDic = [dataSource objectAtIndex:i];
                Commodity * info = [infoDic objectForKey:@"commodity"];
                NSInteger num = [[infoDic objectForKey:@"count"]integerValue];
                float price = [info.price floatValue];
                if (isCommodityCheckout) {
                    if ([[commodityDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
                        commoditySumMoney += price*num;
                    }
                }else
                    commoditySumMoney = 0.0;
            }
            headerCell.moneyValue.text = [NSString stringWithFormat:@"%.1f",commoditySumMoney];
            [headerCell setBlock:[self configureCloseAccountBlock]];
            [headerCell setSelected:isCommodityCheckout animated:YES];
            return headerCell;
            
        }else
        {
            [self configureCommodityCell:cell WithIndexPath:indexPath];
        }

    }else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            giftSumMoney = 0.0;
            CartCellHeader *headerCell = [self.cartTable dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
            headerCell.sumLabel.text = @"积分:";
            
            //算出总积分
            for (int i = 0;i < giftArray.count;i++) {
                NSDictionary  * infoDic = [giftArray objectAtIndex:i];
                GetGiftInfo * info = [infoDic objectForKey:@"present"];
                NSInteger num = [[infoDic objectForKey:@"count"]integerValue];
                float price = [info.point floatValue];
                if (isGiftCheckout) {
                    if ([[presentDicInfo objectForKey:[NSString stringWithFormat:@"%d",i+1]]boolValue]) {
                        giftSumMoney += price*num;
                    }
                }else
                    giftSumMoney = 0.0;
            }
             headerCell.moneyValue.text = [NSString stringWithFormat:@"%.1f",giftSumMoney];
            [headerCell setBlock:[self configureCloseAccountGiftBlock]];
            [headerCell setSelected:isGiftCheckout animated:YES];
            return headerCell;
        }else
        {
            [self configurePresentCell:cell WithIndexPath:indexPath];

        }

    }
   
    return  cell;
}


-(void)alterCommodityNumWithId:(NSString * )productId withAction:(NSInteger)action
{
    commoditySumMoney = 0.0;
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    for (int i = 0;i<[self.dataSource count];i++) {
        NSMutableDictionary * dic = [[self.dataSource objectAtIndex:i]mutableCopy];
        Commodity * info = [dic objectForKey:@"commodity"];
        if ([productId isEqualToString:info.product_id] ) {
            if (action == MinusAction) {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                if (num == 1) {
                    //当货物数量到0件时，删除该数据
                    [myDelegate.commodityArray removeObjectAtIndex:i];
                     [NSMutableArray archivingObjArray:myDelegate.commodityArray withKey:@"PresentArray"];
                     [[NSNotificationCenter defaultCenter]postNotificationName:UpdateBadgeViewTitle object:@"minus"];
                    [self.cartTable reloadData];
                    return;
                }else
                {
                    //减少货物数量
                    num -= 1;
                    dic[@"count"] = [NSNumber numberWithInteger:num];
                    [myDelegate.commodityArray replaceObjectAtIndex:i withObject:dic];
                }
                
            }else
            {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                for (ProductStoreInfo * storeInfo in productIdStoreArray) {
                    if ([storeInfo.product_id isEqualToString: info.product_id]) {
                        if (storeInfo.store.integerValue > num) {
                            num += 1;
                            dic[@"count"] = [NSNumber numberWithInteger:num];
                            [myDelegate.commodityArray replaceObjectAtIndex:i withObject:dic];
                        }else
                        {
                            [self showAlertViewWithTitle:@"提示" message:@"库存量不足"];
                            return;
                        }
                    }
                }
            }
            [NSMutableArray archivingObjArray:myDelegate.commodityArray withKey:@"CommodityArray"];
            //更新table
            [self.cartTable beginUpdates];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable endUpdates];
        }
    }
}


-(void)alterPresentNumWithId:(NSString * )productId withAction:(NSInteger)action
{
    giftSumMoney = 0.0;
    AppDelegate * myDelegate = (AppDelegate * )[[UIApplication sharedApplication]delegate];
    for (int i = 0;i<[self.giftArray count];i++) {
        NSMutableDictionary * dic = [[self.giftArray objectAtIndex:i]mutableCopy];
        GetGiftInfo * info = [dic objectForKey:@"present"];
        if ([productId isEqualToString:info.gift_id] ) {
            if (action == MinusAction) {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                if (num == 1) {
                    //当货物数量到0件时，删除该数据
                    [myDelegate.presentArray removeObjectAtIndex:i];
                     [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
                     [[NSNotificationCenter defaultCenter]postNotificationName:UpdateBadgeViewTitle object:@"minus"];
                    [self.cartTable reloadData];
                    return;
                }else
                {
                    //减少货物数量
                    num -= 1;
                    dic[@"count"] = [NSNumber numberWithInteger:num];
                    [myDelegate.presentArray replaceObjectAtIndex:i withObject:dic];
                }
                
            }else
            {
                NSInteger  num = [[dic objectForKey:@"count"]integerValue];
                //判断是否超过限量，或者超过对应赠品的库存量
                for (GiftStoreInfo *storeInfo in giftIdStoreArray) {
                    if ([storeInfo.gift_id isEqualToString: info.gift_id]) {
                        if (storeInfo.storage.integerValue <= num) {
                            [self showAlertViewWithTitle:@"提示" message:@"库存量不足"];
                            return;
                        }else if(info.limit_num.integerValue <= num)
                        {
                            [self showAlertViewWithTitle:@"提示" message:@"超过限额"];
                            return;
                        }else
                        {
                            num += 1;
                            dic[@"count"] = [NSNumber numberWithInteger:num];
                            [myDelegate.presentArray replaceObjectAtIndex:i withObject:dic];
                            
                        }
                    }
                }
            }
            [NSMutableArray archivingObjArray:myDelegate.presentArray withKey:@"PresentArray"];
            
            //更新table
            [self.cartTable beginUpdates];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i+1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [self.cartTable endUpdates];
        }
    }
}

-(void)showAlertViewWithTitle:(NSString * )titleStr message:(NSString *)messageStr
{
        UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        pAlert.delegate = self;
        [pAlert show];
        pAlert = nil;
}
@end
