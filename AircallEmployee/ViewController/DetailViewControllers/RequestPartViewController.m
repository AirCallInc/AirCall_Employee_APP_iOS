//
//  RequestPartViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 11/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "RequestPartViewController.h"

@interface RequestPartViewController ()<UITextFieldDelegate,ZWTTextboxToolbarHandlerDelegate,SearchPart,SelectedUser,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) ZWTTextboxToolbarHandler *handler;

@property (weak, nonatomic) IBOutlet UITextField *txtfPartNamae;
@property (weak, nonatomic) IBOutlet UITextField *txtvfQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtvfClientName;
@property (weak, nonatomic) IBOutlet SAMTextView *txtvNotes;

@property (weak,   nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchPart;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchClient;

@property (weak,   nonatomic) IBOutlet UITableView *tblvAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblvUnit;

@property (weak, nonatomic) IBOutlet UIView      *vwUnitView;
@property (weak, nonatomic) IBOutlet UIView      *vwAddress;
@property (weak, nonatomic) IBOutlet UIView      *vwNotes;

@property (weak, nonatomic) IBOutlet UILabel      *lblSize;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;

@property (strong, nonatomic) ACEParts *SelectedPart;

@property NSMutableArray *arrSelectedUnit;
@property NSMutableArray *arrSelectedUnitIndexPath;
@property NSMutableArray *arrRequestUnit;
@property NSMutableArray *arrTextBoxes;

@property NSString *clientId;
@property NSString *addressId;


@property NSInteger selectedAddresIndex;
@end

@implementation RequestPartViewController

@synthesize handler,isFromServiceReport,clientName,arrunit,arrAddress,arrSelectedUnit,SelectedPart,delegate,clientId,addressId,selectedAddresIndex,arrSelectedUnitIndexPath,isEditable,arrRequestUnit,empRequestId,partId,arrTextBoxes;

@synthesize txtfPartNamae,txtvfClientName,txtvfQuantity,vwAddress,scrlv,tblvAddress,tblvUnit,lblSize,vwUnitView,btnSubmit,btnCancelRequest,btnSearchClient,vwNotes,txtvNotes;

#pragma mark - ACEViewcontroller Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrTextBoxes = [[NSMutableArray alloc]initWithObjects:(txtvNotes),nil];
    
    vwAddress.backgroundColor        = [UIColor whiteColor];
    vwUnitView.backgroundColor       = [UIColor whiteColor];
    tblvAddress.alwaysBounceVertical = NO;
    tblvAddress.separatorStyle       = UITableViewCellSeparatorStyleNone;
    
    tblvUnit.alwaysBounceVertical = NO;
    tblvUnit.separatorStyle       = UITableViewCellSeparatorStyleNone;
    
    arrSelectedUnitIndexPath = [[NSMutableArray alloc]init];
    arrSelectedUnit          = [[NSMutableArray alloc]init];
    arrRequestUnit           = [[NSMutableArray alloc]init];
    SelectedPart             = [[ACEParts alloc]init];
    
    if(isFromServiceReport)
    {
        [self prepareviewForServiceReport];
    }
    else if(isEditable)
    {
        [self prepareviewForDetail];
    }
    else
    {
        [self prepareview];
    }
}

#pragma mark - Helper method
-(void)prepareview
{
    
    tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:@"Please select Client" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
    
    tblvUnit.backgroundView = [ACEUtil viewNoDataWithMessage:@"Please select Client" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
    
    btnCancelRequest.hidden = YES       ;
    btnSubmit.width         = self.view.width - 20 - btnSubmit.x;
    
    [scrlv setContentSize:CGSizeMake(scrlv.width, vwNotes.y + vwNotes.height)];
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextBoxes andScroll:scrlv];
    handler.showNextPrevious = NO;
    handler.delegate = self;

    //[self setFrameOfTableView];
}

