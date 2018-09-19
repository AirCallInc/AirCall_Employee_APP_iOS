//
//  ChooseQtyPopupViewController.m
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ChooseQtyPopupViewController.h"

@interface ChooseQtyPopupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblvQty;
@property NSMutableArray *arrQty;

@end

@implementation ChooseQtyPopupViewController
@synthesize tblvQty,arrQty;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    arrQty = [[NSMutableArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
}

#pragma mark - UITableView Delagate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrQty.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    
    UITableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"qtyCell"];
    if(arrQty.count > indexPath.row)
        cell.textLabel.text      = arrQty[indexPath.row];
    
    cell.textLabel.font          = [UIFont fontWithName:@"Helvetica" size:15];
    
    if (indexPath.row > 0)
    {
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1.5)];
        lineView.backgroundColor = [UIColor separatorColor];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate ChooseQuantity:arrQty[indexPath.row]];
    [self btnCancelTap:nil];
}

#pragma mark - Event Method
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
