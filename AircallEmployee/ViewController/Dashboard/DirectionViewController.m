//
//  DirectionViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/10/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "DirectionViewController.h"

@interface DirectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblStartLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeNDistance;
@property (strong, nonatomic) IBOutlet UITableView *tblvDirections;

@end

@implementation DirectionViewController
@synthesize arrInfo,lblStartLocation,lblTimeNDistance,tblvDirections,strTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTimeNDistance.text = strTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Event method
- (IBAction)btnDoneTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableview Delegate & Datasource Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrInfo.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKRouteStep *step = arrInfo[indexPath.row];
    
    DirectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(indexPath.row != 0)
    {
        UIView* separatorLineView = [[UIView alloc] initWithFrame:
                                     CGRectMake(0, 0, self.view.width, 1)];
        
        separatorLineView.backgroundColor = [UIColor separatorColor];
        [cell.contentView addSubview:separatorLineView];
    }
    
    [cell setCellData:step];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize constraint;
    
    MKRouteStep *step = arrInfo[indexPath.row];
    
     NSString *str = [NSString stringWithFormat:@"%0.2f Miles\n%@",step.distance,step.instructions];
    
    if(ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6Plus)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.30 , FLT_MAX);
    }
    else if (ACEGlobalObject.screenSizeType == ACEScreenSizeTypeiPhone6)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.35 , FLT_MAX);
    }
    else
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
    }
    //constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
    
    
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:15];
    
    CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil].size;
    
    // NSLog(@"\n\nController :::: label height: %f\n label Width : %f\n\n",size.height + 20,size.width);
    
    return size.height + 20;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKRouteStep *step = arrInfo[indexPath.row];
    [self.delegate selectedDirection:step.polyline];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