-(void)prepareviewForServiceReport
{
    txtvfClientName.text                    = clientName;
    txtvfClientName.userInteractionEnabled  = NO        ;
    btnSearchClient.userInteractionEnabled  = NO        ;
    tblvAddress.userInteractionEnabled      = NO        ;
    btnCancelRequest.hidden                 = YES       ;
    
    btnSubmit.width         = self.view.width - 20 - btnSubmit.x;
    
    [tblvAddress reloadData];
    [tblvUnit reloadData]   ;
    
    [self setFrameOfTableView];
}
-(void)prepareviewForDetail
{
    tblvAddress.userInteractionEnabled     = NO;
    btnSearchClient.userInteractionEnabled = NO;
    txtvfClientName.userInteractionEnabled = NO;
    [self getRequestDetail];
}
-(void)setFrameOfTableView
{
    
    if (arrAddress.count > 0)
    {
        tblvAddress.frame = CGRectMake(tblvAddress.x,tblvAddress.y, tblvAddress.width, tblvAddress.contentSize.height);
        vwAddress.frame   = CGRectMake(vwAddress.x, vwAddress.y, vwAddress.width,tblvAddress.y + tblvAddress.height);
    }
    else
    {
        tblvAddress.height = 120;
        vwAddress.frame    = CGRectMake(vwAddress.x, vwAddress.y, vwAddress.width,tblvAddress.y + tblvAddress.height);
        tblvAddress.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoAddressFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height ];
        arrunit  = [[NSMutableArray alloc]init];
        [tblvUnit reloadData];
    }
    if (arrunit.count > 0)
    {
        tblvUnit.frame   = CGRectMake(tblvUnit.x, tblvUnit.y, tblvUnit.width, tblvUnit.contentSize.height);
        vwUnitView.frame = CGRectMake(vwUnitView.x, vwAddress.y + vwAddress.height +10, vwUnitView.width, tblvUnit.y + tblvUnit.height);
    }
    else
    {
        tblvUnit.height  = 120;
        vwUnitView.frame = CGRectMake(vwUnitView.x, vwAddress.y + vwAddress.height +10, vwUnitView.width, tblvUnit.y + tblvUnit.height);
        tblvUnit.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitsFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
    }
    
