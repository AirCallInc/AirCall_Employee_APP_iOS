//
//  OrderDetailViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ZWTTextboxToolbarHandlerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView   *vwParts;
@property (strong, nonatomic) IBOutlet ACELabel *lblOrderNo;
@property (strong, nonatomic) IBOutlet ACELabel *lblClientName;
@property (strong, nonatomic) IBOutlet ACELabel *lblAddress;
@property (strong, nonatomic) IBOutlet ACELabel *lblCity;
@property (strong, nonatomic) IBOutlet ACELabel *lblState;
@property (strong, nonatomic) IBOutlet ACELabel *lblZip;
@property (strong, nonatomic) IBOutlet ACELabel *lblEmail;
@property (strong, nonatomic) IBOutlet ACELabel *lblChargeBy;
@property (strong, nonatomic) IBOutlet UILabel  *lblTotalAmount;
//@property (strong, nonatomic) IBOutlet ACELabel *lblRecomm;
@property (strong, nonatomic) IBOutlet UIImageView *imgvEmail;
@property (strong, nonatomic) IBOutlet SAMTextView *txtvRecomm;

@property (strong, nonatomic) IBOutlet UITableView *tblvParts;
@property (strong, nonatomic) IBOutlet UIView      *vwBelowParts;
@property (strong, nonatomic) IBOutlet UIImageView *imgvSignature;

@property (strong, nonatomic) IBOutlet UITextField  *txtCcEmail;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvBg;
@property (strong, nonatomic) IBOutlet UILabel      *lblNoSignature;

@property ZWTTextboxToolbarHandler *handler;

@property ACEOrder *orderDetail;

@property BOOL isEmail;

@end

@implementation OrderDetailViewController

@synthesize vwParts,vwBelowParts,tblvParts,scrlvBg,txtCcEmail,orderId;

@synthesize lblZip,lblCity,lblEmail,lblState,lblAddress,lblOrderNo,lblChargeBy,lblClientName,lblTotalAmount,imgvEmail,imgvSignature,handler,orderDetail,isEmail,lblNoSignature,txtvRecomm;

#pragma mark - ACEViewcontroller Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackgroundColors];
    [self prepareView];
}

#pragma mark - Helper Method
-(void)setBackgroundColors
{
    vwParts.backgroundColor = [UIColor whiteColor];
    vwBelowParts.backgroundColor = [UIColor whiteColor];
    isEmail         =   YES;
}
-(void)prepareView
{
    if([ACEUtil reachable])
    {
        [self getOrderDetail:orderId];
    }
    else
    {
        [self showAlertFromWithMessageWithSingleAction:ACENoInternet andHandler:^(UIAlertAction * _Nullable action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }

}
-(void)showAllDetail
{
    lblOrderNo.text      = orderDetail.orderNo     ;
    lblClientName.text   = orderDetail.ClientName  ;
    lblAddress.text      = orderDetail.Address     ;
    lblCity.text         = orderDetail.City        ;
    lblState.text        = orderDetail.State       ;
    lblZip.text          = orderDetail.Zip         ;
    lblEmail.text        = orderDetail.Email       ;
    lblChargeBy.text     = orderDetail.ChargeBy    ;
    lblTotalAmount.text  = [NSString stringWithFormat:@"$%0.2f",orderDetail.TotalPrice];
    
    if([orderDetail.Recomm isKindOfClass:[NSNull class]] || [orderDetail.Recomm isEqualToString:@""])
    {
        txtvRecomm.text = @"No recommendation";
    }
    else
    {
        txtvRecomm.text = orderDetail.Recomm;
    }
    if(orderDetail.CCEmail.length == 0)
    {
        //txtCcEmail.text     =   @"No CCEmail found";
    }
    else
    {
        txtCcEmail.text      = orderDetail.CCEmail;
    }
    
    if(orderDetail.Signature)
    {
        [imgvSignature setImageWithURL:orderDetail.Signature];
        imgvSignature.hidden    = NO   ;
        lblNoSignature.hidden   = YES  ;
    }
    else
    {
        imgvSignature.hidden    = YES   ;
        lblNoSignature.hidden   = NO    ;
    }
    [tblvParts reloadData];
    tblvParts.userInteractionEnabled = NO;
    tblvParts.height  = tblvParts.contentSize.height;
    vwParts.height    = tblvParts.y + tblvParts.height;
    vwBelowParts.y    = vwParts.y   + vwParts.height;
    
    [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwBelowParts.y + vwBelowParts.height)];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:txtCcEmail, nil] andScroll:scrlvBg];
    
    handler.delegate = self;
    handler.showNextPrevious = NO;
    
    [SVProgressHUD dismiss];
}
-(BOOL)validateDetail
{
    if(!isEmail && [txtCcEmail.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACENoEmailselected];
        return NO;
    }
    if(![txtCcEmail.text isEqualToString:@""])
    {
        ZWTValidationResult result;
        
        result = [txtCcEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
        if(result == ZWTValidationResultInvalid)
        {
            [self showErrorMessage:ACEInvalidEmail belowView:txtCcEmail];
            return NO;
        }
    }
    return YES;
}
#pragma mark - ZWTTextTollbarHandler
-(void)doneTap
{
    //[scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwBelowParts.y + vwBelowParts.height)];
}
#pragma mark - WebserviceMethod
-(void)getOrderDetail:(NSString *)orderID
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           OKeyID         : orderID
                           };
    
    [ACEWebServiceAPI getOrderDetail:dict completionHandler:^(ACEAPIResponse *response, ACEOrder *order)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            orderDetail = order;
            [self showAllDetail];
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
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [SVProgressHUD dismiss];
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
    
}
-(void)resendOrderDetail
{
    [SVProgressHUD show];
    NSMutableArray *arrEmails = [[NSMutableArray alloc]init];
    if(isEmail)
    {
        [arrEmails addObject:orderDetail.Email];
    }
    if(![txtCcEmail.text isEqualToString:@""])
    {
        [arrEmails addObject:txtCcEmail.text];
    }
    NSDictionary *dict   = @{
                             OKeyID           : orderId,
                             UKeyEmployeeID   : ACEGlobalObject.user.userID,
                             GKeyResendEmails : arrEmails
                             };
    [ACEWebServiceAPI resendOrderDetail:dict completionhandler:^(ACEAPIResponse *response)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }];
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
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
        
    
}
#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnEmailToClientTap:(UIButton *)btn
{
    if(btn.selected)
    {
        [imgvEmail setImage:[UIImage imageNamed:@"worknotdone-selected"]];
    }
    else
    {
        [imgvEmail setImage:[UIImage imageNamed:@"worknotdone"]];
    }
    isEmail      = !isEmail;
    btn.selected = !btn.selected;
    
}
- (IBAction)btnSendTap:(UIButton *)btn
{
    if([self validateDetail])
    {
        if([ACEUtil reachable])
        {
            [self resendOrderDetail];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
    }
    
}

#pragma mark - Tableview Delegate & Datasource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderDetail.IteamList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACEOrderReceiptCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    
    ACEOrderIteam *iteam    = orderDetail.IteamList[indexPath.section];
    
    cell.lblIndex.text      = [NSString stringWithFormat:@"%ld",(long)indexPath.section + 1];
    
    [cell setOrderDetailCellData:iteam];
    
    return cell;
    
}
#pragma mark - UITextfield delegate method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    return YES;
}
@end
