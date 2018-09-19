//
//  ServiceReportDetailViewableController.m
//  AircallEmployee
//
//  Created by ZWT111 on 02/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ServiceReportDetailViewableController.h"

@interface ServiceReportDetailViewableController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvbg;
@property (strong, nonatomic) IBOutlet UIView *vwStaticInfo;
@property (strong, nonatomic) IBOutlet UIView *vwUnitServiced;
@property (strong, nonatomic) IBOutlet UIView *vwRequestedPart;
@property (strong, nonatomic) IBOutlet UIView *vwWorkNotDone;
@property (strong, nonatomic) IBOutlet UIView *vwMaterialUsed;
@property (strong, nonatomic) IBOutlet UIView *vwTimings;

@property (strong, nonatomic) IBOutlet UITableView *tblvUnitServiced;
//tag 1 UnitServiced
@property (strong, nonatomic) IBOutlet UITableView *tblvMaterialUsed;
//tag 2 MaterialCell
@property (strong, nonatomic) IBOutlet UITableView *tblvRequestedPart;
//tag 3 RequestedPartCell

@property (strong, nonatomic) IBOutlet UIView *vwBelowUnitServiced;
@property (strong, nonatomic) IBOutlet UICollectionView *clvImage;
@property (strong, nonatomic) IBOutlet UIView *vwPictures;
@property (strong, nonatomic) IBOutlet UIView *vwActualTimings;

@property (strong, nonatomic) IBOutlet UIButton *btnSignature;

@property (strong, nonatomic) IBOutlet UITextView *txtEmployeeNotes;
@property (strong, nonatomic) IBOutlet UIImageView *imgvArrow;
@property (strong, nonatomic) IBOutlet UIImageView *imgvArrowMaterial;

@property (strong, nonatomic) IBOutlet UIButton *btnEmployee;

@property (strong, nonatomic) IBOutlet UILabel *lblServiceCaseNo;
@property (strong, nonatomic) IBOutlet UILabel *lblAccountNo;
@property (strong, nonatomic) IBOutlet UILabel *lblContactName;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;

@property (strong, nonatomic) IBOutlet UILabel *lblVisitPurpose;

@property (strong, nonatomic) IBOutlet UILabel *lblBillingType;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignedStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignedEndTime;
@property (strong, nonatomic) IBOutlet UILabel *lblActualStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblActualEndTime;
@property (strong, nonatomic) IBOutlet UILabel *lbltotalAssignedTime;

@property (strong, nonatomic) IBOutlet UILabel *lblExtraTime;

@property (strong, nonatomic) IBOutlet SAMTextView *txtvWorkPerformed;
@property (strong, nonatomic) IBOutlet SAMTextView *txtvReccomendation;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblCCEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgvSignature;

@property NSArray *arrUnits;
@property NSArray *arrmaterialList;
@property NSArray *arrrequestedParts;
@property NSMutableArray *arrImages;


@property BOOL isMaterialUsehidden,isWorkNotDone,isEmployeeNotesOpen;
@property CGRect frmMaterialUsed;
@property (strong, nonatomic) IBOutlet UILabel *lblNoSignature;

@end

@implementation ServiceReportDetailViewableController

