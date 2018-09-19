//
//  UnitDetailViewableViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 18/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//


#import "UnitDetailViewableViewController.h"

@interface UnitDetailViewableViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *lblunitTonTitleUp;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitTonTitleDown;

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblplan;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitType;
@property (strong, nonatomic) IBOutlet UILabel *lblManfDate;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitTon;
@property (strong, nonatomic) IBOutlet UILabel *lblPackagedTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblsplitTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblModelNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblSerialNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblQntyFilter;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitManfDate;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitUnitTon;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitModelNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitSerialNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitQntyFilter;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitQntyFuse;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitBooster;
@property (strong, nonatomic) IBOutlet UILabel *lblQntyFuse;
@property (strong, nonatomic) IBOutlet UILabel *lblBooster;

@property (strong, nonatomic) IBOutlet ACELabel *lblSplitMfgBrand;
@property (strong, nonatomic) IBOutlet ACELabel *lblMfgBrand;

@property (strong, nonatomic) IBOutlet UITextView *txtvNotes;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvbg;

@property (strong, nonatomic) IBOutlet UIButton *btnServiceReport;
@property (strong, nonatomic) IBOutlet UIButton *btnUnitManual;

@property (strong, nonatomic) IBOutlet UIView *vwAddress;
@property (strong, nonatomic) IBOutlet UIView *vwTypeOfUnit;
@property (strong, nonatomic) IBOutlet UIView *vwPackaged;
@property (strong, nonatomic) IBOutlet UIView *vwBelowPackaged;
@property (strong, nonatomic) IBOutlet UIView *vwFilter;
@property (strong, nonatomic) IBOutlet UIView *vwFuse;
@property (strong, nonatomic) IBOutlet UIView *vwPicture;
@property (strong, nonatomic) IBOutlet UIView *vwSplit;
@property (strong, nonatomic) IBOutlet UIView *vwSplitUnitDetail;
@property (strong, nonatomic) IBOutlet UIView *vwBelowSplitUDetail;
@property (strong, nonatomic) IBOutlet UIView *vwSplitFilter;
@property (strong, nonatomic) IBOutlet UIView *vwSplitFuse;
@property (strong, nonatomic) IBOutlet UIView *vwSplitPicture;
@property (strong, nonatomic) IBOutlet UIView *vwCommon;
@property (strong, nonatomic) IBOutlet UIView *vwNotes;
@property (strong, nonatomic) IBOutlet UIView *vwUnitManual;
@property (strong, nonatomic) IBOutlet UIView *vwServiceHistory;
@property (strong, nonatomic) IBOutlet UIView *vwPackagedManual;

@property (strong, nonatomic) IBOutlet UITableView *tblvPackagedManual;
@property (strong, nonatomic) IBOutlet UITableView *tblvPackaged; //PackagedCell tag 1
@property (strong, nonatomic) IBOutlet UITableView *tblvFilter; //FilterCell tag 2
@property (strong, nonatomic) IBOutlet UITableView *tblvFuse; //FuseCell tag 3

@property (strong, nonatomic) IBOutlet UICollectionView *CollvPictures; //PictureCell

@property (strong, nonatomic) IBOutlet UITableView *tblvSplit; //SplitCell tag 4
@property (strong, nonatomic) IBOutlet UITableView *tblvSplitFilter; //SplitFilterCell tag 5
@property (strong, nonatomic) IBOutlet UITableView *tblvSplitFuse; //SplitFuseCell tag 6
@property (strong, nonatomic) IBOutlet UICollectionView *collvSplitPictures; //SplitPictureCell

@property (strong, nonatomic) IBOutlet UITableView *tblvUnitManual; //UnitManualCell tag 7
@property (strong, nonatomic) IBOutlet UITableView *tblvServiceHistory; //ServiceHistoryCell tag 8

@property (strong, nonatomic) ACEACUnit *unitInfo;

@property NSArray *arrLableText;
@property NSArray *arrKey;
//@property NSArray *arrLblData;

@end

@implementation UnitDetailViewableViewController

