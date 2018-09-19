//
//  NewServiceReportViewController.m
//  AircallEmployee
//
//  Created by ZWT112 on 4/1/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "NewServiceReportViewController.h"

@interface NewServiceReportViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,SignatureCaptured,RequestPartViewControllerDelegate,ZWTTextboxToolbarHandlerDelegate,SaveReportDataPopupViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBg;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceCaseNo;
@property (weak, nonatomic) IBOutlet UILabel *lblAcNo;
@property (weak, nonatomic) IBOutlet UILabel *lblClientName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;

@property (weak, nonatomic) IBOutlet UILabel *lblPurpose;
@property (weak, nonatomic) IBOutlet UILabel *lblContractType;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeStarted;
@property (weak, nonatomic) IBOutlet UILabel *lblClientEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeftText;

@property (weak, nonatomic) IBOutlet UITextField *txtCCEmail;

@property (weak, nonatomic) IBOutlet SAMTextView *txtvWorkPerformed;
@property (weak, nonatomic) IBOutlet SAMTextView *txtvNotesToCustomer;

@property (weak, nonatomic) IBOutlet UIView *vwStaticInfo;
@property (weak, nonatomic) IBOutlet UIView *vwUnitServiced;
@property (weak, nonatomic) IBOutlet UIView *vwbelowUnitSeviced;
@property (weak, nonatomic) IBOutlet UIView *vwMaterialListUsed;
@property (weak, nonatomic) IBOutlet UIView *vwRequestedPart;
@property (weak, nonatomic) IBOutlet UIView *vwWorkNotDone;
@property (weak, nonatomic) IBOutlet UIView *vwAboveSign;
@property (weak, nonatomic) IBOutlet UIView *vwBelowSign;

@property (weak, nonatomic) IBOutlet UIView *vwUnitManual;
@property (weak, nonatomic) IBOutlet UIView *vwPictures;

@property (weak, nonatomic) IBOutlet UIView *vwSignature;

@property (weak, nonatomic) IBOutlet UITableView *tblvUnitServiced; // tag 1 UnitCell
@property (weak, nonatomic) IBOutlet UITableView *tblvMaterialUsed; // tag 2 MaterialCell
@property (weak, nonatomic) IBOutlet UITableView *tblvRequestedPart; // tag 3 RequestedPartCell
@property (weak, nonatomic) IBOutlet UITableView *tblvServiceReportHistory; // tag 4 ServiceHistoryCell
@property (weak, nonatomic) IBOutlet UITableView *tblvUnitManual; // tag 5 UnitManualCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvMaterialArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnSignature;
@property (weak, nonatomic) IBOutlet UIButton *btnMaterialList;
@property (weak, nonatomic) IBOutlet UIButton *btnRequestedPart;
@property (weak, nonatomic) IBOutlet UIButton *btnServiceHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnUnitManual;
@property (weak, nonatomic) IBOutlet UIButton *btnWorkNotDone;
@property (weak, nonatomic) IBOutlet UICollectionView *collvImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSignatureTap;

@property (weak,nonatomic) ACEServiceImageCell *cell;

@property  NSMutableArray *arrServiceImage;
@property  NSMutableArray *arrRequestedPart;

@property  BOOL isWorkNotdone       ;
@property  BOOL isMaterialUsehidden ;
@property  BOOL isClientEmail       ;
@property  BOOL isCCEmail           ;

@property  int  totalSeconds        ;

@property  CGRect  frmMaterialListUsed;
@property  CGRect  frmRequestedPart;
@property  CGRect  frmPictureView;
@property  CGRect  frmBelowUnitServiced;
@property  CGRect  frmWorknotDone;
@property  CGSize  scrlvContent;

@property AppDelegate* delegate;

@property NSDate *startTime;
@property NSDate *endTime;
@property NSDateFormatter *dateFormat;

@property NSMutableArray *arrSelectedUnit           ;
@property NSMutableArray *arrSelectdMaterialIndex   ;
@property NSMutableArray *arrSelectedMaterial       ;
@property NSMutableArray *arrselectedMaterialQty    ;

@property NSInteger imgIndexPath;

@property ZWTTextboxToolbarHandler *handler;
@end

@implementation NewServiceReportViewController

@synthesize collvImage,arrServiceImage,cell,scrlvBg,delegate,scheduleDetail,arrSelectedUnit,arrSelectdMaterialIndex,arrSelectedMaterial,isClientEmail,isCCEmail,arrselectedMaterialQty,totalSeconds;

@synthesize vwStaticInfo,vwUnitServiced,tblvUnitServiced,tblvMaterialUsed,tblvUnitManual,tblvRequestedPart,tblvServiceReportHistory,vwbelowUnitSeviced,vwMaterialListUsed,vwRequestedPart,vwWorkNotDone,vwUnitManual,arrRequestedPart,txtvWorkPerformed,txtvNotesToCustomer,vwPictures,vwSignature,vwAboveSign,vwBelowSign,automaticallyAdjustsScrollViewInsets;

@synthesize btnMaterialList,btnRequestedPart,imgvMaterialArrow,btnUnitManual,btnServiceHistory,imgIndexPath,btnWorkNotDone,btnSignature,btnSignatureTap;

