//
//  ChargeByPopupViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 20/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ChargeByPopupViewController.h"

NSString *const CHKeyCheque      =@"Check";
NSString *const CHKeyCCOnFile    =@"CC on File";
NSString *const CHKeyNewCC       =@"New CC";
NSString *const CHKeyPO          =@"PO";
NSString *const CHKeyCC          =@"CC";

@interface ChargeByPopupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvData;
@property (strong, nonatomic) IBOutlet UIView *vwPopup;
@property (strong, nonatomic) IBOutlet UIView *vwTblv;
@property NSMutableArray *arrData;
@end

@implementation ChargeByPopupViewController
@synthesize tblvData,arrData,selectedOption,vwPopup,vwTblv,shouldHideCC;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    vwPopup.hidden = YES;
    if(shouldHideCC)
    {
        arrData = [[NSMutableArray alloc]initWithObjects:CHKeyCheque,CHKeyNewCC, nil];
       //arrData = [[NSMutableArray alloc]initWithObjects:CHKeyCheque,CHKeyNewCC,CHKeyPO, nil];
    }
    else
    {
       arrData = [[NSMutableArray alloc]initWithObjects:CHKeyCheque,CHKeyCCOnFile,CHKeyNewCC, nil];
        //arrData = [[NSMutableArray alloc]initWithObjects:CHKeyCheque,CHKeyCCOnFile,CHKeyNewCC,CHKeyPO, nil];
    }
    [tblvData reloadData];
    tblvData.height = tblvData.contentSize.height  ;
    vwTblv.height   = tblvData.y + tblvData.height ;
    vwPopup.height  = vwTblv.y   + vwTblv.height   ;
    vwPopup.center  = self.view.center;
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopup.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwPopup.transform = CGAffineTransformIdentity;
                         vwPopup.hidden    = NO;
                     }
                     completion:nil];
}
- (IBAction)btnCloseTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UItableview delegate & datasource Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chargeByCell"];
    cell.lblName.text      = arrData[indexPath.row];
    
    if([selectedOption isEqualToString:arrData[indexPath.row]])
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