@synthesize scrlvbg,vwAddress,vwTypeOfUnit,vwPackaged,vwBelowPackaged,vwFilter,vwFuse,vwPicture,vwSplit,vwSplitUnitDetail,vwBelowSplitUDetail,vwSplitFilter,vwSplitFuse,vwSplitPicture,vwCommon,vwNotes,vwUnitManual,vwServiceHistory,vwPackagedManual;

@synthesize tblvFuse,tblvSplit,tblvFilter,tblvPackaged,tblvSplitFuse,tblvUnitManual,tblvSplitFilter,tblvServiceHistory,tblvPackagedManual;

@synthesize lblUnitName,lblplan,lblAddress,lblUnitTon,lblManfDate,lblUnitType,lblClientName,lblQntyFilter,lblModelNumber,lblSerialNumber,lblMfgBrand,lblSplitBooster,lblSplitUnitTon,lblSplitManfDate,lblSplitQntyFuse,lblSplitQntyFilter,lblSplitModelNumber,lblSplitSerialNumber,lblSplitMfgBrand,lblQntyFuse,lblBooster,lblPackagedTitle,lblsplitTitle,lblunitTonTitleUp,lblUnitTonTitleDown;

@synthesize collvSplitPictures,CollvPictures,unitId,btnServiceReport,btnUnitManual,unitInfo,arrLableText,arrKey,txtvNotes;//,arrLblData;

#pragma mark - ACEViewControllerMethod
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    [self getUnitData:unitId];
    [scrlvbg setContentSize:CGSizeMake(scrlvbg.width, vwCommon.y+vwCommon.height)];
}

