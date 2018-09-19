//
//  ServiceReportDetailViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 27/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ServiceReportDetailViewController.h"

@interface ServiceReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZWTTextboxToolbarHandlerDelegate,UITextFieldDelegate>


@property BOOL isMaterialUsehidden,isWorkNotDone,isEmployeeNotesOpen;

@property CGRect frmMaterialUsed;

@property (strong, nonatomic) IBOutlet UILabel *lblReportNo     ;
@property (strong, nonatomic) IBOutlet UILabel *lblAccountNo    ;
@property (strong, nonatomic) IBOutlet UILabel *lblClientName   ;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany      ;

@property (strong, nonatomic) IBOutlet UILabel *lblPurpose      ;
@property (strong, nonatomic) IBOutlet UILabel *lblBillingType  ;
@property (strong, nonatomic) IBOutlet UILabel *lblReportDate   ;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignTimeStarted  ;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignCompleted;
@property (strong, nonatomic) IBOutlet UILabel *lblActualTimeStarted;
@property (strong, nonatomic) IBOutlet UILabel *lblActualEndTime;
@property (strong, nonatomic) IBOutlet UILabel *lblExtraTime;

@property (strong, nonatomic) IBOutlet UILabel *lblAssignedTotalTimings;
@property (strong, nonatomic) IBOutlet UILabel *lblClientEmail  ;
@property (strong, nonatomic) IBOutlet UIImageView *imgvArrowEmpNotes;

@property (strong, nonatomic) IBOutlet UITextField *txtfCcEmail;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvbg;

@property (strong, nonatomic) IBOutlet UIView *vwStaticInfo;
@property (strong, nonatomic) IBOutlet UIView *vwUnitServiced;
@property (strong, nonatomic) IBOutlet UIView *vwRequestedPart;
@property (strong, nonatomic) IBOutlet UIView *vwWorkNotDone;
@property (strong, nonatomic) IBOutlet UIView *vwMaterialUsed;
@property (strong, nonatomic) IBOutlet UIView *vwPictures;
@property (strong, nonatomic) IBOutlet UIView *vwTimings;
@property (strong, nonatomic) IBOutlet UIView *vwActualTimings;

@property (strong, nonatomic) IBOutlet UIButton *btnMaterialList;
@property (strong, nonatomic) IBOutlet UIButton *btnRequestedPart;
@property (strong, nonatomic) IBOutlet UIButton *btnUnitServiced;
@property (strong, nonatomic) IBOutlet UIImageView *imgvMaterialArrow;

@property (strong, nonatomic) IBOutlet UITableView *tblvUnitServiced;
//tag 1 UnitServiced
@property (strong, nonatomic) IBOutlet UITableView *tblvMaterialUsed;
//tag 2 MaterialCell
@property (strong, nonatomic) IBOutlet UITableView *tblvRequestedPart;
//tag 3 RequestedPartCell

@property (strong, nonatomic) IBOutlet UIView *vwBelowUnitServiced;
@property (strong, nonatomic) IBOutlet UICollectionView *clvImage;

@property (strong, nonatomic) IBOutlet UILabel *lblNosignature;
@property (strong, nonatomic) IBOutlet UIImageView *imgvSignature;

@property (strong, nonatomic) IBOutlet UITextView *txtNotesToCustomer;
@property (strong, nonatomic) IBOutlet UITextView *txtWorkPerformed;
@property (strong, nonatomic) IBOutlet UITextView *txtEmployeeNotes;

@property (strong, nonatomic) IBOutlet UIButton *btnEmployee    ;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail    ;

@property  ACEServiceReport   *reportDetail      ;
@property  BOOL isClientEmail                    ;
@property  BOOL isCCEmail                        ;
@property  ZWTTextboxToolbarHandler *handler     ;
@property  NSMutableArray *arrTextbox            ;
@end

@implementation ServiceReportDetailViewController

@synthesize scrlvbg,vwStaticInfo,vwWorkNotDone,vwMaterialUsed,vwUnitServiced,vwRequestedPart,vwBelowUnitServiced,vwPictures,tblvMaterialUsed,vwTimings,vwActualTimings,tblvUnitServiced,tblvRequestedPart,clvImage,txtEmployeeNotes,txtWorkPerformed,txtNotesToCustomer,serviceReportId,btnMaterialList,btnUnitServiced,btnRequestedPart,imgvMaterialArrow,imgvArrowEmpNotes,txtfCcEmail;

