//
//  ExpYearMonthPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 22/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ExpYearMonthPopupViewController.h"

@interface ExpYearMonthPopupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray *arrData;

@end

@implementation ExpYearMonthPopupViewController
@synthesize tblvData,selectedOption,lblTitle,vwPopUp,arrData;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    arrData  = [[NSMutableArray alloc]init];
    
    if([selectedOption isEqualToString:@"ExpMonth"])
    {
        lblTitle.text = @"Expire Month";
        for(int i = 1; i <= 12 ;i++)
        {
            [arrData addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    else if ([selectedOption isEqualToString:@"ExpYear"])
    {
        lblTitle.text = @"Expire Year";
        arrData       = [self setYear];
    }
    [tblvData reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopUp.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwPopUp.transform = CGAffineTransformIdentity;
                         vwPopUp.hidden    = NO;
                     }
                     completion:nil];

}
- (IBAction)btnCloseTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Helper method
-(NSMutableArray *)setYear
{
    NSMutableArray * years = [[NSMutableArray alloc]init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    int currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
    
    for (int i = currentYear; i <= currentYear + 20; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    return years;
}


#pragma mark - UITableview Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpDateCell"];
    
    cell.lblName.text      = arrData[indexPath.row];
    cell.imgvTick.hidden   = YES;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedValue:arrData[indexPath.row] forOption:selectedOption];
    
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