#pragma mark - Helper Method
-(void)prepareArray
{
 
    arrKey  = @[ACKeyEleService,ACKeyMaxBreaker,ACKeyBreaker,ACKeyRefrigerantType,ACKeyCompressor,ACKeyCapacitor,ACKeyContractor,ACKeyFilterDryer,ACKeyDfrostBoard,ACKeyRelay,ACKeyTXVvalve,ACKeyReversingValve,ACKeyBlowerMotor,ACKeyCondensingMotor,ACKeyInducerMotor,ACKeyTransformer,ACKeyControlBoard,ACKeyLimitSwitch,ACKeyIgnitor,ACKeyGasvalve,ACKeyPressureSwitch,ACKeyFlameSensor,ACKeyRollSensor,ACKeyDoorSwitch,ACKeyIgnitionCntrlBoard,ACKeyCoilCleaner,ACKeyMisc];
    
    arrLableText  = @[@"Electrical Service",@"Max Breaker",@"Breaker",@"Refrigerant Type",@"Compressor",@"Capacitor",@"Contactor",@"Filter Dryer",@"Defrost Board",@"Relay",@"TXV Valve",@"Reversing Valve",@"Blower Motor",@"Condensing fan motor",@"Inducer draft motor OR flu vent motor",@"Tranformer",@"Control Board",@"Limit Switch",@"Ignitor",@"Gas Valve",@"Pressure Switch",@"Flame Sensor",@"Rollout Sensor",@"Door Switch",@"Ignition Control Board",@"Coil",@"Misc"];
    
}
-(void)prepareView
{
    tblvServiceHistory.separatorColor = [UIColor clearColor];
    tblvUnitManual.separatorColor     = [UIColor clearColor];
    
    vwAddress.backgroundColor                   = [UIColor whiteColor];
    vwTypeOfUnit.backgroundColor                = [UIColor whiteColor];
    vwPackaged.backgroundColor                  = [UIColor whiteColor];
    vwBelowPackaged.backgroundColor             = [UIColor whiteColor];
    vwFilter.backgroundColor                    = [UIColor whiteColor];
    vwFuse.backgroundColor                      = [UIColor whiteColor];
    vwPicture.backgroundColor                   = [UIColor whiteColor];
    vwPackagedManual.backgroundColor            = [UIColor whiteColor];
    vwSplit.backgroundColor                     = [UIColor whiteColor];
    vwSplitUnitDetail.backgroundColor           = [UIColor whiteColor];
    vwBelowSplitUDetail.backgroundColor         = [UIColor whiteColor];
    vwSplitFilter.backgroundColor               = [UIColor whiteColor];
    vwSplitFuse.backgroundColor                 = [UIColor whiteColor];
    vwSplitPicture.backgroundColor              = [UIColor whiteColor];
    vwCommon.backgroundColor                    = [UIColor whiteColor];
    vwNotes.backgroundColor                     = [UIColor whiteColor];
    vwServiceHistory.backgroundColor            = [UIColor whiteColor];
    vwUnitManual.backgroundColor                = [UIColor whiteColor];
    
    vwUnitManual.layer.borderWidth              = 1.0f;
    vwUnitManual.layer.borderColor              = [[UIColor separatorColor]CGColor];
    
    vwPackagedManual.layer.borderWidth          = 1.0f;
    vwPackagedManual.layer.borderColor          = [[UIColor separatorColor]CGColor];
    
    btnServiceReport.layer.borderWidth          = 1.0f;
    btnServiceReport.layer.borderColor          = [[UIColor separatorColor]CGColor];
}
-(void)getUnitData:(NSString *)unitID
{
    if([ACEUtil reachable])
    {
        [self getUnitFullDetail:unitID];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)reloadTableall:(BOOL)ans
{
    [tblvPackaged       reloadData];
    [tblvFilter         reloadData];
    [tblvFuse           reloadData];
    [tblvPackagedManual reloadData];
    [tblvServiceHistory reloadData];
    [CollvPictures      reloadData];
    if(ans)
    {
        [tblvSplit           reloadData];
        [tblvSplitFilter     reloadData];
        [tblvSplitFuse       reloadData];
        [tblvUnitManual      reloadData];
        [collvSplitPictures  reloadData];
    }
   
}
-(void)setLabelData:(BOOL)isSplit
{
    @try
    {
        ACEACPartInfo *info = unitInfo.arrPartsInfo[0]  ;
        if(unitInfo.arrPasrts.count > 1)
        {
            lblUnitType.text        = @"Split"          ;
        }
        else
        {
             lblUnitType.text        = info.typeofunit  ;
        }
        lblPackagedTitle.text   = [NSString stringWithFormat:@"Detail of %@ unit",info.typeofunit];
        if([info.typeofunit isEqualToString:GUnitTypeHeating])
        {
            lblunitTonTitleUp.text = @"BTU & % of Heat Loss";
        }
        else
        {
            lblunitTonTitleUp.text = @"Unit Size";
        }
        lblManfDate.text        = [info.manuDate isEqualToString:@""]?@"NA":info.manuDate;
        if(info.isUnitOld)
        {
            lblManfDate.textColor = [UIColor redColor];
        }
        lblUnitTon.text         = [info.unitTon isEqualToString:@""]?@"NA":info.unitTon         ;
        lblModelNumber.text     = [info.modelNumber isEqualToString:@""]?@"NA":info.modelNumber;
        lblSerialNumber.text    = [info.serialNumber isEqualToString:@""]?@"NA":info.serialNumber ;
        lblMfgBrand.text        = [info.manuBrand isEqualToString:@""]?@"NA":info.manuBrand;
        
        lblQntyFilter.text      = [NSString stringWithFormat:@"%d",info.filterQnty];
        lblQntyFuse.text        = [NSString stringWithFormat:@"%d",info.fuseQnty];
        lblBooster.text         = [info.booster isEqualToString:@""]?@"NA":info.booster;
        
        if(isSplit)
        {
            ACEACPartInfo *info = unitInfo.arrPartsInfo[1];
            
            lblSplitManfDate.text        = [info.manuDate isEqualToString:@""]?@"NA":info.manuDate;
            if(info.isUnitOld)
            {
                lblSplitManfDate.textColor = [UIColor redColor];
            }

            lblSplitUnitTon.text         = [info.unitTon isEqualToString:@""]?@"NA":info.unitTon         ;
            
            lblSplitModelNumber.text     = [info.modelNumber isEqualToString:@""]?@"NA":info.modelNumber;
            
            lblSplitSerialNumber.text    =  [info.serialNumber isEqualToString:@""]?@"NA":info.serialNumber ;
            
            lblSplitMfgBrand.text    =  [info.manuBrand isEqualToString:@""]?@"NA":info.manuBrand ;
            
            lblsplitTitle.text           = [NSString stringWithFormat:@"Detail of %@ unit",info.typeofunit];
            lblSplitQntyFilter.text      = [NSString stringWithFormat:@"%d",info.filterQnty];
            lblSplitQntyFuse.text        = [NSString stringWithFormat:@"%d",info.fuseQnty];
            lblSplitBooster.text         = [info.booster isEqualToString:@""]?@"NA":info.booster;
            if([info.typeofunit isEqualToString:GUnitTypeHeating])
            {
                lblUnitTonTitleDown.text = @"BTU & % of Heat Loss";
            }
            else
            {
                lblUnitTonTitleDown.text = @"Unit Size";
            }
        }
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}
-(void)prepareViewforUnit
{
    //set label text
    
    lblClientName.text  = unitInfo.clientName;
    lblAddress.text     = unitInfo.address   ;
    lblUnitName.text    = unitInfo.unitName  ;
    lblplan.text        = unitInfo.plan      ;
    txtvNotes.text      = unitInfo.notes ;
    
    if(unitInfo.arrPartsInfo.count > 1)
    {
        [self reloadTableall:YES];
        [self prepareViewForSingleUnit:YES];
    }
    else if(unitInfo.arrPartsInfo.count == 1)
    {
        [self reloadTableall:NO];
        [self prepareViewForSingleUnit:NO];
    }
    else
    {
        [self reloadTableall:NO];
        [self prepareViewForSingleUnit:NO];
    }
}
-(void)prepareViewForSingleUnit:(BOOL)ans
{
    vwSplit.hidden = YES;
    
    tblvPackaged.height         = tblvPackaged.contentSize.height;
    tblvFilter.height           = tblvFilter.contentSize.height;
    tblvFuse.height             = tblvFuse.contentSize.height;
    
    if ([[unitInfo.arrPartsInfo[0] arrManuals]count] > 0)
    {
        tblvPackagedManual.height       = tblvPackagedManual.contentSize.height;
    }
    else
    {
        tblvPackagedManual.height         = 50;
        tblvPackagedManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPackagedManual.height];
    }
    if (unitInfo.serviceReports.count > 0)
    {
        tblvServiceHistory.height   = tblvServiceHistory.contentSize.height;
    }
    else
    {
        tblvServiceHistory.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoServiceReports andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvServiceHistory.height];
    }
    if(unitInfo.arrPartsInfo.count > 0)
    {
        if(!([unitInfo.arrPartsInfo[0] arrPictures].count > 0))
        {
            CollvPictures.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitPictures andImage:nil withFontColor:[UIColor appGreenColor] withHeight:CollvPictures.height];
        }
    }
    vwPackaged.height           = tblvPackaged.y + tblvPackaged.height;
    
    vwFilter.height             = tblvFilter.y + tblvFilter.height;
    
    vwFuse.frame               = CGRectMake(vwFuse.x, vwFilter.y + vwFilter.height, vwFuse.width, tblvFuse.y + tblvFuse.contentSize.height);
    
    vwPicture.y                = vwFuse.y + vwFuse.height;
    vwPackagedManual.y         = vwPicture.y + vwPicture.height;
    
    vwPackagedManual.height   = tblvPackagedManual.y + tblvPackagedManual.height;
    
    vwBelowPackaged.frame      = CGRectMake(vwBelowPackaged.x, vwPackaged.y + vwPackaged.height, vwBelowPackaged.width, vwPackagedManual.y + vwPackagedManual.height);
    
    
    if(ans)
    {
        vwSplit.hidden = NO;
        
        tblvSplit.height        = tblvSplit.contentSize.height         ;
        tblvSplitFilter.height  = tblvSplitFilter.contentSize.height   ;
        tblvSplitFuse.height    = tblvSplitFuse.contentSize.height     ;
        
        if ([[unitInfo.arrPartsInfo[1] arrManuals]count] > 0)
        {
            tblvUnitManual.height       = tblvUnitManual.contentSize.height;
        }
        else
        {
            tblvUnitManual.height         = 50;
            tblvUnitManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnitManual.height];
        }
        
        vwSplitUnitDetail.height = tblvSplit.y + tblvSplit.height;
        
        vwSplitFilter.height     = tblvSplitFilter.y + tblvSplitFilter.height;
        
        vwSplitFuse.frame        = CGRectMake(vwSplitFuse.x, vwSplitFilter.y + vwSplitFilter.height, vwSplitFuse.width, tblvSplitFuse.y + tblvSplitFuse.height);
        
        vwSplitPicture.y          = vwSplitFuse.y + vwSplitFuse.height;
        
        vwUnitManual.height       = tblvUnitManual.y + tblvUnitManual.height;
        
        vwUnitManual.y            = vwSplitPicture.y + vwSplitPicture.height;
        
        vwBelowSplitUDetail.frame = CGRectMake(vwBelowSplitUDetail.x, vwSplitUnitDetail.y + vwSplitUnitDetail.height, vwBelowSplitUDetail.width, vwUnitManual.y+ vwUnitManual.height);
        
        vwSplit.frame            = CGRectMake(vwSplit.x, vwBelowPackaged.y + vwBelowPackaged.height, vwSplit.width, vwBelowSplitUDetail.y + vwBelowSplitUDetail.height);
        
        if(unitInfo.arrPartsInfo.count > 1)
        {
            if(!([unitInfo.arrPartsInfo[1] arrPictures].count > 0))
            {
                collvSplitPictures.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitPictures andImage:nil withFontColor:[UIColor appGreenColor] withHeight:collvSplitPictures.height];
            }
        }
        
    }
    
    vwServiceHistory.height    = tblvServiceHistory.y + tblvServiceHistory.height;
    
  //  vwUnitManual.frame         = CGRectMake(vwUnitManual.x, vwServiceHistory.y + vwServiceHistory.height, vwUnitManual.width, tblvUnitManual.y + tblvUnitManual.height);
    
     vwCommon.height             = vwUnitManual.y + vwUnitManual.height;
    
    if(ans)
    {
        vwCommon.frame          = CGRectMake(vwCommon.x, vwSplit.y + vwSplit.height, vwCommon.width, vwServiceHistory.y + vwServiceHistory.height);
    }
    else
    {
       
        vwCommon.frame          = CGRectMake(vwCommon.x, vwBelowPackaged.y + vwBelowPackaged.height, vwCommon.width, vwServiceHistory.y + vwServiceHistory.height);
    }
    
    [self setLabelData:ans];
    scrlvbg.contentSize = CGSizeMake(scrlvbg.width, vwCommon.y+vwCommon.height);
    
}