@synthesize lblPurpose,lblReportNo,lblAccountNo,lblClientName,lblAssignTimeStarted,lblAssignCompleted,lblActualTimeStarted,lblAssignedTotalTimings,lblActualEndTime,lblExtraTime,lblReportDate,lblBillingType,lblClientEmail,reportDetail,lblNosignature,imgvSignature,isClientEmail,isCCEmail,handler,arrTextbox,lblCompany;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBgcolorOfViews];
    //[self setViewForWorkNotDone];
    [self callWebservice:serviceReportId];
    arrTextbox = [[NSMutableArray alloc]initWithObjects:txtfCcEmail, nil];
    //[self prepareview];
}
#pragma mark - Helper method
-(void)setBgcolorOfViews
{
    btnUnitServiced.layer.borderColor   = [[UIColor separatorColor]CGColor];
    btnUnitServiced.layer.borderWidth   = 1.0f;
    
    btnMaterialList.backgroundColor     = [UIColor whiteColor];
    btnRequestedPart.backgroundColor    = [UIColor whiteColor];
    
    vwBelowUnitServiced.backgroundColor = [UIColor whiteColor];
    vwStaticInfo.backgroundColor        = [UIColor whiteColor];
    vwWorkNotDone.backgroundColor       = [UIColor whiteColor];
    vwPictures.backgroundColor          = [UIColor whiteColor];
    vwMaterialUsed.backgroundColor      = [UIColor whiteColor];
    vwUnitServiced.backgroundColor      = [UIColor whiteColor];
    vwRequestedPart.backgroundColor     = [UIColor whiteColor];
    
    vwRequestedPart.layer.borderColor  = [[UIColor separatorColor]CGColor];
    vwRequestedPart.layer.borderWidth  = 1.0f;
    
    lblNosignature.layer.borderColor    = [[UIColor separatorColor]CGColor];
    
}
-(void)prepareview
{
    //[scrlvbg setContentSize:CGSizeMake(scrlvbg.width, 1490)];
    lblReportNo.text            = reportDetail.reportNumber     ;
    lblClientName.text          = reportDetail.ClientName       ;
    lblCompany.text             = reportDetail.Company          ;
    lblPurpose.text             = reportDetail.Purpose          ;
    lblBillingType.text         = reportDetail.BillingType      ;
    lblReportDate.text          = reportDetail.date             ;
    lblExtraTime.text           = reportDetail.extraTime        ;
    lblCompany.text             = reportDetail.Company          ;
    lblAssignTimeStarted.text   = reportDetail.assignStartTime  ;
    lblAssignCompleted.text     = reportDetail.assignEndTime    ;
    
    lblActualTimeStarted.text   = reportDetail.StartedWork      ;
    lblActualEndTime.text       = reportDetail.CompletedWork    ;
    
    lblAssignedTotalTimings.text = reportDetail.totalAssignTime  ;
    lblClientEmail.text          = reportDetail.Email            ;
    txtfCcEmail.text             = reportDetail.CCEmail          ;
    lblAccountNo.text            = reportDetail.AccountNo        ;

    /*if([reportDetail.CCEmail isEqualToString:@""])
    {
        lblCCEmail.text     = @"No CCEmail found";
    }*/

    txtWorkPerformed.text    = reportDetail.WorkPerformed;
    txtNotesToCustomer.text  = reportDetail.Recomm;
    txtEmployeeNotes.text    = reportDetail.empNotes;
    
    _isWorkNotDone = reportDetail.isWorkNotedone;
    
    if (reportDetail.SignatureUrl == nil)
    {
        lblNosignature.hidden            = NO;
        lblNosignature.layer.borderColor = [UIColor separatorColor].CGColor;
        lblNosignature.layer.borderWidth = 1.0;
    }
    else
    {
        lblNosignature.hidden = YES;
        [imgvSignature setImageWithURL:reportDetail.SignatureUrl];
    }
    
    if(_isWorkNotDone)
    {
        [self setViewForWorkNotDone];
    }
    else
    {
        [tblvUnitServiced  reloadData];
        [tblvMaterialUsed  reloadData];
        [tblvRequestedPart reloadData];
        [clvImage          reloadData];
        vwTimings.hidden   = NO       ;
        
        if(reportDetail.isDifferent)
        {
            if([reportDetail.extraTime isEqualToString:@""])
            {
                vwActualTimings.height = vwActualTimings.height - lblExtraTime.height-15;
                vwTimings.height       = vwActualTimings.y + vwActualTimings.height;
                vwStaticInfo.height    = vwTimings.y + vwTimings.height;
            }
        }
        else
        {
            vwActualTimings.hidden = YES;
            vwTimings.height       = vwTimings.height - vwActualTimings.height;
            vwStaticInfo.height    = vwTimings.y + vwTimings.height;
        }
        [self setFrameOfTableviews];
        
        _isMaterialUsehidden = YES                 ;
        _frmMaterialUsed     = vwMaterialUsed.frame;
        
        tblvMaterialUsed.userInteractionEnabled  = NO;
        tblvRequestedPart.userInteractionEnabled = NO;
    }
    
   // txtEmployeeNotes.editable = NO;
    
}