@synthesize lblAcNo,lblDate,lblPurpose,lblTimeLeft,lblClientName,lblClientEmail,lblTimeStarted,lblContractType,lblServiceCaseNo,txtCCEmail,lblTimeLeftText,lblCompany;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad]             ;
    
    [self initializeVariables]      ;
    [self prepareLabels]            ;
    [self prepareViews]             ;
    [self startServiceReportTimer]  ;
    
}
-(void)initializeVariables
{
    delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(ACEGlobalObject.isTimerRunning)
    {
        arrServiceImage         = ACEGlobalObject.arrServiceImage       ;
        arrSelectedUnit         = ACEGlobalObject.arrSelectedUnit       ;
        //arrSelectdMaterialIndex = ACEGlobalObject.arrSelectedMaterial   ;
        arrRequestedPart        = ACEGlobalObject.arrRequestedPart      ;
        _isWorkNotdone          = ACEGlobalObject.isWorknotDone         ;
        arrSelectedMaterial     = ACEGlobalObject.arrSelectedMaterial   ;
        arrselectedMaterialQty  = ACEGlobalObject.arrSelectedMaterialQty;
        arrSelectdMaterialIndex = [[NSMutableArray alloc]init];
        totalSeconds            = ACEGlobalObject.totalSheduleSeconds   ;
    }
    else
    {
        ACEGlobalObject.startReportLattitude = delegate.latitude;
        ACEGlobalObject.startReportLongitude = delegate.longitude;
        
        arrServiceImage             = [[NSMutableArray alloc]init];
        arrRequestedPart            = [[NSMutableArray alloc]init];
        arrSelectedUnit             = [[NSMutableArray alloc]init];
        arrSelectdMaterialIndex     = [[NSMutableArray alloc]init];
        arrSelectedMaterial         = [[NSMutableArray alloc]init];
        
        _isWorkNotdone              = NO;
        
        for(int i =0 ; i<=14 ; i++)
        {
            ACEServiceImage *imgServicePlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
    
            imgServicePlaceholder.status = ACEImageStatusPlaceholder;
    
            [self.arrServiceImage addObject:imgServicePlaceholder];
        }
    }
    collvImage.dataSource = self;
    collvImage.delegate   = self;
    
    [collvImage reloadData];
    
    _handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:(txtvWorkPerformed),(txtvNotesToCustomer),(txtCCEmail), nil] andScroll:scrlvBg];
    _handler.delegate = self;
}
#pragma mark - Timer Method
-(void)startServiceReportTimer
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"TimeNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"SaveDataInGlobal"
                                               object:nil];
    
    if(!ACEGlobalObject.isTimerRunning)
    {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"hh:mm a"];
        [_dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        //[_dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        
        //[_dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        
       // NSString *start = [_dateFormat stringFromDate:[NSDate date]];
        
        _startTime = [_dateFormat dateFromString:scheduleDetail.startTime];
        _endTime   = [_dateFormat dateFromString:scheduleDetail.EndTime];
        
        //NSTimeInterval interval = [_endTime timeIntervalSinceDate:_startTime];
        
       //[delegate findTimeIntervalFromTime:interval];
        [delegate findTimeIntervalFromTime:0];
        
        totalSeconds = delegate.totalSeconds;
    }
    if (ACEGlobalObject.isTimerRunning && ACEGlobalObject.isRelaunch)
    {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"hh:mm a"];
        [_dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSDate *start = [_dateFormat dateFromString:ACEGlobalObject.timeStarted];
        
        NSString *sEnd = [_dateFormat stringFromDate:[NSDate date]];
        
        NSDate *end   = [_dateFormat dateFromString:sEnd];
        
        //NSLog(@"\nStart Date: %@",start);
        //NSLog(@"\nEnd Date: %@",end);
        
        NSTimeInterval interval = [end timeIntervalSinceDate:start];
        
        //int diff = totalSeconds - interval;
        int diff = interval;
        ACEGlobalObject.isRelaunch = NO;
       // NSString *snEnd = [_dateFormat stringFromDate:[[NSDate date] dateByAddingTimeInterval:-(diff)]];
        
        //NSDate *nend   = [_dateFormat dateFromString:snEnd];
        
        [delegate findTimeIntervalFromTime:diff];
    }
    
}
- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"TimeNotification"])
    {
        NSString *time = (NSString *)notification.object;
        NSArray *arr   = [time componentsSeparatedByString:@"\n"];
        lblTimeLeft.text = arr[0];
        if(arr.count > 1)
            lblTimeLeftText.text = arr[1];
    }
    if ([[notification name] isEqualToString:@"SaveDataInGlobal"])
    {
        [self saveAllDataInGlobalVariables];
    }
}

