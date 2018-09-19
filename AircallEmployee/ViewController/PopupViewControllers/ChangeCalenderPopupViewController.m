//
//  ChangeCalenderPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 23/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ChangeCalenderPopupViewController.h"

NSString *const CalenderOptionMonth  = @"Month";
NSString *const CalenderOptionWeek   = @"Week";
NSString *const CalenderOptionToday  = @"Today";

@interface ChangeCalenderPopupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView       *vwpopup;
@property (strong, nonatomic) IBOutlet UITableView  *tblvOptions;
@property (strong, nonatomic) IBOutlet UIView       *vwTableview;

@property NSMutableArray *arrData;
@end

@implementation ChangeCalenderPopupViewController
@synthesize  arrData,selectedString,tblvOptions,vwpopup,vwTableview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrData = [[NSMutableArray alloc]initWithObjects:CalenderOptionWeek,CalenderOptionMonth,CalenderOptionToday,nil];
    
    tblvOptions.alwaysBounceVertical = NO;
    
    [tblvOptions reloadData];
    
    tblvOptions.height = tblvOptions.contentSize.height;
    vwTableview.height = tblvOptions.height;
    vwpopup.hidden     = YES;
    vwpopup.frame      = CGRectMake(vwpopup.x, vwpopup.y, vwpopup.width, vwTableview.y + vwTableview.height);
   
}
-(void)viewDidAppear:(BOOL)animated
{
    vwpopup.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^
                     {
                         vwpopup.transform = CGAffineTransformIdentity;
                         vwpopup.hidden    = NO;
                     }
                     completion:nil];

}
#pragma mark - Event Method
- (IBAction)btnCancelTap:(id)sender
{
    CATransition* transition = [CATransition animation] ;
    transition.duration      = 0.3                      ;
    transition.type          = kCATransitionFade        ;
    transition.subtype       = kCATransitionFromBottom  ;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - UITableview Delegate & Datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectionCell"];
    cell.lblName.text      = arrData[indexPath.row];
    
    if([selectedString isEqualToString:arrData[indexPath.row]])
    {
        cell.imgvTick.hidden = NO;
    }
    else
    {
        cell.imgvTick.hidden = YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.delegate selectedOption:arrData[indexPath.row]];
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