-(void)setViewForWorkNotDone
{
    vwUnitServiced.hidden      = YES;
    vwBelowUnitServiced.hidden = YES;
    vwTimings.hidden           = YES;
    
    vwStaticInfo.height        = vwStaticInfo.height - (vwTimings.height);
    
    vwWorkNotDone.frame        = CGRectMake(vwWorkNotDone.x, vwStaticInfo.y + vwStaticInfo.height+1, vwWorkNotDone.width, vwWorkNotDone.height);
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextbox andScroll:scrlvbg];
    handler.showNextPrevious = NO   ;
    handler.delegate         = self ;
}
-(void)setFrameOfTableviews
{
    vwUnitServiced.hidden      = NO;
    vwBelowUnitServiced.hidden = NO;
    
    tblvUnitServiced.frame = CGRectMake(tblvUnitServiced.x, tblvUnitServiced.y, tblvUnitServiced.width, tblvUnitServiced.contentSize.height);
    
    tblvMaterialUsed.frame = CGRectMake(tblvMaterialUsed.x, tblvMaterialUsed.y, tblvMaterialUsed.width, tblvMaterialUsed.contentSize.height);
    
    tblvRequestedPart.frame = CGRectMake(tblvRequestedPart.x, tblvRequestedPart.y, tblvRequestedPart.width, tblvRequestedPart.contentSize.height);
    
    vwUnitServiced.frame = CGRectMake(vwUnitServiced.x, vwStaticInfo.y + vwStaticInfo.height, vwUnitServiced.width, tblvUnitServiced.y + tblvUnitServiced.height); //+20
    
    vwRequestedPart.frame = CGRectMake(vwRequestedPart.x, vwRequestedPart.y, vwRequestedPart.width, tblvRequestedPart.y + tblvRequestedPart.height);
    
   // clvImage.frame = CGRectMake(clvImage.x, vwRequestedPart.y + vwRequestedPart.height + 20, clvImage.width, clvImage.height);
    
    vwPictures.frame = CGRectMake(vwPictures.x, vwRequestedPart.y + vwRequestedPart.height , vwPictures.width, vwPictures.height);
    
    vwBelowUnitServiced.frame = CGRectMake(vwBelowUnitServiced.x, vwBelowUnitServiced.y, vwBelowUnitServiced.width, vwPictures.y +vwPictures.height );
    
    vwBelowUnitServiced.frame = CGRectMake(vwBelowUnitServiced.x, vwUnitServiced.y + vwUnitServiced.height, vwBelowUnitServiced.width, vwBelowUnitServiced.height); // +20
    
    vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwBelowUnitServiced.y + vwBelowUnitServiced.height, vwWorkNotDone.width,vwWorkNotDone.height);
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextbox andScroll:scrlvbg];
    handler.delegate = self;
    handler.showNextPrevious = NO;
    
    if(reportDetail.Pictures.count == 0)
    {
        clvImage.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitPictures andImage:nil withFontColor:[UIColor appGreenColor] withHeight:clvImage.height];
    }
    
}
-(BOOL)isValidDetail
{
//    if(!(isClientEmail || isCCEmail))
//    {
//        [self showAlertWithMessage:ACENoEmailselected];
//        return NO;
//    }
    NSString *ccEmail = [self trimmWhiteSpaceFrom:txtfCcEmail.text];
    if(![ccEmail isEqualToString:@""])
    {
        ZWTValidationResult result;
        
        result = [txtfCcEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showAlertWithMessage:ACEBlankCCEmail];
            return NO;
        }
        else if (result == ZWTValidationResultInvalid)
        {
            [self showAlertWithMessage:ACEInvalidCCEmail];
            return NO;
        }
    }
    
    return YES;
}
#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnEmployeeTap:(UIButton *)sender
{
    if(_isEmployeeNotesOpen)
    {
        txtEmployeeNotes.hidden = YES;
        vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwWorkNotDone.y, vwWorkNotDone.width, sender.y +sender.height + 10);
        
         imgvArrowEmpNotes.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
    }
    else
    {
        [scrlvbg setContentOffset:CGPointMake(scrlvbg.x, scrlvbg.contentSize.height)];
        txtEmployeeNotes.hidden = NO;
        vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwWorkNotDone.y, vwWorkNotDone.width, txtEmployeeNotes.y +txtEmployeeNotes.height + 10);
        imgvArrowEmpNotes.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
    }
    
    _isEmployeeNotesOpen = !_isEmployeeNotesOpen;
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
}