#pragma mark - SaveReportDataPopupViewControllerDelegate method
-(void)selectedOption:(BOOL)ans
{
    if(ans)
    {
        [self saveAllDataInGlobalVariables];
    }
    else
    {
        [ACEGlobalObject clearAllData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableview Delegate & Datasource Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 2)
    {
        //return scheduleDetail.unitList.count;
        return arrSelectedUnit.count;
    }
    else
    {
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 30)];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35,5, vw.width, 30)];
    // label.center = CGPointMake(15, vw.height/2);
    
    label.text           = arrSelectedUnit[section][SDKeyUnitName];
    label.textColor      = [UIColor blackColor];
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
    if(tableView.tag == 1)
    {
        return scheduleDetail.unitList.count;
    }
    else if(tableView.tag == 2)
    {
//        NSDictionary *dict = scheduleDetail.unitList[section];
//        NSArray *arr = dict[SDKeyPartsList];
//        return arr.count;
        
       // return [scheduleDetail.unitList[section][SDKeyPartsList] count];
        NSArray *arr = arrSelectedUnit[section][SDKeyPartsList];
        return arr.count;
        //return 1;
    }
    else if (tableView.tag == 3)
    {
        return arrRequestedPart.count;
    }
    else if (tableView.tag == 4)
    {
        return scheduleDetail.reportsList.count;
    }
    else if (tableView.tag == 5)
    {
        return scheduleDetail.manualList.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tcell;
   
    if(tableView.tag == 1) //unit
    {
        ACEMaterialListCell *mcell  = [tableView dequeueReusableCellWithIdentifier:@"UnitCell"];
        
        NSDictionary *dict  = scheduleDetail.unitList[indexPath.row];
        BOOL isMatched  = NO;
        
        for(int i = 0 ; i < arrSelectedUnit.count;i++)
        {
            NSDictionary *dict1 = arrSelectedUnit[i];
            
            if([dict1[SDKeyUnitId] isEqualToString:dict[SDKeyUnitId]])
            {
                isMatched = YES;
                break;
            }
        }
        
        // if([arrSelectedUnit containsObject:dict[SDKeyUnitId]])
        if(isMatched)
        {
            mcell.lblMaterialName.text      =  dict[SDKeyUnitName];
            mcell.lblMaterialName.textColor =  [UIColor appGreenColor];
            [mcell.btnCheck setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
            mcell.btnCheck.selected = YES;
        }
        else
        {
            mcell.lblMaterialName.text      =  dict[SDKeyUnitName];
            mcell.lblMaterialName.textColor =  [UIColor redColor];
            [mcell.btnCheck setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            mcell.btnCheck.selected = NO;
        }
        
        [mcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return mcell;
    }
    else if (tableView.tag == 2) // material
    {
       ACEMaterialListCell *mcell  = [tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
        
        //ACEParts *parts = scheduleDetail.unitList[indexPath.section][SDKeyPartsList][indexPath.row];
        
        ACEParts *parts = arrSelectedUnit[indexPath.section][SDKeyPartsList][indexPath.row];
        
        int qty = [parts.Qty intValue];
        
        if(qty > 1)
        {
            mcell.vwLbz.hidden                  = NO;
            mcell.lblQnty.text                  = @"1";
            mcell.maxQty                        = qty;
            mcell.incrQty                       = 1;
            //mcell.vwLbz.userInteractionEnabled  = NO;
            //mcell.vwLbz.alpha                   = 0.7;
        }
        else
        {
            mcell.lblQnty.text          = parts.Qty;
            mcell.vwLbz.hidden          = YES;
        }
        
        mcell.lblMaterialName.text  = [NSString stringWithFormat:@"%@ %@",parts.partName,parts.partSize];
        
//        mcell.lblMaterialName.textColor = [UIColor redColor];
//        mcell.lblMaterialName.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0f];
        
        __block bool ans  = NO;
        
        [arrSelectedMaterial enumerateObjectsUsingBlock:^(ACEParts * _Nonnull spart, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if([spart.ID isEqualToString:parts.ID])
            {
                ans = YES;
                *stop = YES;
                return;
            }
            
        }];
        
        if(ans)
        {
            [mcell.btnCheck setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
            mcell.btnCheck.selected = YES;
            [arrSelectdMaterialIndex addObject:indexPath];
            
            // GKeyPart
            // SRKeyPartQnty
            for (NSDictionary *dict in arrselectedMaterialQty)
            {
                ACEParts *partSelected = dict[GKeyPart];
                if([parts.ID isEqualToString:partSelected.ID])
                {
                    mcell.lblQnty.text = dict[SRKeyPartQnty];
                    break;
                }
            }
        }
        else
        {
            [mcell.btnCheck setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
            mcell.btnCheck.selected = NO;
        }
       
        return mcell;
    }
    else if (tableView.tag == 3) //requested part
    {
        ACEParts *part = arrRequestedPart[indexPath.row][SRKeySelectedPart];
        
        ACESelectionCell *tcell = [tableView dequeueReusableCellWithIdentifier:@"RequestedPartCell"];
        [tcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //tcell.lblName.text  = part.partName;
        tcell.lblName.text  = [NSString stringWithFormat:@"%@ %@",part.partName,part.partSize];
        return tcell;
    }
    else if (tableView.tag == 4) //service history
    {
        ACESelectionCell *scell = [tableView dequeueReusableCellWithIdentifier:@"ServiceHistoryCell"];
        
        NSDictionary *dict = scheduleDetail.reportsList[indexPath.row];
        
        scell.lblName.text   = [NSString stringWithFormat:@"Service Report No - %@",dict[SDKeyReportNumber]];
        
        return scell;
       
    }
    else if (tableView.tag == 5) //unit manual
    {
        ACESelectionCell *mcell = [tableView dequeueReusableCellWithIdentifier:@"UnitManualCell"];
        
        NSDictionary *dict = scheduleDetail.manualList[indexPath.row];
        
        mcell.lblName.text = dict[SDKeyManualName];
        
        return mcell;
    }
    
    [tcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return tcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) //unit
    {
         NSDictionary *dict  = scheduleDetail.unitList[indexPath.row];
        
        UnitDetailViewableViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitDetailViewableViewController"];
        vc.unitId       = dict[SDKeyUnitId];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (tableView.tag == 4) //service history
    {
        NSDictionary *dict = scheduleDetail.reportsList[indexPath.row];
        ServiceReportDetailViewableController *vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"ServiceReportDetailViewableController"];
        vc.serviceId = [dict[GKeyId] stringValue];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (tableView.tag == 5) //unit manual
    {
        NSDictionary *dict = scheduleDetail.manualList[indexPath.row];
        
        NSURL *url = [NSURL URLWithString:dict[SDKeyManualURL]];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
        else
        {
            [self showAlertWithMessage:ACECanNotOpenUrl];
        }
       
    }
}
#pragma mark - UICollectionView Delegate Method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrServiceImage.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    cell.serviceImage = arrServiceImage[indexPath.item];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int numberOfCellInRow = 4;
    
   CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
    
    return CGSizeMake(cellWidth*1.2, cellWidth*1.3);
   
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACEServiceImage *serviceImage = arrServiceImage[indexPath.item];
    
    switch (serviceImage.status)
    {
        case ACEImageStatusPlaceholder:
        {
            imgIndexPath = indexPath.item;
            [self askImageSource];
            break;
        }
        case ACEImageStatusSet:
        {
            [self openImageController:serviceImage];
            break;
        }
        case ACEImageStatusUploding:
        {
            break;
        }
        case ACEImageStatusUploded:
        {
            break;
        }
    }
}
#pragma mark - Signature Capture Delegate method
-(void)Signature:(UIImage *)signature
{
    [btnSignature setTitle:@"" forState:UIControlStateNormal];
    [btnSignature setBackgroundImage:signature forState:UIControlStateNormal];
}
#pragma mark - RequestPartViewController Delegate method
-(void)requestedPartDetail:(NSDictionary *)dict
{
    [arrRequestedPart addObject:dict];
    [tblvRequestedPart reloadData];
    [self setFrameOfRequestedPartTableview];
}

#pragma mark - ZWTTextToolbarHandler delegate Method
-(void)doneTap
{
    
}
#pragma mark - UITextfield delegate method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    return YES;
}
#pragma mark - Validation Method
-(BOOL)isMatchPartWithUnit
{
    for(int i = 0 ; i < arrSelectedUnit.count;i++)
    {
        NSArray  *arrPart = arrSelectedUnit[i][SDKeyPartsList];
        
        BOOL isContain = NO;
        
        for(int j = 0 ;j < arrPart.count;j++)
        {
            for(int k =0 ; k < arrSelectedMaterial.count ; k++)
            {
                ACEParts *spart = arrSelectedMaterial[k];
                ACEParts *aPart = arrPart[j];
                
                if([spart.ID isEqualToString:aPart.ID])
                {
                    isContain = YES;
                    break;
                }
            }
            
        }
        if(!isContain)
            return NO;
            
    }
    return YES;
}
/*-(BOOL)isMaterialParts
{
    for(int i = 0 ; i < arrSelectedUnit.count;i++)
    {
        NSArray *arrPart = arrSelectedUnit[i][SDKeyPartsList];
        
        if(arrPart.count == 0)
        {
            return NO;
        }
        
    }
    
    return YES;
}*/
-(BOOL)validateData
{
    if(!_isWorkNotdone)
    {
        if(arrSelectedUnit.count == 0)
        {
            
            [self showAlertWithMessage:ACENoUnitsSelected];
            return NO;
        }
        /*if(arrSelectedMaterial.count == 0)
        {
            [self showAlertWithMessage:ACENoPartsSelected];
            return NO;
        }
        if(![self isMatchPartWithUnit])
        {
            [self showAlertWithMessage:ACEUnMatchedUnitsParts];
            return NO;
        }
        if(!(btnSignature.currentBackgroundImage))
        {
            [self showAlertWithMessage:ACEBlankClientSignature];
            return NO;
        }*/

    }
    txtvWorkPerformed.text = [self trimmWhiteSpaceFrom:txtvWorkPerformed.text];
    
    if([txtvWorkPerformed.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACEBlankWorkPerformed];
        return NO;
    }
   /* if(!_isWorkNotdone)
    {
        if([txtvNotesToCustomer.text isEqualToString:@""])
        {
            [self showAlertWithMessage:ACEBlankNotesToCustomer];
            return NO;
        }
    }*/
   /* if(!(isCCEmail || isClientEmail))
    {
        [self showAlertWithMessage:ACENoEmailselected];
        return NO;
    }*/
    NSString *ccemail = [self trimmWhiteSpaceFrom:txtCCEmail.text];
    if(![ccemail isEqualToString:@""])
    {
        ZWTValidationResult result;
        
        result = [txtCCEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
        
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
#pragma mark - Helper Method
-(void)prepareLabels
{
    _dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"hh:mm a"];

    lblServiceCaseNo.text           = scheduleDetail.serviceCaseNum ;
    lblAcNo.text                    = scheduleDetail.accountNum     ;
    lblCompany.text                 = scheduleDetail.company        ;
    lblPurpose.text                 = scheduleDetail.purpose        ;
    lblContractType.text            = scheduleDetail.contract       ;

    lblTimeStarted.text             = [_dateFormat stringFromDate:[NSDate date]];
    
    [_dateFormat setDateFormat:@"MMMM dd, yyyy"];
    lblDate.text                    = [_dateFormat stringFromDate:[NSDate date]];
    lblClientEmail.text             = scheduleDetail.email;
    lblClientName.text              = scheduleDetail.clientName;
    txtvWorkPerformed.placeholder   = @"Work Performed";
    txtvNotesToCustomer.placeholder = @"Recommendations to customer";
}

-(void)prepareViews
{
    //NSLog(@"schedule detail :%@",scheduleDetail.unitList);
    
    [tblvUnitServiced reloadData];
    [tblvUnitManual reloadData];
    [tblvMaterialUsed reloadData];
    [tblvRequestedPart reloadData];
    [tblvServiceReportHistory reloadData];
    
    [self setFrameOfTableviews];
    [self saveOriginalFrame];
    
    if(arrRequestedPart.count > 0)
    {
        [self setFrameOfRequestedPartTableview];
    }
    
   // _isWorkNotdone = NO;
    
    if(_isWorkNotdone)
    {
        _isWorkNotdone = NO;
        [self btnWorkNotDoneTap:btnWorkNotDone];
    }
    if(![ACEGlobalObject.workPerformed isEqualToString:@""])
    {
        txtvWorkPerformed.text   = ACEGlobalObject.workPerformed;
    }
    if(![ACEGlobalObject.recomm isEqualToString:@""])
    {
        txtvNotesToCustomer.text = ACEGlobalObject.recomm;
    }
    if(ACEGlobalObject.timeStarted)
    {
        lblTimeStarted.text   = ACEGlobalObject.timeStarted;
    }
    if(ACEGlobalObject.signatureImg)
    {
        [btnSignature setBackgroundImage:ACEGlobalObject.signatureImg forState:UIControlStateNormal];
    }
    _isMaterialUsehidden = YES;
}
-(void)saveAllDataInGlobalVariables
{
    [_dateFormat setDateFormat:@"MMMM dd, yyyy"];
    
    ACEGlobalObject.arrSelectedUnit         = [arrSelectedUnit mutableCopy]           ;
    ACEGlobalObject.arrSelectedMaterial     = [arrSelectedMaterial mutableCopy]       ;
    ACEGlobalObject.arrServiceImage         = [arrServiceImage mutableCopy]           ;
    ACEGlobalObject.arrRequestedPart        = [arrRequestedPart mutableCopy]          ;
    ACEGlobalObject.isWorknotDone           = _isWorkNotdone            ;
    ACEGlobalObject.scheduleId              = scheduleDetail.ID         ;
    ACEGlobalObject.timeStarted             = lblTimeStarted.text       ;
    ACEGlobalObject.signatureImg            = btnSignature.currentBackgroundImage;
    ACEGlobalObject.totalSheduleSeconds     = totalSeconds;
    ACEGlobalObject.arrSelectedMaterialQty  = [self makeSelectedMaterialArray];
    ACEGlobalObject.savedDate               = [_dateFormat stringFromDate:[NSDate date]];
    
    if(txtvWorkPerformed.text)
    {
        ACEGlobalObject.workPerformed       = txtvWorkPerformed.text;
    }
    if(txtvNotesToCustomer.text)
    {
        ACEGlobalObject.recomm              = txtvNotesToCustomer.text;
    }
    
   /* NSDictionary *reportDict =
                            @{
                           GKeyUnitlist      : arrSelectedUnit,
                           GKeyMaterialList  : arrSelectedMaterial,
                           GKeyImageList     : arrServiceImage,
                           GKeyRequestedPart : arrRequestedPart,
                           GKeyIsWorkNotDone : @(_isWorkNotdone),
                           GKeyScheduleId    : ACEGlobalObject.scheduleId,
                           GKeyTimeStarted   : lblTimeStarted.text,
                          // GKeySignatureImage: ACEGlobalObject.signatureImg,
                           GKeyMaterialQty   :  ACEGlobalObject.arrSelectedMaterialQty,
                           GKeyWorkPerformed   : txtvWorkPerformed.text,
                           GKeyNotesToCustomer : txtvNotesToCustomer.text,
                           GKeyIsTimerRunning  : @(YES)
                           };*/
    
     NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:[self saveUnitArray:arrSelectedUnit] forKey:GKeyUnitlist];
    
    [dict setValue:[self saveMaterialArray:arrSelectedMaterial] forKey:GKeyMaterialList];
    [dict setValue:[self saveRequestedPartArray:arrRequestedPart] forKey:GKeyRequestedPart];
    [dict setValue:[self saveSelectedMaterialQty:ACEGlobalObject.arrSelectedMaterialQty] forKey:GKeyMaterialQty];
    [dict setValue:@(_isWorkNotdone) forKey:GKeyIsWorkNotDone];
    [dict setValue:@(totalSeconds) forKey:GKeyTotalSheduleSeconds];
    [dict setValue:ACEGlobalObject.scheduleId forKey:GKeyScheduleId];
    [dict setValue:txtvWorkPerformed.text forKey:GKeyWorkPerformed];
    [dict setValue:txtvNotesToCustomer.text forKey:GKeyNotesToCustomer];
    [dict setValue:@(YES) forKey:GKeyIsTimerRunning];
    [dict setValue:lblTimeStarted.text forKey:GKeyTimeStarted];
    [dict setValue:ACEGlobalObject.startReportLattitude forKey:GKeyStartlattitude];
    [dict setValue:ACEGlobalObject.startReportLongitude forKey:GKeyStartLongitude];
    [dict setValue:[self saveImageArray:arrServiceImage] forKey:GKeyServiceImgArr];
    
    [dict setValue:[_dateFormat stringFromDate:[NSDate date]] forKey:GKeySavedDate];
    
    if(btnSignature.currentBackgroundImage)
    {
        [dict setValue:UIImageJPEGRepresentation(btnSignature.currentBackgroundImage, 0) forKey:GKeySignature];
    }
    else
    {
        UIImage *img = [[UIImage alloc]init];
        [dict setValue:UIImageJPEGRepresentation(img, 0) forKey:GKeySignature];
    }
    
    NSUserDefaults *reportDefault = [NSUserDefaults standardUserDefaults];
    [reportDefault setValue:dict forKey:GKeySavedReportData];
    [reportDefault setBool:YES forKey:GKeyIsTimerRunning];
    [reportDefault synchronize];
    
}
-(NSMutableArray *)saveMaterialArray:(NSArray*)arrMaterial
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrMaterial enumerateObjectsUsingBlock:^(ACEParts   * _Nonnull part, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSDictionary *dict = [part toDictionary];
        [arr addObject:dict];
    }];
    return arr;
}
-(NSMutableArray *)saveUnitArray:(NSArray *)arrUnit
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrUnit enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSMutableArray *arrPart    = [[NSMutableArray alloc]init];
        
       [dict[SDKeyPartsList] enumerateObjectsUsingBlock:^(ACEParts * _Nonnull part, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSDictionary *dict = [part toDictionary];
            [arrPart addObject:dict];
        }];
        
        [mdict setValue:arrPart forKey:SDKeyPartsList];
        [arr addObject:mdict];
    }];
    
    return arr;
    
}
-(NSMutableArray *)saveRequestedPartArray:(NSArray *)arrREquestedPart
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arrREquestedPart enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        NSDictionary *pDict = [dict[SRKeySelectedPart] toDictionary];
        [mdict setValue:pDict forKey:SRKeySelectedPart];
        [arr addObject:mdict];
    }];
    
    return arr;
}
-(NSMutableArray *)saveSelectedMaterialQty:(NSArray *)arrMaterial
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrMaterial enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSDictionary *pdict = [mdict[GKeyPart] toDictionary];
        [mdict setValue:pdict forKey:GKeyPart];
        [arr addObject:mdict];
    }];
    
    return arr;
}
-(NSMutableArray *)saveImageArray:(NSArray*)arrImage
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [arrImage enumerateObjectsUsingBlock:^(ACEServiceImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSDictionary *dict = @{
                               GKeyServiceImage : UIImageJPEGRepresentation(image.image, 0),
                               GKeyImageStatus  :@(image.status)
                               };
        [arr addObject:dict];
    }];
    
    return arr;
}
//-(void)clearAllData
//{
//    ACEGlobalObject.arrSelectedMaterial = nil;
//    ACEGlobalObject.arrSelectedUnit     = nil;
//    ACEGlobalObject.arrServiceImage     = nil;
//    ACEGlobalObject.isWorknotDone       = NO;
//    ACEGlobalObject.isTimerRunning      = NO;
//    
//    [delegate stopTimer];
//
//}
-(void)openPopupViewController
{
    SaveReportDataPopupViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SaveReportDataPopupViewController"];
    
    vc.delegate   = self;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)setFrameOfTableviews
{
    
    tblvUnitServiced.height = tblvUnitServiced.contentSize.height;
    tblvMaterialUsed.height = tblvMaterialUsed.contentSize.height;
    
    if (scheduleDetail.reportsList.count > 0)
    {
        tblvServiceReportHistory.height = tblvServiceReportHistory.contentSize.height;
    }
    else
    {
        tblvServiceReportHistory.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoServiceReports andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvServiceReportHistory.height];
    }
    if (scheduleDetail.manualList.count > 0)
    {
        tblvUnitManual.height = tblvUnitManual.contentSize.height;
        vwUnitManual.frame = CGRectMake(vwUnitManual.x, tblvServiceReportHistory.y + tblvServiceReportHistory.height, vwUnitManual.width,  tblvUnitManual.y + tblvUnitManual.contentSize.height); //+20
    }
    else
    {
        tblvUnitManual.height = 50;
        vwUnitManual.frame = CGRectMake(vwUnitManual.x, tblvServiceReportHistory.y + tblvServiceReportHistory.height, vwUnitManual.width,  tblvUnitManual.y + tblvUnitManual.height); //+20
        tblvUnitManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnitManual.height];
    }
    vwUnitServiced.height = tblvUnitServiced.y + tblvUnitServiced.height;
    vwbelowUnitSeviced.y  = vwUnitServiced.y + vwUnitServiced.height;
    
    vwBelowSign.height    = vwUnitManual.y + vwUnitManual.height;
    
    vwWorkNotDone.frame   = CGRectMake(vwWorkNotDone.x, vwbelowUnitSeviced.y + vwbelowUnitSeviced.height, vwWorkNotDone.width, vwBelowSign.y + vwBelowSign.height);
    
    [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
    [_handler setScroll:scrlvBg withTextBoxes:[NSMutableArray arrayWithObjects:(txtvWorkPerformed),(txtvNotesToCustomer),(txtCCEmail), nil]];
    
}
-(void)setFrameOfMaterialTableview
{
    if(arrSelectedUnit.count == 0)
    {
        tblvMaterialUsed.height = 50;
        
        tblvMaterialUsed.backgroundView = [ACEUtil viewNoDataWithMessage:@"Please select Unit first" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvMaterialUsed.height];
    }
    else
    {
        tblvMaterialUsed.height = tblvMaterialUsed.contentSize.height;
    }

    if(!_isMaterialUsehidden)
    {
        vwMaterialListUsed.height = tblvMaterialUsed.y + tblvMaterialUsed.height;
        
        vwRequestedPart.y  = vwMaterialListUsed.y + vwMaterialListUsed.height;
        
        vwPictures.y  = vwRequestedPart.y + vwRequestedPart.height;
        vwbelowUnitSeviced.height = vwPictures.y + vwPictures.height;
        vwWorkNotDone.y = vwbelowUnitSeviced.y + vwbelowUnitSeviced.height;
    
        [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
        [_handler setScroll:scrlvBg withTextBoxes:[NSMutableArray arrayWithObjects:(txtvWorkPerformed),(txtvNotesToCustomer),(txtCCEmail), nil]];
    
    }
}
-(void)setFrameOfRequestedPartTableview
{
    tblvRequestedPart.hidden = NO;
    
    tblvRequestedPart.frame = CGRectMake(tblvRequestedPart.x, tblvRequestedPart.y, tblvRequestedPart.width, tblvRequestedPart.contentSize.height);
    
    vwRequestedPart.frame = CGRectMake(vwRequestedPart.x, vwRequestedPart.y, vwRequestedPart.width, tblvRequestedPart.y + tblvRequestedPart.height);
    
    vwPictures.frame = CGRectMake(vwPictures.x, vwRequestedPart.y + vwRequestedPart.height , vwPictures.width, vwPictures.height);
    
    vwbelowUnitSeviced.frame = CGRectMake(vwbelowUnitSeviced.x, vwbelowUnitSeviced.y, vwbelowUnitSeviced.width, vwPictures.y +vwPictures.height);
    
    vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwbelowUnitSeviced.y + vwbelowUnitSeviced.height, vwWorkNotDone.width, vwWorkNotDone.height);
    
    [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    [_handler setScroll:scrlvBg withTextBoxes:[NSMutableArray arrayWithObjects:(txtvWorkPerformed),(txtvNotesToCustomer),(txtCCEmail), nil]];
    _frmRequestedPart.size.height  = vwRequestedPart.frame.size.height;
    
}
-(void)saveOriginalFrame
{
    vwUnitServiced.backgroundColor     = [UIColor whiteColor];
    vwMaterialListUsed.backgroundColor = [UIColor whiteColor];
    vwUnitManual.backgroundColor       = [UIColor whiteColor];
    vwRequestedPart.backgroundColor    = [UIColor whiteColor];
    vwPictures.backgroundColor         = [UIColor whiteColor];
    vwbelowUnitSeviced.backgroundColor = [UIColor whiteColor];
    vwWorkNotDone.backgroundColor      = [UIColor whiteColor];
    
   // btnMaterialList.layer.borderColor   = [[UIColor separatorColor]CGColor];
    //btnMaterialList.layer.borderWidth   = 1.0f;
    vwMaterialListUsed.layer.borderColor      = [[UIColor separatorColor]CGColor];
    vwMaterialListUsed.layer.borderWidth      = 1.0f;
    
    btnServiceHistory.layer.borderColor       = [[UIColor separatorColor]CGColor];
    btnServiceHistory.layer.borderWidth       = 1.0f;

    btnUnitManual.layer.borderColor           = [[UIColor separatorColor]CGColor];
    btnUnitManual.layer.borderWidth           = 1.0f;

    txtvWorkPerformed.layer.borderColor       = [[UIColor separatorColor]CGColor];
    txtvWorkPerformed.layer.borderWidth       = 1.0f;
    
    txtvNotesToCustomer.layer.borderColor     = [[UIColor separatorColor]CGColor];
    txtvNotesToCustomer.layer.borderWidth     = 1.0f;
    
    vwPictures.layer.borderColor              = [[UIColor separatorColor]CGColor];
    vwPictures.layer.borderWidth              = 1.0f;
    
   // vwRequestedPart.layer.borderColor          = [[UIColor separatorColor]CGColor];
   // vwRequestedPart.layer.borderWidth          = 1.0f;
    
    _frmMaterialListUsed   = vwMaterialListUsed.frame;
    _frmRequestedPart      = vwRequestedPart.frame;
    _frmPictureView        = vwPictures.frame;
    _frmBelowUnitServiced  = vwbelowUnitSeviced.frame;
    _frmWorknotDone        = vwWorkNotDone.frame;
    _scrlvContent          = scrlvBg.contentSize;
    
}
-(void)askImageSource
{
    [self.view endEditing:YES];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:appName
                                                                         message:ACETextAskImageSource
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:ACETextFromCamera
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectPlantImageFrom:UIImagePickerControllerSourceTypeCamera];
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:ACETextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectPlantImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
                                }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:ACETextCancel
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                             {
                                 [actionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:fromAlbum];
    [actionSheet addAction:cancel];
    
    actionSheet.popoverPresentationController.sourceView = self.view;
    actionSheet.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.width/2, self.view.height/2 , 1.0, 1.0);
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectPlantImageFrom:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
        
        BOOL isAuthorizedLibrary = NO;
        
        if (photoStatus == PHAuthorizationStatusAuthorized)
        {
            // Access has been granted.
            isAuthorizedLibrary = YES;
            [self openImagePicker:sourceType];
        }
        else if (photoStatus == PHAuthorizationStatusDenied)
        {
            // Access has been denied.
        }
        else if (photoStatus == PHAuthorizationStatusNotDetermined)
        {
            // Access has not been determined.
        }
        else if (photoStatus == PHAuthorizationStatusRestricted)
        {
            // Restricted access - normally won't happen.
        }
        
        if (isAuthorizedLibrary == NO)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus Authstatus)
             {
                 if (Authstatus == PHAuthorizationStatusAuthorized)
                 {
                     [self openImagePicker:sourceType];
                 }
                 else
                 {
                    // [self showAlertWithMessage:ACEAllowAccessPhotoLibrary];
                     NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your photos. To enable access, tap Settings and turn on Photos.",appName];
                     
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                     {
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                     }]];
                     
                     [self presentViewController:alert animated:YES completion:nil];
                 }
             }];
        }
        
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        BOOL isAuthorizedCamera = NO;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized)
        {
            isAuthorizedCamera = YES;
            [self openImagePicker:sourceType];
        }
        else if(authStatus == AVAuthorizationStatusDenied)
        {
            // denied
        }
        else if(authStatus == AVAuthorizationStatusRestricted)
        {
            // restricted, normally won't happen
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            // not determined?!
        }
        else
        {
            // impossible, unknown authorization status
        }
        
        if (isAuthorizedCamera == NO)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self openImagePicker:sourceType];
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        //[self showAlertWithMessage:ACEAllowAccessCamera];
                                        NSString *msg = [NSString stringWithFormat:@"%@ does not have access to your camera. To enable access, tap Settings and turn on Camera.",appName];
                                        
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                                          {
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                          }]];
                                        [self presentViewController:alert animated:YES completion:nil];
                                    });
                    }
             }];
        }
    }
    else
    {
        NSAssert(NO, @"Permission type not found");
    }
}