//    _btnSubmit.frame = CGRectMake(_btnSubmit.x, vwUnitView.y + vwUnitView.height + 10, _btnSubmit.width, _btnSubmit.height);
    vwNotes.y = vwUnitView.y + vwUnitView.height;
    
    [scrlv setContentSize:CGSizeMake(scrlv.width, vwNotes.y + vwNotes.height )];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextBoxes andScroll:scrlv];
    handler.showNextPrevious = NO;
    handler.delegate = self;
    
}
-(BOOL)validateDetail
{
    
    if([txtfPartNamae.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACENoPartsSelected];
        return NO;
    }
    else if ([txtvfClientName.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACEBlankClientName];
        return NO;
    }
    else if(arrSelectedUnit.count == 0)
    {
        [self showAlertWithMessage:ACENoUnitsSelected];
        return NO;
    }
    txtvNotes.text = [self trimmWhiteSpaceFrom:txtvNotes.text];
    if ([txtvNotes.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACEBlankRequestPartNotes];
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

#pragma mark - Event Method

- (IBAction)btnSearchPartTap:(id)sender
{
    [self.view endEditing:YES];
        
    SearchPartViewController *sp = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchPartViewController"];
        
    sp.delegate = self;
        
    [self presentViewController:sp animated:YES completion:nil];
    
}
- (IBAction)btnSearchClientTap:(id)sender
{
    [self.view endEditing:YES];
        
    SearchUserViewController *suvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    suvc.delegate         = self;
    suvc.isWorkAreaClient = YES;
    
    [self presentViewController:suvc animated:YES completion:nil];
}
- (IBAction)btnCancelReqTap:(id)sender
{
//    [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:@"Are you sure want to cancel request?" andHandler:^(UIAlertAction * _Nullable action)
//    {
//        
//        [self deleteRequest];
//    }];
    
    [ACEUtil showAlertFromControllerWithDoubleAction:self withMessage:@"Are you sure want to cancel request?" andHandler:^(UIAlertAction * _Nullable action)
     {
         [self deleteRequest];

     } andNoHandler:^(UIAlertAction * _Nullable action)
     {
        
    }];
}
- (IBAction)btnSubmitTap:(id)sender
{
    if([self validateDetail])
    {
        
        if(isFromServiceReport)
        {
            NSMutableArray *unitArr = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < arrSelectedUnit.count; i++)
            {
                NSIndexPath *index = arrSelectedUnit[i];
                
                ACEMaterialListCell *cell = [tblvUnit cellForRowAtIndexPath:index];
                NSDictionary *unitdict    = arrunit[index.row];
                
                NSDictionary *dict = @{
                                       SRKeyReqUnitId    : unitdict[SDKeyUnitId],
                                       SRKeyReqPartQnty  : cell.lblQnty.text
                                       };
                
                [unitArr addObject:dict];
            }
            
            NSDictionary *dict = @{
                                   SRKeySelectedPart : SelectedPart,
                                   SRKeyUnitArray    : unitArr,
                                   SRKeyReqPartNotes : txtvNotes.text
                                   };
            
            [delegate requestedPartDetail:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self sendPartRequest];
        }
    }
}
- (IBAction)btnCloseTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCheckMarkOfUnitTap:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tblvUnit];
    
    NSIndexPath *indexPath = [tblvUnit indexPathForRowAtPoint:buttonPosition];
    
    ACEMaterialListCell *cell = [tblvUnit cellForRowAtIndexPath:indexPath];
    
    /*if(btn.selected)
     {
     btn.backgroundColor = [UIColor redColor];
     
     }
     else
     {
     btn.backgroundColor = [UIColor greenColor];
     [arrSelectedUnit addObject:arrunit[indexPath.row]];
     }
     btn.selected = !btn.selected;*/
    
    if(cell.btnCheck.selected)
    {
        [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [arrSelectedUnit removeObject:indexPath];
    }
    else
    {
        [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        [arrSelectedUnit addObject:indexPath];
    }
    cell.btnCheck.selected = !cell.btnCheck.selected;
}

- (IBAction)btnCheckMarkTap:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tblvUnit];
    
    NSIndexPath *indexPath = [tblvUnit indexPathForRowAtPoint:buttonPosition];
    
    ACEMaterialListCell *cell = [tblvUnit cellForRowAtIndexPath:indexPath];
    
    /*if(btn.selected)
    {
        btn.backgroundColor = [UIColor redColor];
       
    }
    else
    {
        btn.backgroundColor = [UIColor greenColor];
        [arrSelectedUnit addObject:arrunit[indexPath.row]];
    }
    btn.selected = !btn.selected;*/
    
    if(cell.btnCheck.selected)
    {
        [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [arrSelectedUnit removeObject:indexPath];
    }
    else
    {
        [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        [arrSelectedUnit addObject:indexPath];
    }
    cell.btnCheck.selected = !cell.btnCheck.selected;
    
}
- (IBAction)btnPlusqntyTap:(UIButton *)btn
{
    CGPoint buttonPosition    = [btn convertPoint:CGPointZero toView:self.tblvUnit];
    NSIndexPath *indexPath    = [tblvUnit indexPathForRowAtPoint:buttonPosition];
    ACEMaterialListCell *cell = [tblvUnit cellForRowAtIndexPath:indexPath];
    
    int qnty = [cell.lblQnty.text intValue];
    
    if(qnty < 5)
    {
        qnty ++;
        cell.lblQnty.text = [NSString stringWithFormat:@"%d",qnty];
    }
}

- (IBAction)btnMinusQntyTap:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tblvUnit];
    
    NSIndexPath *indexPath = [tblvUnit indexPathForRowAtPoint:buttonPosition];
    
    ACEMaterialListCell *cell = [tblvUnit cellForRowAtIndexPath:indexPath];
    int qnty = [cell.lblQnty.text intValue];
    
    if(qnty > 1)
    {
        qnty --;
        cell.lblQnty.text = [NSString stringWithFormat:@"%d",qnty];
    }

}

#pragma mark - delegate method
-(void)SelectedPartName:(ACEParts *)part
{
    SelectedPart       = part;
    txtfPartNamae.text = part.partName;
    lblSize.text       = part.partSize;
    [tblvUnit reloadData];
}
-(void)selectedUser:(ACEClient *)user
{
    txtvfClientName.text = user.Name;
    clientId             = [NSString stringWithFormat:@"%@", user.ID];
    arrunit              = nil;
    arrAddress           = nil;
    arrSelectedUnit      = [[NSMutableArray alloc]init];
  
    [self setFrameOfTableView];
    [self getAddressFromClient];

}
#pragma mark - textfield delegate method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)doneTap
{
    
}