- (IBAction)btnMaterialUsedTap:(id)sender
{
    if(_isMaterialUsehidden)
    {
        tblvMaterialUsed.hidden = NO;
        
        vwMaterialUsed.frame = CGRectMake(vwMaterialUsed.x, vwMaterialUsed.y, vwMaterialUsed.width, tblvMaterialUsed.y + tblvMaterialUsed.contentSize.height);
        
        _isMaterialUsehidden = NO;
         imgvMaterialArrow.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
    }
    else
    {
        tblvMaterialUsed.hidden     = YES;
        vwMaterialUsed.frame        = _frmMaterialUsed;
        _isMaterialUsehidden        = YES;
         imgvMaterialArrow.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
    }
    vwRequestedPart.frame = CGRectMake(vwRequestedPart.x, vwMaterialUsed.y + vwMaterialUsed.height, vwRequestedPart.width, vwRequestedPart.height);
    
    //clvImage.frame = CGRectMake(clvImage.x, vwRequestedPart.y + vwRequestedPart.height + 20, clvImage.width, clvImage.height);
     vwPictures.frame = CGRectMake(vwPictures.x, vwRequestedPart.y + vwRequestedPart.height , vwPictures.width, vwPictures.height);
    
    vwBelowUnitServiced.frame = CGRectMake(vwBelowUnitServiced.x,vwBelowUnitServiced.y , vwBelowUnitServiced.width, vwPictures.y + vwPictures.height);
    
    vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwBelowUnitServiced.y + vwBelowUnitServiced.height, vwWorkNotDone.width, vwWorkNotDone.height);
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextbox andScroll:scrlvbg];
    handler.delegate = self;
    handler.showNextPrevious = NO;
}
- (IBAction)btnEmailToClientTap:(UIButton *)btn
{
    if(btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
        
    }
    isClientEmail = !isClientEmail;
    btn.selected = !btn.selected;
    
}
- (IBAction)btnCCEmailTap:(UIButton *)btn
{
    [self removeErrorMessageBelowView:txtfCcEmail];
    
    txtfCcEmail.layer.borderColor = [UIColor separatorColor].CGColor;
    
    if(btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
    }
    
    isCCEmail   = !isCCEmail;
    btn.selected = !btn.selected;
}