-(void)openImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType    = sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
         
         if(arrServiceImage.count <= 15)
         {
             ACEServiceImage *serviceImage = [[ACEServiceImage alloc]initWithUIImage:selectedImage];
         
             serviceImage.status = ACEImageStatusSet;

             [self.arrServiceImage replaceObjectAtIndex:imgIndexPath withObject:serviceImage];
            
             [self.collvImage reloadData];
         }
         
     }];
}

//- (void)preparePlantImage:(ACEServiceImage *)selectedServiceImage
//{
//    selectedServiceImage.status = ACEImageStatusSet;
//             
//    //[self uploadPlantImage:selectedServiceImage];
//    
//    [self.collvImage reloadData];
//}

//- (void)uploadPlantImage:(ACEServiceImage *)plantImage
//{
//    if([ACEUtil reachable])
//    {
//        plantImage.status = ACEImageStatusUploding;
//        plantImage.status = ACEImageStatusUploded;
//        [collvImage reloadData];
//    }
//    else
//    {
//        [self showAlertWithMessage:ACENoInternet];
//    }
//}
-(NSIndexPath *)getIndexpathFrombutton:(UIButton *)btn andTableview:(UITableView *)tblv
{
    CGPoint pointInSuperview = [btn.superview convertPoint:btn.center toView:tblv];
    
    NSIndexPath *indexPath = [tblv indexPathForRowAtPoint:pointInSuperview];
    
    return indexPath;
    
}
-(void)removeSelectedPartsOfUnit:(NSDictionary *)unit
{
    for (int i = 0; i<[unit[SDKeyPartsList] count]; i++)
    {
        ACEParts *part = unit[SDKeyPartsList][i];
        if([arrSelectedMaterial containsObject:part])
        {
            [arrSelectedMaterial removeObject:part];
        }
    }
}
-(NSMutableArray *)makeSelectedMaterialArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arrSelectdMaterialIndex.count; i++)
    {
        NSIndexPath *indexPath  = arrSelectdMaterialIndex[i];
        NSDictionary *uDict = arrSelectedUnit[indexPath.section];
        ACEParts *part      = uDict[SDKeyPartsList][indexPath.row];
        
        ACEMaterialListCell *mcell= [tblvMaterialUsed cellForRowAtIndexPath:indexPath];
        
        NSDictionary *dict  = @{
                                GKeyPart        : part,
                                SRKeyPartQnty   : mcell.lblQnty.text,
                                SRKeyUnitId     : uDict[SRKeyUnitId]
                                };
        
        [arr addObject:dict];
        
    }
    return  arr;
}
-(void)openImageController:(ACEServiceImage *)image
{
    OpenImageViewcontroller *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"OpenImageViewcontroller"];
    vc.unitImage = image;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - Event Method
