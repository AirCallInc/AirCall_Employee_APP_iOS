//
//  ACESalesPersonRequestViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 10/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "SalesPersonRequestViewController.h"

@interface SalesPersonRequestViewController ()<UITextFieldDelegate,UITextViewDelegate,ZWTTextboxToolbarHandlerDelegate,SelectedUser,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet ACETextField    *txtClientName   ;
@property (weak, nonatomic) IBOutlet SAMTextView     *txtvNotes       ;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler  ;

@property NSArray        *arrAddess;
@property NSString       *ClientId;
@property NSString       *addressId;
@property NSMutableArray *arrTextBox;
@property NSInteger       selectedAddressIndex;

@end

@implementation SalesPersonRequestViewController

@synthesize scrlvbg,textboxHandler,txtClientName,txtvNotes,ClientId,vwAddress,tblvAddress,arrAddess,vwBelowAddress,selectedAddressIndex,addressId,arrTextBox;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width, vwBelowAddress.y + vwBelowAddress.height);
    
    arrTextBox =[[NSMutableArray alloc]initWithObjects:(txtvNotes), nil];
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBox andScroll:scrlvbg];
    
    vwAddress.backgroundColor        = [UIColor whiteColor];
    tblvAddress.alwaysBounceVertical = NO;
    tblvAddress.separatorStyle       = UITableViewCellSeparatorStyleNone;
    
    tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:@"Please select Client" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
    
    textboxHandler.showNextPrevious = NO;
    textboxHandler.delegate         = self;
}
-(void)setFrameOfTableView
{
    if(arrAddess.count > 0)
    {
        tblvAddress.height = tblvAddress.contentSize.height;
        vwAddress.height   = tblvAddress.y + tblvAddress.height;
        vwBelowAddress.y   = CGRectGetMaxY(vwAddress.frame);
    }
    else
    {
        tblvAddress.height = 80;
        vwAddress.height   = tblvAddress.y + tblvAddress.height;
        vwBelowAddress.y   = CGRectGetMaxY(vwAddress.frame);
        
    }
    
    [scrlvbg setContentSize: CGSizeMake(scrlvbg.width,(vwBelowAddress.y + vwBelowAddress.height))];
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBox andScroll:scrlvbg];
    textboxHandler.showNextPrevious = NO;
    textboxHandler.delegate         = self;
    
}
#pragma mark - Event Method
- (IBAction)btnCloseTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTap:(id)sender
{
    if ([self isDetailValid])
    {
        [self sendSalesPersonRequest];
    }
    
}
- (IBAction)btnClientTap:(id)sender
{
    SearchUserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    viewController.delegate         = self;
    viewController.isWorkAreaClient = NO;
    
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - WebService Method
-(void)sendSalesPersonRequest
{
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyEmployeeID : ACEGlobalObject.user.userID,
                               CKeyID :ClientId,
                               SRKeyEmpNotes : txtvNotes.text,
                               SCHKeyAddressId : addressId
                               };
        [ACEWebServiceAPI sendSalesPersonRequest:dict completionHandler:^(ACEAPIResponse *response)
        {
            [SVProgressHUD dismiss];
            if (response.code == RCodeSuccess)
            {
                [self.delegate submitSalesPerson];
                [self.navigationController popViewControllerAnimated:YES];
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
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)getAddressFromClient
{
    if ([ACEUtil reachable])
    {
        [ACEWebServiceAPI getAddressListForClient:ClientId completionHandler:^(ACEAPIResponse *response, NSMutableArray *addressArray)
         {
             if (response.code == RCodeSuccess)
             {
                 arrAddess = [self getValidAddresses:addressArray];
                 [tblvAddress reloadData];
                 [self setFrameOfTableView];
             }
             else if (response.code == RCodeNoData)
             {
                 arrAddess = addressArray;
                 [tblvAddress reloadData];
                 [self setFrameOfTableView];
                 tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
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
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}

#pragma mark - Helper Method
-(BOOL)isDetailValid
{
    ZWTValidationResult result;
    
    result = [txtClientName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACEBlankClientName belowView:txtClientName];
        return NO;
    }
    else if (addressId == nil)
    {
        [self showAlertWithMessage:ACESelectAddress];
        return  NO;
    }
    txtvNotes.text = [self trimmWhiteSpaceFrom:txtvNotes.text];
    if ([txtvNotes.text isEqualToString:@""])
    {
        txtvNotes.layer.borderColor = [UIColor redColor].CGColor;
        txtvNotes.layer.borderWidth = 1.0;
        [self showErrorMessage:ACEBlankNotes belowView:txtvNotes];
        [txtvNotes becomeFirstResponder];
        return NO;
    }
    return YES;
}
-(NSMutableArray *)getValidAddresses:(NSMutableArray *)addressList
{
    NSMutableArray *arrAddressList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < addressList.count; i++)
    {
        ACEAddress *address = addressList[i];
        
        if (address.isShowAddress)
        {
            [arrAddressList addObject:address];
        }
    }
    
    return arrAddressList;
}

#pragma mark - ZWTTextboxToolbarHandler Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self removeErrorMessageBelowView:textView];
    textView.layer.borderColor = [UIColor separatorColor].CGColor;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

-(void)doneTap
{
    
}

#pragma mark - SearchUserViewController Delegate Method

-(void)selectedUser:(ACEClient *)user
{
    txtClientName.text  = user.Name;
    ClientId            = [NSString stringWithFormat:@"%@", user.ID];
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width, txtvNotes.y + txtvNotes.height);
    addressId           = nil;
    
    [self removeErrorMessageBelowView:txtClientName];
    
    txtClientName.layer.borderColor = [UIColor separatorColor].CGColor;
    
    [self getAddressFromClient];
    
}
#pragma mark - UITableView Delegate and DataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAddess.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACEAddress *address     = arrAddess[indexPath.row];
    
    ACESelectionCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    
    cell.lblName.text = address.fullAddress;
    
    if (address.isDefaultAddress)
    {
        selectedAddressIndex = indexPath.row;
        addressId            = address.addressId;
        cell.imgvTick.image  = [UIImage imageNamed:@"radiobutton-selected"];
    }
    else
    {
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACESelectionCell *cell;
    
    if (selectedAddressIndex != indexPath.item)
    {
        NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
        cell = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
    }
    ACEAddress *address   = arrAddess[indexPath.row];
    cell                  = [tableView cellForRowAtIndexPath:indexPath];
    addressId             = address.addressId;
    selectedAddressIndex  = indexPath.row;
    cell.imgvTick.image   = [UIImage imageNamed:@"radiobutton-selected"];
  
}
@end