@synthesize scrlvbg,vwStaticInfo,vwWorkNotDone,vwMaterialUsed,vwUnitServiced,vwRequestedPart,vwBelowUnitServiced,tblvMaterialUsed,tblvUnitServiced,tblvRequestedPart,clvImage,txtEmployeeNotes,vwPictures,imgvArrow,lblEmail,txtvReccomendation,txtvWorkPerformed,lblAssignedStartTime,lblAssignedEndTime,lblDate,lblBillingType,lblVisitPurpose,lblContactName,lblAccountNo,lblServiceCaseNo,arrUnits,arrmaterialList,arrrequestedParts,arrImages,btnSignature,lblCCEmail,imgvSignature,lblNoSignature,imgvArrowMaterial,lblActualStartTime,lblActualEndTime,lblExtraTime,lbltotalAssignedTime,vwTimings,vwActualTimings,lblCompany;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBgcolorOfViews];
    [self prepareview];
    [self getServiceDetail];

}
#pragma mark - Helper method
-(void)setDetail:(ACEServiceReport*)report
{
    lblServiceCaseNo.text           = report.reportNumber    ;
    lblAccountNo.text               = report.AccountNo       ;
    lblContactName.text             = report.ClientName      ;
    lblCompany.text                 = report.Company         ;
    lblVisitPurpose.text            = report.Purpose         ;
    lblBillingType.text             = report.BillingType     ;
    lblDate.text                    = report.date            ;
    lblActualStartTime.text         = report.StartedWork     ;
    lblActualEndTime.text           = report.CompletedWork   ;
    lblAssignedStartTime.text       = report.assignStartTime ;
    lblAssignedEndTime.text         = report.assignEndTime   ;
    lblExtraTime.text               = report.extraTime       ;
    lbltotalAssignedTime.text       = report.totalAssignTime ;
    txtvWorkPerformed.text          = report.WorkPerformed   ;
    txtvReccomendation.text         = report.Recomm          ;
    lblEmail.text                   = report.Email           ;
    
    if ([report.CCEmail isEqualToString:@""])
    {
        lblCCEmail.text      = @"No CCEmail Found";
        lblCCEmail.textColor = [UIColor grayColor];
    }
    else
    {
        lblCCEmail.text      = report.CCEmail;
    }
    
    txtEmployeeNotes.text    = report.empNotes;
    arrUnits                 = report.UnitList;
    arrImages                = report.Pictures;
    arrrequestedParts        = report.RequestedPart;
    
    if (report.SignatureUrl == nil)
    {
        lblNoSignature.hidden            = NO;
        lblNoSignature.layer.borderColor = [UIColor separatorColor].CGColor;
        lblNoSignature.layer.borderWidth = 1.0;
    }
    else
    {
        lblNoSignature.hidden            = YES;
        [imgvSignature setImageWithURL:report.SignatureUrl];
    }
    
    [tblvUnitServiced  reloadData];
    [tblvMaterialUsed  reloadData];
    [tblvRequestedPart reloadData];
    [clvImage          reloadData];
    
    _isWorkNotDone = report.isWorkNotedone;
    
    if(_isWorkNotDone)
    {
        [self setViewForWorkNotDone];
    }
    else
    {
        if(report.isDifferent)
        {
            if([report.extraTime isEqualToString:@""])
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
        
        _isMaterialUsehidden = YES;
        _frmMaterialUsed     = vwMaterialUsed.frame;
        tblvMaterialUsed.userInteractionEnabled  = NO;
        tblvRequestedPart.userInteractionEnabled = NO;
    }
    
    if(report.Pictures.count == 0)
    {
        clvImage.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitPictures andImage:nil withFontColor:[UIColor appGreenColor] withHeight:clvImage.height];
    }

}
-(void)setBgcolorOfViews
{
    vwStaticInfo.backgroundColor    =   [UIColor whiteColor];
    vwWorkNotDone.backgroundColor   =   [UIColor whiteColor];
    vwMaterialUsed.backgroundColor  =   [UIColor whiteColor];
    vwUnitServiced.backgroundColor  =   [UIColor whiteColor];
    vwRequestedPart.backgroundColor =   [UIColor whiteColor];
    
}
-(void)prepareview
{
    //[scrlvbg setContentSize:CGSizeMake(scrlvbg.width, 1490)];
    
    arrUnits          = [[NSArray alloc]init];
    arrImages         = [[NSMutableArray alloc]init];
    arrmaterialList   = [[NSArray alloc]init];
    arrrequestedParts = [[NSArray alloc]init];
    
    tblvRequestedPart.separatorColor = [UIColor clearColor];
    tblvUnitServiced.separatorColor  = [UIColor clearColor];
    tblvMaterialUsed.separatorColor  = [UIColor clearColor];
    
    [tblvUnitServiced  reloadData];
    [tblvMaterialUsed  reloadData];
    [tblvRequestedPart reloadData];
    [clvImage          reloadData];
    
    txtEmployeeNotes.editable = NO;
   
}
-(void)setViewForWorkNotDone
{
    vwUnitServiced.hidden      = YES;
    vwBelowUnitServiced.hidden = YES;
    vwTimings.hidden           = YES;
    vwStaticInfo.height        = vwStaticInfo.height - (vwTimings.height);

    vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwStaticInfo.y + vwStaticInfo.height, vwWorkNotDone.width, _btnEmployee.y + _btnEmployee.height);
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
}
-(void)setFrameOfTableviews
{
    tblvUnitServiced.frame  = CGRectMake(tblvUnitServiced.x, tblvUnitServiced.y, tblvUnitServiced.width, tblvUnitServiced.contentSize.height);
    
    tblvMaterialUsed.frame  = CGRectMake(tblvMaterialUsed.x, tblvMaterialUsed.y, tblvMaterialUsed.width, tblvMaterialUsed.contentSize.height);
    
    tblvRequestedPart.frame = CGRectMake(tblvRequestedPart.x, tblvRequestedPart.y, tblvRequestedPart.width, tblvRequestedPart.contentSize.height);
    
   vwUnitServiced.frame     = CGRectMake(vwUnitServiced.x, vwStaticInfo.y + vwStaticInfo.height, vwUnitServiced.width, tblvUnitServiced.y + tblvUnitServiced.height); //+20
    
    vwRequestedPart.frame   = CGRectMake(vwRequestedPart.x, vwRequestedPart.y, vwRequestedPart.width, tblvRequestedPart.y + tblvRequestedPart.height);
    
    vwPictures.frame        = CGRectMake(vwPictures.x, vwRequestedPart.y + vwRequestedPart.height , vwPictures.width, vwPictures.height );
    
    clvImage.frame          = CGRectMake(clvImage.x, clvImage.y, clvImage.width, clvImage.height);
    
    vwBelowUnitServiced.frame = CGRectMake(vwBelowUnitServiced.x, vwBelowUnitServiced.y, vwBelowUnitServiced.width, vwPictures.y +vwPictures.height);
    
    vwBelowUnitServiced.frame = CGRectMake(vwBelowUnitServiced.x, vwUnitServiced.y + vwUnitServiced.height, vwBelowUnitServiced.width, vwBelowUnitServiced.height); // +20
    
    vwWorkNotDone.frame       = CGRectMake(vwWorkNotDone.x, vwBelowUnitServiced.y + vwBelowUnitServiced.height, vwWorkNotDone.width,_btnEmployee.y +_btnEmployee.height + 10 );
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
}