- (IBAction)btnResendTap:(UIButton *)sender
{
    if([ACEUtil reachable])
    {
        if([self isValidDetail])
        {
             [self resendReport];
        }
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
    
}
#pragma mark - Webservice Method
-(void)callWebservice:(NSString *)reportId
{
        if([ACEUtil reachable])
        {
            [self getServiceReportDetail:reportId];
        }
        else
        {
            [self showAlertFromWithMessageWithSingleAction:ACENoInternet andHandler:^(UIAlertAction * _Nullable action)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
}
-(void)getServiceReportDetail:(NSString *)reportId
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                            SRKeyServiceReportId : reportId,
                            UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    
    //NSLog(@"%@",dict);
   [ACEWebServiceAPI getServiceReportDetail:dict completionHandler:^(ACEAPIResponse *response, ACEServiceReport *reportDEtail)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            reportDetail = reportDEtail;
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
        else if (response.message)
        {
           
            [self showAlertWithMessage:response.message];
        }
        else
        {
            //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
       [self prepareview];
    }];
    
}
-(void)resendReport
{
    [SVProgressHUD show];
    
    NSMutableArray *arrEmails =[[NSMutableArray alloc]init];
    
    //[arrEmails addObject:reportDetail.Email];
    
    if(txtfCcEmail.text)
    {
        [arrEmails addObject:txtfCcEmail.text];
    }
    
    NSDictionary *dict = @{
                           SRKeyServiceReportId : serviceReportId,
                           UKeyEmployeeID       : ACEGlobalObject.user.userID,
                           GKeyResendEmails     : arrEmails
                           };
    
    [ACEWebServiceAPI resendServiceReport:dict completionHandler:^(ACEAPIResponse *response)
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
#pragma mark - Tableview delegate and datasource method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 2) //material tableview
    {
        //return scheduleDetail.unitList.count;
       // return arrSelectedUnit.count;
        return reportDetail.UnitList.count;
    }
    else
    {
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25,5, vw.width, 30)];
    // label.center = CGPointMake(15, vw.height/2);
    
    label.text            = reportDetail.UnitList[section][SDKeyUnitName];
    label.textColor       = [UIColor blackColor];
    // label.backgroundColor = [UIColor clearColor];
    
    [vw addSubview:label];
    
    vw.backgroundColor    = [UIColor selectedBackgroundColor];
    
    return vw;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 2)
    {
        return 40;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1) // unit tableview
    {
        return reportDetail.UnitList.count;
    }
    else if(tableView.tag == 2) // material tableview
    {
        return [reportDetail.UnitList[section][SRKeyServiceUnitParts] count];
    }
    else if (tableView.tag == 3) // requested part tableview
    {
        return reportDetail.RequestedPart.count;
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView.tag == 1) //unit tableview
    {
       ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitServiced"];
        
        NSDictionary *dict = reportDetail.UnitList[indexPath.row];
        
        cell.lblName.text = dict[ACKeyNameOfUnit];
        
        return cell;
    }
    else if(tableView.tag == 2) // material tableview
    {
        ACEMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
        
        NSDictionary *dict = reportDetail.UnitList[indexPath.section][SRKeyServiceUnitParts][indexPath.row];
        
        cell.lblMaterialName.text  = dict[SRKeyReqPartName];
        
        int qty = [dict[SRKeyPartQnty]intValue];
        
        if(qty > 0)
        {
            cell.lblQuantity.hidden = NO;
            cell.lblQuantity.text  = [NSString stringWithFormat:@"%d",qty];
        }
        else
        {
            cell.lblQuantity.hidden = YES;
        }
        return cell;
       // cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
       // cell.textLabel.text = dict[SRKeyReqPartName];
        
    }
    else if (tableView.tag == 3) // requested part tableview
    {
        ACESelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestedPartCell"];
        
        cell.lblName.text = [NSString stringWithFormat:@"%@ %@",
        reportDetail.RequestedPart[indexPath.row][SRKeyReqPartName],reportDetail.RequestedPart[indexPath.row][SRKeyReqPartSize]];
        
        return cell;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
    {
       NSDictionary *dict = reportDetail.UnitList[indexPath.row];
        
        UnitDetailViewableViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitDetailViewableViewController"];
    
        vc.unitId = dict[GKeyId];
    
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark - Collectionview delegate and datasource method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return reportDetail.Pictures.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACEServiceImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSURL*imgurl = reportDetail.Pictures[indexPath.row];
    
    [cell.imgvService setImageWithURL:imgurl];
    
   // cell.imgvService.image = [UIImage imageNamed:@"img-03.png"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACEServiceImage *image = [[ACEServiceImage alloc]init];
    image.imageURL  = reportDetail.Pictures[indexPath.row];
        
        // cell.imgvAcUnit setImagewi
        //cell.imgvAcUnit.image =
    OpenImageViewcontroller *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"OpenImageViewcontroller"];
    
    //vc.index     = indexPath.row;
    //vc.arrImages = reportDetail.Pictures;
    vc.unitImage = image;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];

}
#pragma mark - UITextfield delegate method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    return YES;
}
#pragma mark - ZWTTextboxToolbarHandlerDelegate method
-(void)doneTap
{
    
}
@end
