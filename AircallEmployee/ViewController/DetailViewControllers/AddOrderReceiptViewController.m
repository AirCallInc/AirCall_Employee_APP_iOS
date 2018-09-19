//
//  AddOrderReceiptViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 08/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//


#import "AddOrderReceiptViewController.h"

@interface AddOrderReceiptViewController ()<UITableViewDataSource,UITableViewDelegate>

@property NSMutableArray *arrParts;
@end

@implementation AddOrderReceiptViewController
@synthesize tblvPartList,btndDashboard,lblName,lblEmail,lblAmount,dictReceiptData,arrParts;
#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
-(void)prepareView
{
    lblName.text    = dictReceiptData[OKeyClientName];
    lblEmail.text   = dictReceiptData[OKeyEmail];
    lblAmount.text  = [NSString stringWithFormat:@"$%0.2f",
    [dictReceiptData[OKeyTotalAmt]floatValue]];
    
    tblvPartList.alwaysBounceVertical   = NO;
    NSArray *arr    = dictReceiptData[PKeyParts];
    
    arrParts        = [[NSMutableArray alloc]init];
    [arr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
    {
        ACEOrderIteam *part = [[ACEOrderIteam alloc]initWithDictionary:dict];
        [arrParts addObject:part];
    }];
    [tblvPartList reloadData];
}


#pragma mark - Event Method
- (IBAction)btnDashboardTap:(id)sender
{

    ScheduleListViewController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ScheduleListViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
   
}
- (IBAction)btnMenuTap:(id)sender
{
    
}
#pragma mark - UItableview delegate and datasource method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrParts.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACEOrderReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACEOrderReceiptCell"];
    
    [cell setOrderDetailCellData:arrParts[indexPath.section]];
    
    return cell;
}

@end