#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnEmployeeTap:(UIButton *)sender
{
    if(_isEmployeeNotesOpen)
    {
        imgvArrow.image          = [UIImage imageNamed:@"nextarrow"];
        txtEmployeeNotes.hidden  = YES;
        vwWorkNotDone.frame      = CGRectMake(vwWorkNotDone.x, vwWorkNotDone.y, vwWorkNotDone.width, sender.y +sender.height + 10);
    }
    else
    {
        scrlvbg.contentOffset   = CGPointMake(scrlvbg.x, scrlvbg.contentSize.height);
        imgvArrow.image         = [UIImage imageNamed:@"downarrow"];
        txtEmployeeNotes.hidden = NO;
        vwWorkNotDone.frame     = CGRectMake(vwWorkNotDone.x, vwWorkNotDone.y, vwWorkNotDone.width, txtEmployeeNotes.y +txtEmployeeNotes.height + 10);
    }
    _isEmployeeNotesOpen = !_isEmployeeNotesOpen;
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    

}
- (IBAction)btnMaterialUsedTap:(id)sender
{
    if(_isMaterialUsehidden)
    {
        imgvArrowMaterial.image = [UIImage imageNamed:@"downarrow"];
        tblvMaterialUsed.hidden = NO;
        
        vwMaterialUsed.frame = CGRectMake(vwMaterialUsed.x, vwMaterialUsed.y, vwMaterialUsed.width, tblvMaterialUsed.y + tblvMaterialUsed.contentSize.height);
        
        _isMaterialUsehidden = NO;
    }
    else
    {
        imgvArrowMaterial.image     = [UIImage imageNamed:@"nextarrow"];
        tblvMaterialUsed.hidden     = YES;
        vwMaterialUsed.frame        = _frmMaterialUsed;
        _isMaterialUsehidden        = YES;
        
    }
    vwRequestedPart.frame = CGRectMake(vwRequestedPart.x, vwMaterialUsed.y + vwMaterialUsed.height, vwRequestedPart.width, vwRequestedPart.height);
    vwPictures.frame      = CGRectMake(vwPictures.x, vwRequestedPart.y + vwRequestedPart.height , vwPictures.width, vwPictures.height);
    clvImage.frame        = CGRectMake(clvImage.x, clvImage.y, clvImage.width, clvImage.height);
    
    vwBelowUnitServiced.frame = CGRectMake(vwBelowUnitServiced.x,vwBelowUnitServiced.y , vwBelowUnitServiced.width, vwPictures.y + vwPictures.height );
    
    vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwBelowUnitServiced.y + vwBelowUnitServiced.height, vwWorkNotDone.width, vwWorkNotDone.height);
    
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
}