#pragma mark - Webservice Method
-(void)getUnitFullDetail:(NSString *)unitID
{
    [SVProgressHUD show];
    
    NSDictionary *dict =  @{
                                ACKeyID : unitId,
                                UKeyEmployeeID : ACEGlobalObject.user.userID
                            };
    [ACEWebServiceAPI getUnitDetail:dict completionHandler:^(ACEAPIResponse *response, ACEACUnit *acDetail)
    {
        if(response.code == RCodeSuccess)
        {
            unitInfo = acDetail;
            [self prepareArray];
            [self prepareViewforUnit];
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
        else
        {
            [SVProgressHUD dismiss];
            if(response.message)
            {
                [self showAlertWithMessage:response.message];
            }
            else
            {
               // [self showAlertWithMessage:response.error.localizedDescription];
                [self showAlertWithMessage:ACEUnknownError];
            }
        }
        
    }];
    
}

#pragma mark - Event Method
- (IBAction)btnCloseTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableview Delegate & Datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try
    {
    if(tableView.tag == 1) //tblvPackaged
    {
        return arrLableText.count;
    }
    else if (tableView.tag == 2) //tblvFilter
    {
        if(unitInfo.arrPartsInfo.count > 0)
            return [unitInfo.arrPartsInfo[0] filterQnty];
        else
            return 0;
    }
    else if (tableView.tag == 3) //tblvFuse
    {
        if(unitInfo.arrPartsInfo.count > 0)
            return [unitInfo.arrPartsInfo[0] fuseQnty];
        else
            return 0;
    }
    else if (tableView.tag == 4) //tblvSplit
    {
        return arrLableText.count;
    }
    else if (tableView.tag == 5) //tblvsplitfilter
    {
        return [unitInfo.arrPartsInfo[1] filterQnty];
    }
    else if (tableView.tag == 6) //tblvsplitfuse
    {
        return [unitInfo.arrPartsInfo[1] fuseQnty];
    }
    else if (tableView.tag == 7) //split manual
    {
        if(unitInfo.arrPartsInfo.count > 1)
            return [[unitInfo.arrPartsInfo[1] arrManuals]count];
        else
            return 0;
    }
    else if (tableView.tag == 8) //tblvServiceHistory
    {
        return unitInfo.serviceReports.count;
    }
    else if (tableView.tag == 10) // packaged manual
    {
        if(unitInfo.arrPartsInfo.count > 0)
            return [[unitInfo.arrPartsInfo[0] arrManuals]count];
        else
            return 0;
    }
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }

    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     ACEUnitViewableCell *cell;
    @try
    {
    
    if(tableView.tag == 1) //tblvPackaged
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PackagedCell"];
        
        cell.lblTitle.text      = arrLableText[indexPath.row];
        if(unitInfo.arrPartsInfo.count>0)
        {
            NSDictionary *dict      = unitInfo.arrPasrts[0];
            NSString *strPart       = dict[arrKey[indexPath.row]];
            cell.lblSubTitle.text   = [strPart isEqualToString:@""]?@"NA":strPart;
        }
        
    }
    else if (tableView.tag == 2) //tblvFilter
    {
        NSArray *arr = [unitInfo.arrPartsInfo[0] arrFilter];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
        
        cell.lblTitle.text  = arr[indexPath.row][ACKeyFilterSize];
        
        cell.lblTextTitle.text    = [NSString stringWithFormat:@"Filter Size %ld",(long)indexPath.item + 1];
        cell.lblTextSubTitle.text = [NSString stringWithFormat:@"Filter Location %ld",(long)indexPath.item+1];
        
        if([arr[indexPath.row][ACKeyLocOfFilter]boolValue])
        {
            cell.lblSubTitle.text = ACKeyInsideEquipment;
        }
        else
        {
            cell.lblSubTitle.text = ACKeyInsideSpace;
        }
        
    }
    else if (tableView.tag == 3) //tblvFuse
    {
        NSArray *arr = [unitInfo.arrPartsInfo[0] arrFuse];
         cell = [tableView dequeueReusableCellWithIdentifier:@"FuseCell"];
         cell.lblTitle.text  = arr[indexPath.row][ACKeyFuseType];
        cell.lblTextTitle.text = [NSString stringWithFormat:@"Fuse Type %ld",(long)indexPath.item+1];
    }
    else if (tableView.tag == 4) //tblvSplit
    {
         cell = [tableView dequeueReusableCellWithIdentifier:@"SplitCell"];
        
        NSDictionary *dict      = unitInfo.arrPasrts[1];
        
        cell.lblTitle.text      = arrLableText[indexPath.row];
        NSString *strPart       =  dict[arrKey[indexPath.row]];
        cell.lblSubTitle.text   = [strPart isEqualToString:@""]?@"NA":strPart;
    }
    else if (tableView.tag == 5) //tblvSplitFilter
    {
        NSArray *arr = [unitInfo.arrPartsInfo[1] arrFilter];
     
         cell = [tableView dequeueReusableCellWithIdentifier:@"SplitFilterCell"];
        
        cell.lblTitle.text  = arr[indexPath.row][ACKeyFilterSize];
        
        cell.lblTextTitle.text    = [NSString stringWithFormat:@"Filter Size %ld",(long)indexPath.item + 1];
        cell.lblTextSubTitle.text = [NSString stringWithFormat:@"Filter Location %ld",(long)indexPath.item+1];
        
        if(arr[indexPath.row][ACKeyLocOfFilter])
        {
            cell.lblSubTitle.text = ACKeyInsideEquipment;
        }
        else
        {
            cell.lblSubTitle.text = ACKeyInsideSpace;
        }

    }
    else if (tableView.tag == 6) //tblvSplitFuse
    {
         NSArray *arr = [unitInfo.arrPartsInfo[1] arrFuse];
        
         cell = [tableView dequeueReusableCellWithIdentifier:@"SplitFuseCell"];
        
        cell.lblTitle.text  = arr[indexPath.row][ACKeyFuseType];
        cell.lblTextTitle.text = [NSString stringWithFormat:@"Fuse Type %ld",(long)indexPath.item+1];
    }
    else if (tableView.tag == 7) // split unit manual
    {
       // NSArray *arr= [unitInfo.arrPartsInfo[1] arrManuals];
        
       // NSDictionary *dict = arr[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"UnitManualCell"];
        //cell.lblTitle.text  = dict[ACKeyManualName];
        
        cell.lblTitle.text          = [NSString stringWithFormat:@"Manual %ld",(long)indexPath.row + 1];
    }
    else if (tableView.tag == 8) //service report
    {
        NSDictionary *dict = unitInfo.serviceReports[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceHistoryCell"];
        
        cell.lblTitle.text = dict[ACKeyReportNumber];
    }
    else if (tableView.tag == 10) //Packaged unit manual
    {
        //NSArray *arr= [unitInfo.arrPartsInfo[0] arrManuals];
        
        //NSDictionary *dict = arr[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"UnitManualCell"];
        
       // cell.lblTitle.text  = dict[ACKeyManualName];
        cell.lblTitle.text  = [NSString stringWithFormat:@"Manual %ld",(long)indexPath.row + 1];
    }
    
        
    }
    @catch (NSException *exception)
    {
        
    } @finally
    {
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr;
   
    if (tableView.tag == 7) //split unit manual
    {
        arr     = [unitInfo.arrPartsInfo[1] arrManuals];
    }
    else if (tableView.tag == 10) // packaged unit manual
    {
        arr     = [unitInfo.arrPartsInfo[0] arrManuals];
    }
    
    NSDictionary *dict = arr[indexPath.row];
    NSURL *url         = [NSURL URLWithString:dict[ACKeyManualUrl]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication]openURL:url];
    }
    else
    {
        [self showAlertWithMessage:ACECanNotOpenUrl];
    }

}
#pragma mark - UICollectionView Delegate & Datasource Method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == 1)
    {
        if(unitInfo.arrPartsInfo.count > 0)
            return [unitInfo.arrPartsInfo[0] arrPictures].count;
        else
            return 0;
    }
    else if(collectionView.tag == 2)
    {
         if(unitInfo.arrPartsInfo.count > 1)
             return [unitInfo.arrPartsInfo[1] arrPictures].count;
         else
             return 0;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACEServiceImageCell *cell;
    
    if(collectionView.tag == 1)
    {
        
       // NSDictionary *dict = unitInfo.pictures[indexPath.row];
        NSDictionary *dict = [unitInfo.arrPartsInfo[0] arrPictures][indexPath.row];
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
        
        NSURL *url = [NSURL URLWithString:dict[ACKeyPictureUrl]];
        
        [cell.imgvAcUnit setImageWithURL:url];
       // cell.imgvAcUnit setImagewi
        //cell.imgvAcUnit.image =
    }
    else if (collectionView.tag == 2)
    {
        NSDictionary *dict = [unitInfo.arrPartsInfo[1] arrPictures][indexPath.row];

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SplitPictureCell" forIndexPath:indexPath];
        
        NSURL *url = [NSURL URLWithString:dict[ACKeyPictureUrl]];
        
        [cell.imgvAcUnit setImageWithURL:url];
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ACEServiceImage *image;
   // NSArray         *arrimage;
    
    if(collectionView.tag == 1)
    {
        // NSDictionary *dict = unitInfo.pictures[indexPath.row];
        NSDictionary *dict = [unitInfo.arrPartsInfo[0] arrPictures][indexPath.row];
        
        image = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
        
        // cell.imgvAcUnit setImagewi
        //cell.imgvAcUnit.image =
    }
    else if (collectionView.tag == 2)
    {
        NSDictionary *dict = [unitInfo.arrPartsInfo[1] arrPictures][indexPath.row];
    
        image = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
    }

    OpenImageViewcontroller *vc = [ACEGlobalObject.storyboardLogin instantiateViewControllerWithIdentifier:@"OpenImageViewcontroller"];
    
    //vc.index     = indexPath.row;
    vc.unitImage = image;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:vc animated:NO completion:nil];

}
@end