#pragma mark - tableView delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1) //tblv address
    {
        return arrAddress.count;
    }
    else if (tableView.tag == 2) //tblv unit
    {
        return arrunit.count;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if(tableView.tag == 1) //tblv address
    {
         ACESelectionCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
        
        if(isFromServiceReport)
        {
            cell.lblName.text   = arrAddress[indexPath.row];
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        }
        else if (isEditable)
        {
            ACEAddress *address = arrAddress[indexPath.row];
            cell.lblName.text   = address.fullAddress;
            
            if([addressId isEqualToString:address.addressId])
            {
                selectedAddresIndex = indexPath.item;
                addressId           = address.addressId;
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
                [self getUnits];
            }
            else
            {
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
            }

        }
        else
        {
            ACEAddress *address = arrAddress[indexPath.row];
            cell.lblName.text   = address.fullAddress;

            if (address.isDefaultAddress)
            {
                selectedAddresIndex = indexPath.item;
                addressId           = address.addressId;
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
                [self getUnits];
            }
            else
            {
                cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(tableView.tag == 2) //tblv unit
    {
        ACEMaterialListCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitCell"];
        cell.btnCheck.selected = NO;
        cell.incrQty  = 1;
        
        if([SelectedPart.partMasterId isEqualToString:@"4"])
        {
            cell.lblPartQty.text  = @"Part Quantity (lbs)";
            cell.maxQty           = 1000;
        }
        else
        {
            cell.lblPartQty.text  = @"Part Quantity";;
            cell.maxQty   = 99;
        }
        
        if (isFromServiceReport)
        {
             NSDictionary *dict  = arrunit[indexPath.row];
            [cell setRequestedPartCellData: dict[SDKeyUnitName]];
        }
        else if (isEditable)
        {
             ACEACUnit *unit           = arrunit[indexPath.row];
             cell.lblMaterialName.text = unit.unitName;
            
            for(int i =0; i< arrRequestUnit.count;i++)
            {
                NSDictionary *dict = arrRequestUnit[i];
                if([unit.unitId isEqualToString:[dict[ACKeyID]stringValue]])
                {
                    cell.btnCheck.selected = YES;
                    
                    [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
                    
                    [arrSelectedUnit addObject:indexPath];
                    
                    cell.lblQnty.text   = [dict[PKeyPartRequestedQty]stringValue];
                }
                
            }
        
        }
        else
        {
            ACEACUnit *unit           = arrunit[indexPath.row];
            cell.lblMaterialName.text = unit.unitName;
            [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            cell.lblQnty.text = @"1";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1) //tblv address
    {
        ACESelectionCell *cell;
        if (selectedAddresIndex != indexPath.item)
        {
            NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedAddresIndex inSection:0];
            cell = (ACESelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvTick.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        ACEAddress *address = arrAddress[indexPath.row];
        cell                = [tableView cellForRowAtIndexPath:indexPath];
        addressId           = address.addressId;
        cell.imgvTick.image = [UIImage imageNamed:@"radiobutton-selected"];
        arrSelectedUnit     = [[NSMutableArray alloc]init];
        
        [self getUnits];
    }
    /*else if(tableView.tag == 2) //tblv unit
    {
        ACEMaterialListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.btnCheck.selected)
        {
            [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            [arrSelectedUnit removeObject:indexPath];
        }
        else
        {
            [cell.btnCheck setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
            [arrSelectedUnit addObject:indexPath];
        }
        cell.btnCheck.selected = !cell.btnCheck.selected;
    }*/
    
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
    {
        ACESelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.imgvTick.image    = [UIImage imageNamed:@"radiobutton"];
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView.tag == 1)
//    {
//        NSString *str = [_arrAddress objectAtIndex:indexPath.row];
//    
//        UIFont *font = [UIFont systemFontOfSize:17.0f];
//         CGSize constraint = CGSizeMake(200 , FLT_MAX);
//       
//        CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font }context:nil].size;
//    
//        return size.height + 10;
//    }
//    
//    return 50;
//}
#pragma mark - WebserviceMethod
-(void)getAddressFromClient
{
    if ([ACEUtil reachable])
    {
        [ACEWebServiceAPI getAddressListForClient:clientId completionHandler:^(ACEAPIResponse *response, NSMutableArray *addressArray)
        {
            if (response.code == RCodeSuccess)
            {
                //arrAddress = addressArray;
                arrAddress = [self getValidAddresses:addressArray].mutableCopy;
                [tblvAddress reloadData];
                [self setFrameOfTableView];
            }
            else if (response.code == RCodeNoData)
            {
                arrAddress = addressArray;
                [tblvAddress reloadData];
                [self setFrameOfTableView];
            }
            else if(response.code == RCodeUnauthorized)
            {
                [SVProgressHUD dismiss];
                [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if (response.code == RCodeSessionExpired)
            {
                [SVProgressHUD dismiss];
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
-(void)getUnits
{
    if ([ACEUtil reachable])
    {
        [ACEWebServiceAPI getUnitListForClient:addressId withClientId:clientId completionHandler:^(ACEAPIResponse *response, NSMutableArray *unitsArray)
         {
             
             if (response.code == RCodeSuccess)
             {
                 arrunit = unitsArray;
                 [tblvUnit reloadData];
                 [self setFrameOfTableView];
                 [SVProgressHUD dismiss];
             }
             else if(response.code == RCodeUnauthorized)
             {
                 [SVProgressHUD dismiss];
                 [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACEUtil logoutUser];
                  }];
             }
             else if (response.code == RCodeSessionExpired)
             {
                 [SVProgressHUD dismiss];
                 [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACEUtil logoutUser];
                  }];
             }
             else if (response.code == RCodeNoData)
             {
                 [SVProgressHUD dismiss];
                 arrunit = unitsArray;
                 [tblvUnit reloadData];
                 [self setFrameOfTableView];
             }
             else if(response.message)
             {
                 [SVProgressHUD dismiss];
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
-(void)sendPartRequest
{
    if ([ACEUtil reachable])
    {
        [SVProgressHUD show];
       
        NSMutableArray *arrRequestPart = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < arrSelectedUnit.count; i++)
        {
            NSIndexPath *index = arrSelectedUnit[i];
            
            ACEMaterialListCell *cell = [tblvUnit cellForRowAtIndexPath:index];
            ACEACUnit *unit           = arrunit[index.row];
            
            NSDictionary *dict = @{
                                   SRKeyReqUnitId    : unit.unitId,
                                   SRKeyReqPartId    : SelectedPart.ID,
                                   SRKeyReqPartQnty  : cell.lblQnty.text,
                                   SRKeyReqPartName  : SelectedPart.partName,
                                   SRKeyReqPartSize  : SelectedPart.partSize,
                                   SRKeyReqPartDes   : SelectedPart.partInfo ?SelectedPart.partInfo : @""
                                   };
            
            [arrRequestPart addObject:dict];
        }
        
        NSDictionary *dict = @{
                               PKeyPartRequestId : empRequestId ? empRequestId : @"",
                               CKeyID            : clientId,
                               UKeyEmployeeID    : ACEGlobalObject.user.userID,
                               SCHKeyAddressId    : addressId,
                               SRKeyRequestedPart : arrRequestPart,
                               SRKeyReqPartNotes  : txtvNotes.text
                               };
        [self callWebService:dict];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)callWebService:(NSDictionary *)parameterDict
{
    [ACEWebServiceAPI submitPartRequest:parameterDict completionHandler:^(ACEAPIResponse *response)
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
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
    }];
    
}
-(void)getRequestDetail
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                                PKeyPartRequestId : empRequestId,
                                UKeyEmployeeID : ACEGlobalObject.user.userID
                               };
        [ACEWebServiceAPI getRequestedPartDetail:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *dict)
         {
            if(response.code == RCodeSuccess)
            {
                clientId               = [dict[CKeyID] stringValue];
                addressId              = [dict[SCHKeyAddressId] stringValue];
                arrRequestUnit         = dict[AKeyUnits];
                txtvfClientName.text   = dict[CKeyName];
                txtfPartNamae.text     = dict[OIKeyName];
                lblSize.text           = dict[OIKeySize];
                SelectedPart.ID        = [partId isEqualToString:@"0"]?@"":partId;
                SelectedPart.partSize  = dict[OIKeySize];
                SelectedPart.partName  = dict[OIKeyName];
                SelectedPart.partInfo  = @"";
                txtvNotes.text         = dict[SRKeyReqPartNotes];
                [self getAddressFromClient];
            }
            else if(response.code == RCodeUnauthorized)
            {
                 [SVProgressHUD dismiss];
                [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if (response.code == RCodeSessionExpired)
            {
                [SVProgressHUD dismiss];
                [self showAlertFromWithMessageWithSingleAction:ACESessionExpired andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACEUtil logoutUser];
                 }];
            }
            else if (response.message)
            {
                [SVProgressHUD dismiss];
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
        [self showAlertFromWithMessageWithSingleAction:ACENoInternet andHandler:^(UIAlertAction * _Nullable action)
         {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    
}
-(void)deleteRequest
{
    if([ACEUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                                UKeyEmployeeID : ACEGlobalObject.user.userID,
                                PKeyPartRequestId : empRequestId
                               };
        [ACEWebServiceAPI cancelRequestedPart:dict completionHandler:^(ACEAPIResponse *response)
         {
              [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
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
@end