#pragma mark - Tableview delegate and datasource method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 2)
    {
        return arrUnits.count;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1)
        return arrUnits.count;
    else if(tableView.tag == 2)
        return [arrUnits[section][SRKeyServiceUnitParts] count];
    else if (tableView.tag == 3)
        return arrrequestedParts.count;
    else
        return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView.tag == 1) //tblv unit
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UnitServiced"];
        cell.textLabel.text = arrUnits[indexPath.item][ACKeyNameOfUnit];
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, tblvUnitServiced.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        [cell.contentView addSubview:lineView];
        
    }
    else if(tableView.tag == 2) // tblv material
    {
        ACEMaterialCell *materialCell = [tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
        arrmaterialList = arrUnits[indexPath.section][SRKeyServiceUnitParts];
        NSDictionary *dictMaterials  = arrmaterialList[indexPath.item];
        materialCell.lblMaterialName.text = dictMaterials[SRKeyReqPartName];
        int qty = [dictMaterials[SRKeyPartQnty]intValue];
        
        if(qty > 0)
        {
             materialCell.lblQuantity.hidden = NO;
             materialCell.lblQuantity.text   = [NSString stringWithFormat:@"%d",qty];
        }
        else
        {
            materialCell.lblQuantity.hidden = YES;
        }

        return materialCell;
    }
    else if (tableView.tag == 3) // tblv requested
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RequestedPartCell"];
        //cell.textLabel.text = arrrequestedParts[indexPath.item][SRKeyReqPartName];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                             arrrequestedParts[indexPath.item][SRKeyReqPartName],arrrequestedParts[indexPath.item][SRKeyReqPartSize]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
   
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 2)
    {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vw     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18,5, vw.width, 30)];
    // label.center = CGPointMake(15, vw.height/2);
    NSDictionary *dictUnit = arrUnits[section];
    label.text             = dictUnit[ACKeyNameOfUnit];
    label.textColor        = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"OpenSans" size:16.0];
    // label.backgroundColor = [UIColor clearColor];
    
    [vw addSubview:label];
    vw.backgroundColor    = [UIColor selectedBackgroundColor];
    
    return vw;
}

#pragma mark - Collectionview delegate and datasource method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrImages.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACEServiceImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgvService setImageWithURL:arrImages[indexPath.item]];
    return cell;
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    //return UIEdgeInsetsMake(7, 10, 5, 10);
//}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACEServiceImage *image = [[ACEServiceImage alloc]init];
    image.imageURL         = arrImages[indexPath.row];

    OpenImageViewcontroller *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"OpenImageViewcontroller"];
    
    vc.unitImage = image;
    //vc.index     = indexPath.row;
    //vc.arrImages = arrImages;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - WebService Method

-(void)getServiceDetail
{
    if ([ACEUtil reachable])
    {
        NSDictionary *dict = @{
                               SRKeyServiceReportId : _serviceId,
                               UKeyEmployeeID : ACEGlobalObject.user.userID
                               };
        
        [SVProgressHUD show];
        
        [ACEWebServiceAPI getServiceReportDetail:dict completionHandler:^(ACEAPIResponse *response, ACEServiceReport *reportDetail)
         {
             if (response.code == RCodeSuccess)
             {
                 [SVProgressHUD dismiss];
                 
                 [self setDetail:reportDetail];
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
@end
