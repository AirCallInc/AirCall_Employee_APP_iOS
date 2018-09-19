//
//  RatingNReviewViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 09/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "RatingNReviewViewController.h"

@interface RatingNReviewViewController ()

@property (strong, nonatomic) IBOutlet UITableView       *tblvRatings;
@property (weak, nonatomic)   IBOutlet HCSStarRatingView *vwAvgRating;
@property (strong, nonatomic) NSMutableArray             *ratingArray;

@end

@implementation RatingNReviewViewController

@synthesize  tblvRatings,ratingArray,vwAvgRating;
#pragma mark - ACEViewController method
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
     [self prepareView];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    tblvRatings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblvRatings.separatorColor  = [UIColor clearColor];
    
    if([ACEUtil reachable])
    {
         [self getData];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - Event Method
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}

#pragma mark - Webservice Method
-(void)getData
{
    [SVProgressHUD show];
    
    [ACEWebServiceAPI getReviewsNRatingList:ACEGlobalObject.user.userID completionHandler:^(ACEAPIResponse *response, NSMutableArray *ratingNReviewArray, CGFloat rate)
    {
        if(response.code == RCodeSuccess)
        {
            vwAvgRating.value = rate;
            ratingArray       = ratingNReviewArray.copy;
            [tblvRatings   reloadData];
            [SVProgressHUD dismiss]   ;
        }
        else if (response.code == RCodeNoData)
        {
            [SVProgressHUD dismiss];
            ratingArray = nil;
            vwAvgRating.value = 0;
            tblvRatings.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.height/1.3];
        }
        else if(response.code == RCodeUnauthorized)
        {
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACEUtil logoutUser];
             }];
        }
        else if (response.code == RCodeSessionExpired)
        {
            [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACEUtil logoutUser];
             }];
        }
        else if(response.message)
        {
            [SVProgressHUD dismiss];
            tblvRatings.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.height/1.3];
        }
        else
        {
            [SVProgressHUD dismiss];
            tblvRatings.backgroundView = [ACEUtil viewNoDataWithMessage:ACEUnknownError andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.height/1.3];
        }
    }];
}

#pragma mark - tableview Delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ratingArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACERatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACERatingCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellData:ratingArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingDetailViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RatingDetailViewController"];
    rvc.rate = ratingArray[indexPath.row];
    [self.navigationController pushViewController:rvc animated:YES];
}
@end