- (IBAction)btnDeleteTap:(UIButton *)sender
{
    CGPoint pointInSuperview = [sender.superview convertPoint:sender.center toView:collvImage];
    
    NSIndexPath *indexPath = [collvImage indexPathForItemAtPoint:pointInSuperview];
    
    ACEServiceImage *serviceImage = arrServiceImage[indexPath.item];
    serviceImage.image          = [UIImage imageNamed:@"defimage"];
    serviceImage.status         = ACEImageStatusPlaceholder;
    
    [arrServiceImage replaceObjectAtIndex:indexPath.item withObject:serviceImage];
    
    [collvImage reloadData];
}
- (IBAction)btnUnitCheckTap:(UIButton *)btn
{
    NSIndexPath *indexPath = [self getIndexpathFrombutton:btn andTableview:tblvUnitServiced];
    
    ACEMaterialListCell *ucell = [tblvUnitServiced cellForRowAtIndexPath:indexPath];
    
    if(btn.selected)
    {
        [ucell.btnCheck setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        
        ucell.lblMaterialName.textColor = [UIColor redColor];
        
        //[arrSelectedUnit removeObject:scheduleDetail.unitList[indexPath.row][SDKeyUnitId]];
        NSDictionary *dict = scheduleDetail.unitList[indexPath.row];
        
        for (NSDictionary *dict1 in arrSelectedUnit)
        {
            if([dict1[SDKeyUnitId] isEqualToString:dict[SDKeyUnitId]])
            {
               [arrSelectedUnit removeObject:dict1];
               break;
            }
        }
        
        [self removeSelectedPartsOfUnit:scheduleDetail.unitList[indexPath.row]];
    }
    else
    {
        [ucell.btnCheck setImage:[UIImage imageNamed:@"checkbox-selected"] forState:UIControlStateNormal];
        
        ucell.lblMaterialName.textColor =   [UIColor appGreenColor];
        
        //[arrSelectedUnit addObject:scheduleDetail.unitList[indexPath.row][SDKeyUnitId]];
        [arrSelectedUnit addObject:scheduleDetail.unitList[indexPath.row]];
    }
    
    [tblvMaterialUsed reloadData];
    
    [self setFrameOfMaterialTableview];
    
    btn.selected = !btn.selected;
}
- (IBAction)btnMaterialCheckTap:(UIButton *)btn
{
    NSIndexPath *indexPath     = [self getIndexpathFrombutton:btn andTableview:tblvMaterialUsed];
    
    ACEMaterialListCell *ucell = [tblvMaterialUsed cellForRowAtIndexPath:indexPath];
    
    
    if(btn.selected)
    {
        [ucell.btnCheck setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
//        ucell.vwLbz.userInteractionEnabled = NO;
//        ucell.vwLbz.alpha                  = 0.7;
        
        [arrSelectdMaterialIndex removeObject:indexPath];
        [arrSelectedMaterial removeObject:arrSelectedUnit[indexPath.section][SDKeyPartsList][indexPath.row]];
        
        //[arrSelectdMaterial removeObject:scheduleDetail.unitList[indexPath.section][SDKeyPartsList][indexPath.row]];
    }
    else
    {
        [ucell.btnCheck setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
        
        [arrSelectdMaterialIndex addObject:indexPath];
        [arrSelectedMaterial addObject:arrSelectedUnit[indexPath.section][SDKeyPartsList][indexPath.row]];
        
//        ucell.vwLbz.userInteractionEnabled = YES;
//        ucell.vwLbz.alpha                  = 1.0;
       // [arrSelectdMaterial addObject:scheduleDetail.unitList[indexPath.section][SDKeyPartsList][indexPath.row]];
    }
    
    btn.selected = !btn.selected;
}

- (IBAction)btnBackTap:(id)sender
{
    [self openPopupViewController];
    
}
- (IBAction)btnRequestedPartTap:(id)sender
{
    RequestPartViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"RequestPartViewController"];
    //vc.delegate = self;
    vc.clientName = scheduleDetail.clientName;
    vc.arrunit    = scheduleDetail.unitList;
    vc.arrAddress = [NSMutableArray arrayWithObjects:scheduleDetail.address.fullAddress, nil];
    vc.delegate             = self;
    vc.isFromServiceReport  = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnClientemailTap:(UIButton *)btn
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
- (IBAction)btnCCemailTap:(UIButton *)btn
{
    [self removeErrorMessageBelowView:txtCCEmail];
    txtCCEmail.layer.borderColor = [UIColor separatorColor].CGColor;
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

- (IBAction)btnWorkNotDoneTap:(UIButton *)btn
{
    
    if(_isWorkNotdone)
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone"] forState:UIControlStateNormal];
        
        vwUnitServiced.hidden     = NO;
        vwbelowUnitSeviced.hidden = NO;
        vwSignature.hidden        = NO;
        vwSignature.y             = vwAboveSign.y + vwAboveSign.height;
        vwBelowSign.y             = vwSignature.y + vwSignature.height;
        
        vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwbelowUnitSeviced.y + vwbelowUnitSeviced.height, vwWorkNotDone.width, vwBelowSign.y+vwBelowSign.height);
        
        _isWorkNotdone = NO;
         btnSignatureTap.enabled = YES;
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"worknotdone-selected"] forState:UIControlStateNormal];
        
        vwUnitServiced.hidden     = YES;
        vwbelowUnitSeviced.hidden = YES;
        vwSignature.hidden        = YES;
        
        vwBelowSign.y       = vwAboveSign.y + vwAboveSign.height;
        vwWorkNotDone.frame = CGRectMake(vwWorkNotDone.x, vwStaticInfo.y + vwStaticInfo.height, vwWorkNotDone.width, vwBelowSign.y+vwBelowSign.height);
        
        _isWorkNotdone = YES;
        btnSignatureTap.enabled = NO;
        [btnSignature setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
    [_handler setScroll:scrlvBg withTextBoxes:[NSMutableArray arrayWithObjects:(txtvWorkPerformed),(txtvNotesToCustomer),(txtCCEmail), nil]];
    
}
- (IBAction)btnMaterialListUsed:(UIButton *)sender
{
    //[tblvMaterialUsed reloadData];
    
    if(_isMaterialUsehidden)
    {
        tblvMaterialUsed.hidden = NO;
        
        if(arrSelectedUnit.count == 0)
        {
            tblvMaterialUsed.height = 50;
            tblvMaterialUsed.backgroundView = [ACEUtil viewNoDataWithMessage:@"Please select Unit first" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvMaterialUsed.height];
            vwMaterialListUsed.frame = CGRectMake(vwMaterialListUsed.x, vwMaterialListUsed.y, vwMaterialListUsed.width, tblvMaterialUsed.y + tblvMaterialUsed.height);
            
        }
        else
        {
            vwMaterialListUsed.frame = CGRectMake(vwMaterialListUsed.x, vwMaterialListUsed.y, vwMaterialListUsed.width, tblvMaterialUsed.y + tblvMaterialUsed.contentSize.height);
        }

        _isMaterialUsehidden = NO;
        imgvMaterialArrow.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
    }
    else
    {
        tblvMaterialUsed.hidden     = YES;
        vwMaterialListUsed.frame    = _frmMaterialListUsed;
        _isMaterialUsehidden        = YES;
        imgvMaterialArrow.transform = CGAffineTransformMakeRotation(360 * M_PI/180);
        
    }
    vwRequestedPart.frame   = CGRectMake(vwRequestedPart.x, vwMaterialListUsed.y + vwMaterialListUsed.height, vwRequestedPart.width, vwRequestedPart.height);
    
    vwPictures.frame        = CGRectMake(vwPictures.x, vwRequestedPart.y + vwRequestedPart.height, vwPictures.width, vwPictures.height);
    
    vwbelowUnitSeviced.frame = CGRectMake(vwbelowUnitSeviced.x,vwbelowUnitSeviced.y , vwbelowUnitSeviced.width, vwPictures.y + vwPictures.height );
    
    vwWorkNotDone.frame     = CGRectMake(vwWorkNotDone.x, vwbelowUnitSeviced.y + vwbelowUnitSeviced.height, vwWorkNotDone.width, vwWorkNotDone.height);
    
    [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, vwWorkNotDone.y + vwWorkNotDone.height)];
    
    [_handler setScroll:scrlvBg withTextBoxes:[NSMutableArray arrayWithObjects:(txtvWorkPerformed),(txtvNotesToCustomer),(txtCCEmail), nil]];
}
- (IBAction)btnSignatureTap:(id)sender
{
   
   SignatureViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SignatureViewController"];
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)btnSubmitTap:(id)sender
{
    if([self validateData])
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:appName message:ACESubmitServiceReport preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:ACETextYes style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            [self submitData];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:ACETextNo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void)submitData
{
    
    [ACEGlobalObject clearAllData];
     NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"hh:mm a"];

   
    NSString *strEndTime = [format stringFromDate:[NSDate date]];
    
    AddEmployeeNoteViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddEmployeeNoteViewController"];
    
    vc.scheduleDetail    = scheduleDetail           ;
    
    vc.arrselectedPart   = [self makeSelectedMaterialArray];
    vc.arrselectedUnits  = arrSelectedUnit          ;
    vc.arrrequestedParts = arrRequestedPart         ;
    vc.arrserviceImages  = arrServiceImage          ;
    vc.isWorkNoteDone    = _isWorkNotdone           ;
    vc.workPerformed     = txtvWorkPerformed.text   ;
    vc.recomm            = txtvNotesToCustomer.text ;
    vc.startTime         = lblTimeStarted.text      ;
    vc.endTime           = strEndTime               ;
    vc.signature         = btnSignature.currentBackgroundImage  ;
    vc.email             = lblClientEmail.text      ;
    vc.ccEmail           = txtCCEmail.text          ;
    
    vc.startReportLattitude = ACEGlobalObject.startReportLattitude;
    vc.startReportLongitude = ACEGlobalObject.startReportLongitude;
    
    [self.navigationController pushViewController:vc animated:YES];


}
@end
