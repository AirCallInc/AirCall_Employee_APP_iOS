 //
//  AddUnitACHeatingViewController.m
//  AircallEmployee
//
//  Created by Manali on 30/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddUnitACHeatingViewController.h"

@interface AddUnitACHeatingViewController ()<UITextFieldDelegate,SearchPart,ZWTTextboxToolbarHandlerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel  *lblHeading;
@property (weak, nonatomic) IBOutlet UILabel  *lblUnitType;
@property (weak, nonatomic) IBOutlet UILabel  *lblUnitTonHeating;

// Heating
@property (weak, nonatomic) IBOutlet UITextField *txtMfBrand;
@property (weak, nonatomic) IBOutlet UITextField *txtTon;
@property (weak, nonatomic) IBOutlet UITextField *txtRefType;
@property (weak, nonatomic) IBOutlet UITextField *txtEleService;
@property (weak, nonatomic) IBOutlet UITextField *txtBreaker;
@property (weak, nonatomic) IBOutlet UITextField *txtMaxBreaker;
@property (weak, nonatomic) IBOutlet UITextField *txtCompressor;
@property (weak, nonatomic) IBOutlet UITextField *txtCapacitor;
@property (weak, nonatomic) IBOutlet UITextField *txtContractor;
@property (weak, nonatomic) IBOutlet UITextField *txtFilterDryer;
@property (weak, nonatomic) IBOutlet UITextField *txtDefrostBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtRelay;
@property (weak, nonatomic) IBOutlet UITextField *txtTXVValve;
@property (weak, nonatomic) IBOutlet UITextField *txtReversingValve;
@property (weak, nonatomic) IBOutlet UITextField *txtBlowerMotor;
@property (weak, nonatomic) IBOutlet UITextField *txtCondensingMotor;
@property (weak, nonatomic) IBOutlet UITextField *txtInducerDraft;
@property (weak, nonatomic) IBOutlet UITextField *txtTransformer;
@property (weak, nonatomic) IBOutlet UITextField *txtControlBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtLimitSwitch;
@property (weak, nonatomic) IBOutlet UITextField *txtIgnitor;
@property (weak, nonatomic) IBOutlet UITextField *txtGasValve;
@property (weak, nonatomic) IBOutlet UITextField *txtPressureSwitch;
@property (weak, nonatomic) IBOutlet UITextField *txtFlameSensor;
@property (weak, nonatomic) IBOutlet UITextField *txtRolloutSensor;
@property (weak, nonatomic) IBOutlet UITextField *txtDoorSwitch;
@property (weak, nonatomic) IBOutlet UITextField *txtIgControlBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtCoilCleaner;
@property (weak, nonatomic) IBOutlet UITextField *txtMisc;

@property (weak, nonatomic) IBOutlet UITableView *tblvManual;
@property (weak, nonatomic) IBOutlet UIView *vwInfo;
@property (weak, nonatomic) IBOutlet UIView *vwManual;
@property (weak, nonatomic) IBOutlet UIView *vwHeating;

//Cooling

@property (weak, nonatomic) IBOutlet UITextField *txtCMfBrand;
@property (weak, nonatomic) IBOutlet UITextField *txtCTon;
@property (weak, nonatomic) IBOutlet UITextField *txtCRefType;
@property (weak, nonatomic) IBOutlet UITextField *txtCEleService;

@property (weak, nonatomic) IBOutlet UITextField *txtCMaxBreaker;
@property (weak, nonatomic) IBOutlet UITextField *txtCBreaker;

@property (weak, nonatomic) IBOutlet UITextField *txtCCompressor;
@property (weak, nonatomic) IBOutlet UITextField *txtCCapacitor;
@property (weak, nonatomic) IBOutlet UITextField *txtCContractor;
@property (weak, nonatomic) IBOutlet UITextField *txtCFilterDryer;
@property (weak, nonatomic) IBOutlet UITextField *txtCDefrostBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtCRelay;
@property (weak, nonatomic) IBOutlet UITextField *txtCTXV;
@property (weak, nonatomic) IBOutlet UITextField *txtCReversingValve;
@property (weak, nonatomic) IBOutlet UITextField *txtCBlowerMotor;
@property (weak, nonatomic) IBOutlet UITextField *txtCCondensingMotor;
@property (weak, nonatomic) IBOutlet UITextField *txtCDraftMotor;
@property (weak, nonatomic) IBOutlet UITextField *txtCTransformer;
@property (weak, nonatomic) IBOutlet UITextField *txtCControlBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtCLimitSwitch;
@property (weak, nonatomic) IBOutlet UITextField *txtCIgnitor;
@property (weak, nonatomic) IBOutlet UITextField *txtCGasValve;
@property (weak, nonatomic) IBOutlet UITextField *txtCPressureSwitch;
@property (weak, nonatomic) IBOutlet UITextField *txtCFlameSensor;
@property (weak, nonatomic) IBOutlet UITextField *txtCRolloutSensor;
@property (weak, nonatomic) IBOutlet UITextField *txtCDoorSwitch;
@property (weak, nonatomic) IBOutlet UITextField *txtCIgControlBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtCCoilCleaner;
@property (weak, nonatomic) IBOutlet UITextField *txtCMisc;

@property (weak, nonatomic) IBOutlet UITableView *tblvCManual;
@property (weak, nonatomic) IBOutlet UIView      *vwCooling;
@property (weak, nonatomic) IBOutlet UIView      *vwCoolingInfo;
@property (weak, nonatomic) IBOutlet UIView      *vwCoolingManual;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;
@property (weak, nonatomic) IBOutlet UIButton     *btnNext;

@property NSMutableArray * arrManuals;
@property NSMutableArray * arrCoolingManuals;
@property NSMutableArray * arrTextboxes;
@property NSInteger        selectedTxtTag;
@property ACEACUnit      * unitDetail ;
@property ZWTTextboxToolbarHandler *handler;
@property BOOL isHeatingMatched;

@end

@implementation AddUnitACHeatingViewController

@synthesize txtMfBrand,txtTon,txtRefType,txtEleService,txtMaxBreaker,txtBreaker,txtCompressor,txtCapacitor,txtContractor,txtFilterDryer,txtDefrostBoard,txtRelay,txtTXVValve,txtReversingValve,txtBlowerMotor,txtCondensingMotor,txtInducerDraft,txtTransformer,txtControlBoard,txtLimitSwitch,txtIgnitor,txtGasValve,txtPressureSwitch,txtFlameSensor,txtRolloutSensor,txtDoorSwitch,txtIgControlBoard,txtCoilCleaner,txtMisc,vwHeating;

@synthesize vwCooling,vwCoolingInfo,txtCMfBrand,txtCTon,txtCRefType,txtCEleService,txtCMaxBreaker,txtCBreaker,txtCCompressor,txtCCapacitor,txtCContractor,txtCFilterDryer,txtCDefrostBoard,txtCRelay,txtCTXV,txtCReversingValve,txtCBlowerMotor,txtCCondensingMotor,txtCDraftMotor,txtCTransformer,txtCControlBoard,txtCLimitSwitch,txtCIgnitor,txtCGasValve,txtCPressureSwitch,txtCFlameSensor,txtCRolloutSensor,txtCDoorSwitch,txtCIgControlBoard,txtCCoilCleaner,txtCMisc,vwCoolingManual,tblvCManual;

@synthesize btnNext,lblUnitTonHeating,vwInfo,vwManual,scrlv,arrManuals,tblvManual,arrTextboxes;

@synthesize isMatched,selectedTxtTag,unitType,arrCoolingManuals,headingTitle,handler,unitId,unitDetail,shouldCallWebservice,arrUnitInfo,lblUnitType,arrModelSerial,dictClientInfo,isHeatingMatched;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    tblvManual.separatorColor = [UIColor clearColor];
    _lblHeading.text = headingTitle;
    
    if (![unitType isEqualToString:GUnitTypeSplit])
    {
        lblUnitType.text = unitType;
    }
    if([unitType isEqualToString:GUnitTypeHeating] || [unitType isEqualToString:GUnitTypeSplit])
    {
        lblUnitTonHeating.text = @"BTU & % of Heat Loss";
    }
    
    tblvCManual.delegate = self;
    tblvCManual.dataSource =  self;
    
    if(shouldCallWebservice)
    {
        [self callWebserviceOfUnitDetail];
    }
    else
    {
        if(arrUnitInfo)
        {
            [self prepareUnitData:arrUnitInfo];
        }
        
        [self setFramesOfView];
    }
}
-(void)prepareUnitData:(NSMutableArray*)arrPart
{
    if([unitType isEqualToString:GUnitTypeSplit])
    {
        if(arrPart.count > 0)
        {
            ACEACPartInfo *part = arrPart[0];
            
            if([part.typeofunit isEqualToString:GUnitTypeHeating])
            {
                arrManuals = [[NSMutableArray alloc]initWithArray:part.arrManuals];
                
                if (arrManuals.count == 0)
                {
                    tblvManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvManual.height];
                }
                
                isHeatingMatched = true;
                [tblvManual reloadData];
                [self setUnitData:part];
                
            }
            else if ([part.typeofunit isEqualToString:GUnitTypeCooling])
            {
                arrCoolingManuals = [[NSMutableArray alloc]initWithArray:part.arrManuals];
                
                if (arrCoolingManuals.count == 0)
                {
                    tblvCManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvCManual.height];
                }
                
                isHeatingMatched = false;
                [tblvCManual reloadData];
                [self setSplitUnitData:part];
            }
        }
        if(arrPart.count > 1)
        {
            ACEACPartInfo *part = arrPart[1];
            
            if([part.typeofunit isEqualToString:GUnitTypeHeating])
            {
                arrManuals = [[NSMutableArray alloc]initWithArray:part.arrManuals];
                if (arrManuals.count == 0)
                {
                    tblvManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvManual.height];
                }
                [tblvManual reloadData];
                [self setUnitData:part];
            }
            else if ([part.typeofunit isEqualToString:GUnitTypeCooling])
            {
                arrCoolingManuals = [[NSMutableArray alloc]initWithArray:part.arrManuals];
                
                if (arrCoolingManuals.count == 0)
                {
                    tblvCManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvCManual.height];
                }
                [tblvCManual reloadData];
                [self setSplitUnitData:part];
            }
        }
    }
    else
    {
        if(arrPart.count > 0)
        {
            ACEACPartInfo *part = arrPart[0];
            arrManuals = [[NSMutableArray alloc]initWithArray:part.arrManuals];
            
            if (arrManuals.count == 0)
            {
                tblvManual.backgroundView = [ACEUtil viewNoDataWithMessage:ACENoUnitManuals andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvManual.height];
            }
            
            [tblvManual reloadData];
            
            //[self setFramesOfView];
            
            [self setUnitData:part];
        }
    }
    
}
-(void)setFramesOfView
{
    if ([unitType isEqualToString:GUnitTypeSplit])
    {
        [self setSplitView];
    }
//    else if([unitType isEqualToString:GUnitTypeSplit] && isMatched == 2)
//    {
//        [self setPartialView];
//    }
    else
    {
        [self setNormalView];
    }
    handler  = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextboxes andScroll:scrlv];
    handler.delegate = self;
}
-(void)setSplitView
{
    vwCooling.hidden = NO;
    
    if (isMatched == 1) // Fully matched
    {
        vwManual.hidden        = NO;
        vwCoolingManual.hidden = NO;
        
        //[self disableAllTextViews];
        
        //tblvManual.height =  tblvManual.contentSize.height;
        if (arrManuals.count > 0)
        {
            tblvManual.height = tblvManual.contentSize.height;
            vwManual.height   =  tblvManual.y + tblvManual.contentSize.height ;
        }
        else
        {
            vwManual.height   =  tblvManual.y + tblvManual.height ;
        }
        
        vwHeating.height  =  vwManual.height + vwInfo.height;
        
        
        if (arrCoolingManuals.count > 0)
        {
            tblvCManual.height       = tblvCManual.contentSize.height;
            vwCoolingManual.height   =  tblvCManual.y + tblvCManual.contentSize.height ;
        }
        else
        {
            vwCoolingManual.height   =  tblvCManual.y + tblvCManual.height ;
        }
        
        vwCoolingInfo.y     =  0;
        vwCoolingManual.y   =  CGRectGetMaxY(vwCoolingInfo.frame);
        
        vwCooling.frame = CGRectMake(vwCooling.x, CGRectGetMaxY(vwHeating.frame), vwCooling.width, vwCoolingInfo.height + vwCoolingManual.height);
        
        arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtMfBrand,txtTon,txtCMfBrand,txtCTon, nil];
        
    }
    else if (isMatched == 2) // partially matched
    {
        if(arrUnitInfo.count > 0)
        {
            ACEACPartInfo *part = arrUnitInfo[0];
            
            if([part.typeofunit isEqualToString:GUnitTypeCooling])
            {
                vwManual.hidden        = YES;
                vwCoolingManual.hidden = NO;
                //[self disableCoolingTextViews];
                
                //arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtMfBrand,txtTon, nil];
                
                vwHeating.height       = vwInfo.y + vwInfo.height;
                vwCoolingInfo.y        =  0;
                
                if (arrCoolingManuals.count > 0)
                {
                     tblvCManual.height      = tblvCManual.contentSize.height;
                    vwCoolingManual.height   =  tblvCManual.y + tblvCManual.contentSize.height ;
                }
                else
                {
                    vwCoolingManual.height   =  tblvCManual.y + tblvCManual.height ;
                }
                
                vwCoolingInfo.y     =  0;
                vwCoolingManual.y   =  CGRectGetMaxY(vwCoolingInfo.frame);
                
                vwCooling.frame = CGRectMake(vwCooling.x, CGRectGetMaxY(vwHeating.frame)+5, vwCooling.width, vwCoolingInfo.height + vwCoolingManual.height);
            }
            else if ([part.typeofunit isEqualToString:GUnitTypeHeating])
            {
                vwManual.hidden        = NO;
                vwCoolingManual.hidden = YES;
                //[self disableHeatingTextViews];
                
                //arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtCMfBrand,txtCTon, nil];
                

                if (arrManuals.count > 0)
                {
                     tblvManual.height       = tblvManual.contentSize.height;
                    vwManual.height   =  tblvManual.y + tblvManual.contentSize.height ;
                }
                else
                {
                    vwManual.height   =  tblvManual.y + tblvManual.height ;
                }
                vwHeating.height  =  vwManual.height + vwInfo.height;

                vwCoolingInfo.y   =  0;
                vwCooling.frame   =  CGRectMake(vwCooling.x, CGRectGetMaxY(vwHeating.frame)+5, vwCooling.width, vwCoolingInfo.height );
            }
            
            arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtMfBrand,txtTon,txtCMfBrand,txtCTon, nil];
        }
        
    }
    else if(isMatched == 3) // Not Matched
    {
        vwManual.hidden        = YES;
        vwCoolingManual.hidden = YES;
        vwHeating.height       = vwInfo.y + vwInfo.height;
        
        vwCoolingInfo.y   =  0;
        vwCooling.frame   =  CGRectMake(vwCooling.x, CGRectGetMaxY(vwHeating.frame)+5, vwCooling.width, vwCoolingInfo.height);
        
        arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtMfBrand,txtTon,txtCMfBrand,txtCTon, nil];
    }
    
    [scrlv setContentSize:CGSizeMake(scrlv.width,vwCooling.height + vwHeating.height )]; //+50
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];

}
-(void)setNormalView
{
    vwCooling.hidden = true;
    
    if (isMatched == 1)
    {
        vwManual.hidden = NO;
        //[self disableAllTextViews];
        
        if (arrManuals.count > 0)
        {
            tblvManual.height = tblvManual.contentSize.height;
            vwManual.height   =  tblvManual.y + tblvManual.contentSize.height ;
        }
        else
        {
            vwManual.height   =  tblvManual.y + tblvManual.height ;
        }
        
        vwHeating.height  =  vwManual.height + vwInfo.height;
        
        [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    }
    else
    {
        vwManual.hidden = YES;
        vwHeating.height = vwInfo.height ;
        
        //[scrlv setContentSize:CGSizeMake(scrlv.width,vwInfo.height )];
        [btnNext setTitle:@"Submit" forState:UIControlStateNormal];
    }
    
    arrTextboxes = [[NSMutableArray alloc]initWithObjects:txtMfBrand,txtTon, nil];
    
    [scrlv setContentSize:CGSizeMake(scrlv.width,vwHeating.height )];//+ 50

}
-(void)disableAllTextViews
{
    int totalTf;
    
    if ([unitType isEqualToString:@"Split"])
    {
        totalTf = 58; //54
    }
    else
    {
        totalTf = 29;
    }
    
    for (int i = 1; i <= totalTf ; i++)
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:i];
        tf.userInteractionEnabled = false;
    }
    
}
-(void)disableCoolingTextViews
{
    int totalTf = 58; //54
    
    for (int i = 30; i <= totalTf ; i++)
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:i];
        tf.userInteractionEnabled = false;
    }
    
}
-(void)disableHeatingTextViews
{
    int totalTf = 29;
    
    for (int i = 1; i <= totalTf ; i++)
    {
        UITextField *tf = (UITextField *)[self.view viewWithTag:i];
        tf.userInteractionEnabled = false;
    }

}
-(void)setUnitData:(ACEACPartInfo *)partInfo
{
        txtMfBrand.text         = partInfo.manuBrand            ;
        txtTon.text             = partInfo.unitTon              ;
        txtRefType.text         = partInfo.refriType            ;
        txtEleService.text      = partInfo.electricalService    ;
        txtBreaker.text         = partInfo.breaker              ;
        txtMaxBreaker.text      = partInfo.maxBreaker           ;
        txtBreaker.text         = partInfo.breaker              ;
        txtCompressor.text      = partInfo.compressor           ;
        txtCapacitor.text       = partInfo.capacitor            ;
        txtContractor.text      = partInfo.contractor           ;
        txtFilterDryer.text     = partInfo.filterdryer          ;
        txtDefrostBoard.text    = partInfo.defrostboard         ;
        txtRelay.text           = partInfo.relay                ;
        txtTXVValve.text        = partInfo.txvvalve             ;
        txtReversingValve.text  = partInfo.reversingvalve       ;
        txtBlowerMotor.text     = partInfo.blowermotor          ;
        txtCondensingMotor.text = partInfo.condansingFanMotor   ;
        txtInducerDraft.text    = partInfo.inducerDraftMotor    ;
        txtTransformer.text     = partInfo.transformer          ;
        txtControlBoard.text    = partInfo.controlboard         ;
        txtLimitSwitch.text     = partInfo.limitSwitch          ;
        txtIgnitor.text         = partInfo.ignitor              ;
        txtGasValve.text        = partInfo.gasValve             ;
        txtPressureSwitch.text  = partInfo.pressureSwitch       ;
        txtFlameSensor.text     = partInfo.flameSensor          ;
        txtRolloutSensor.text   = partInfo.rolloutsensor        ;
        txtDoorSwitch.text      = partInfo.doorswitch           ;
        txtIgControlBoard.text  = partInfo.ignitioncontrolBoard ;
        txtCoilCleaner.text     = partInfo.coilCleaner          ;
        txtMisc.text            = partInfo.misc                 ;
    
        txtEleService.placeholder      = partInfo.electricalService      ;
        txtMaxBreaker.placeholder      = partInfo.maxBreaker             ;
        txtRefType.placeholder         = partInfo.refriTypeID            ;
        txtBreaker.placeholder         = partInfo.breakerID              ;
        txtCompressor.placeholder      = partInfo.compressorID           ;
        txtCapacitor.placeholder       = partInfo.capacitorID            ;
        txtContractor.placeholder      = partInfo.contractorID           ;
        txtFilterDryer.placeholder     = partInfo.filterdryerID          ;
        txtDefrostBoard.placeholder    = partInfo.defrostboardID         ;
        txtRelay.placeholder           = partInfo.relayID                ;
        txtTXVValve.placeholder        = partInfo.txvvalveID             ;
        txtReversingValve.placeholder  = partInfo.reversingvalveID       ;
        txtBlowerMotor.placeholder     = partInfo.blowermotorID          ;
        txtCondensingMotor.placeholder = partInfo.condansingFanMotorID   ;
        txtInducerDraft.placeholder    = partInfo.inducerDraftMotorID    ;
        txtTransformer.placeholder     = partInfo.transformerID          ;
        txtControlBoard.placeholder    = partInfo.controlboardID         ;
        txtLimitSwitch.placeholder     = partInfo.limitSwitchID          ;
        txtIgnitor.placeholder         = partInfo.ignitorID              ;
        txtGasValve.placeholder        = partInfo.gasValveID             ;
        txtPressureSwitch.placeholder  = partInfo.pressureSwitchID       ;
        txtFlameSensor.placeholder     = partInfo.flameSensorID          ;
        txtRolloutSensor.placeholder   = partInfo.rolloutsensorID        ;
        txtDoorSwitch.placeholder      = partInfo.doorswitchID           ;
        txtIgControlBoard.placeholder  = partInfo.ignitioncontrolBoardID ;
        txtCoilCleaner.placeholder     = partInfo.coilCleanerID          ;
        txtMisc.placeholder            = partInfo.miscID                 ;
}
-(void)setSplitUnitData:(ACEACPartInfo *)partInfo
{
    txtCMfBrand.text         = partInfo.manuBrand           ;
    txtCTon.text             = partInfo.unitTon             ;
    txtCRefType.text         = partInfo.refriType           ;
    txtCEleService.text      = partInfo.electricalService   ;
    txtCBreaker.text         = partInfo.breaker             ;
    txtCMaxBreaker.text      = partInfo.maxBreaker          ;
    txtCCompressor.text      = partInfo.compressor          ;
    txtCCapacitor.text       = partInfo.capacitor           ;
    txtCContractor.text      = partInfo.contractor          ;
    txtCFilterDryer.text     = partInfo.filterdryer         ;
    txtCDefrostBoard.text    = partInfo.defrostboard        ;
    txtCRelay.text           = partInfo.relay               ;
    txtCTXV.text             = partInfo.txvvalve            ;
    txtCReversingValve.text  = partInfo.reversingvalve      ;
    txtCBlowerMotor.text     = partInfo.blowermotor         ;
    txtCCondensingMotor.text = partInfo.condansingFanMotor  ;
    txtCDraftMotor.text      = partInfo.inducerDraftMotor   ;
    txtCTransformer.text     = partInfo.transformer         ;
    txtCControlBoard.text    = partInfo.controlboard        ;
    txtCLimitSwitch.text     = partInfo.limitSwitch         ;
    txtCIgnitor.text         = partInfo.ignitor             ;
    txtCGasValve.text        = partInfo.gasValve            ;
    txtCPressureSwitch.text  = partInfo.pressureSwitch      ;
    txtCFlameSensor.text     = partInfo.flameSensor         ;
    txtCRolloutSensor.text   = partInfo.rolloutsensor       ;
    txtCDoorSwitch.text      = partInfo.doorswitch          ;
    txtCIgControlBoard.text  = partInfo.ignitioncontrolBoard;
    txtCCoilCleaner.text     = partInfo.coilCleaner         ;
    txtCMisc.text            = partInfo.misc                ;
    
    txtCEleService.placeholder      = partInfo.electricalService      ;
    txtCMaxBreaker.placeholder      = partInfo.maxBreaker             ;
    txtCRefType.placeholder         = partInfo.refriTypeID            ;
    txtCBreaker.placeholder         = partInfo.breakerID              ;
    txtCCompressor.placeholder      = partInfo.compressorID           ;
    txtCCapacitor.placeholder       = partInfo.capacitorID            ;
    txtCContractor.placeholder      = partInfo.contractorID           ;
    txtCFilterDryer.placeholder     = partInfo.filterdryerID          ;
    txtCDefrostBoard.placeholder    = partInfo.defrostboardID         ;
    txtCRelay.placeholder           = partInfo.relayID                ;
    txtCTXV.placeholder             = partInfo.txvvalveID             ;
    txtCReversingValve.placeholder  = partInfo.reversingvalveID       ;
    txtCBlowerMotor.placeholder     = partInfo.blowermotorID          ;
    txtCCondensingMotor.placeholder = partInfo.condansingFanMotorID   ;
    txtCDraftMotor.placeholder      = partInfo.inducerDraftMotorID    ;
    txtCTransformer.placeholder     = partInfo.transformerID          ;
    txtCControlBoard.placeholder    = partInfo.controlboardID         ;
    txtCLimitSwitch.placeholder     = partInfo.limitSwitchID          ;
    txtCIgnitor.placeholder         = partInfo.ignitorID              ;
    txtCGasValve.placeholder        = partInfo.gasValveID             ;
    txtCPressureSwitch.placeholder  = partInfo.pressureSwitchID       ;
    txtCFlameSensor.placeholder     = partInfo.flameSensorID          ;
    txtCRolloutSensor.placeholder   = partInfo.rolloutsensorID        ;
    txtCDoorSwitch.placeholder      = partInfo.doorswitchID           ;
    txtCIgControlBoard.placeholder  = partInfo.ignitioncontrolBoardID ;
    txtCCoilCleaner.placeholder     = partInfo.coilCleanerID          ;
    txtCMisc.placeholder            = partInfo.miscID                 ;
}
-(NSMutableArray *)makeDictionary
{
    NSArray *arrLblKey  = @[@"0",ACKeyRefrigerantType,ACKeyEleService,ACKeyMaxBreaker,ACKeyBreaker,ACKeyCompressor,ACKeyCapacitor,ACKeyContractor,ACKeyFilterDryer,ACKeyDfrostBoard,ACKeyRelay,ACKeyTXVvalve,ACKeyReversingValve,ACKeyBlowerMotor,ACKeyCondensingMotor,ACKeyInducerMotor,ACKeyTransformer,ACKeyControlBoard,ACKeyLimitSwitch,ACKeyIgnitor,ACKeyGasvalve,ACKeyPressureSwitch,ACKeyFlameSensor,ACKeyRollSensor,ACKeyDoorSwitch,ACKeyIgnitionCntrlBoard,ACKeyCoilCleaner,ACKeyMisc];
    
    
    NSMutableArray  *arr  = [[NSMutableArray alloc]init];
    
//    if(isMatched == 3)
//    {
        if([unitType isEqualToString:GUnitTypeSplit])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:txtMfBrand.text forKey:ACKeyMbrand];
            [dict setValue:txtTon.text forKey:ACKeyUnitTon];
            
            for(int i =1 ; i< arrLblKey.count ; i++)
            {
                UITextField *tf = (UITextField *)[self.view viewWithTag:i+2];
                
                if(tf.placeholder)
                {
                    [dict setValue:tf.placeholder forKey:arrLblKey[i]];
                }
            }
            
            [arr addObject:dict];
            
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
            [dict1 setValue:txtCMfBrand.text forKey:ACKeyMbrand];
            [dict1 setValue:txtCTon.text forKey:ACKeyUnitTon];
            
            for(int i =1 ; i< arrLblKey.count ; i++)
            {
                UITextField *tf = (UITextField *)[self.view viewWithTag:i+31];
                
                if(tf.placeholder)
                {
                    [dict1 setValue:tf.placeholder forKey:arrLblKey[i]];
                }
            }
            
            [arr addObject:dict1];
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:txtMfBrand.text forKey:ACKeyMbrand];
            [dict setValue:txtTon.text forKey:ACKeyUnitTon];
            
            for(int i =1 ; i< arrLblKey.count ; i++)
            {
                UITextField *tf = (UITextField *)[self.view viewWithTag:i+2];
                
                if(tf.placeholder)
                {
                    [dict setValue:tf.placeholder forKey:arrLblKey[i]];
                }
            }
            
            [arr addObject:dict];
        }
        
    //}
//    else if(isMatched == 2)
//    {
//            if(arrUnitInfo.count > 0)
//            {
//                ACEACPartInfo *part = arrUnitInfo[0];
//                //**** match of heating unit found so send cooling unit data ****
//                if([part.typeofunit isEqualToString:GUnitTypeHeating])
//                {
//                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//                    [dict setValue:txtCMfBrand.text forKey:ACKeyMbrand];
//                    [dict setValue:txtCTon.text forKey:ACKeyUnitTon];
//                    [dict setValue:GUnitTypeCooling forKey:ACKeyUnitType];
//                    for(int i =1 ; i< arrLblKey.count ; i++)
//                    {
//                        UITextField *tf = (UITextField *)[self.view viewWithTag:i+31];
//                        if(tf.placeholder)
//                        {
//                            [dict setValue:tf.placeholder forKey:arrLblKey[i]];
//                        }
//                    }
//                    
//                  [arr addObject:dict];
//                }
//                //****match of cooling unit found so send heating unit data****
//                else if ([part.typeofunit isEqualToString:GUnitTypeCooling])
//                {
//                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//                    [dict setValue:txtMfBrand.text forKey:ACKeyMbrand];
//                    [dict setValue:txtTon.text forKey:ACKeyUnitTon];
//                    [dict setValue:GUnitTypeHeating forKey:ACKeyUnitType];
//                    for(int i =1 ; i< arrLblKey.count ; i++)
//                    {
//                        UITextField *tf = (UITextField *)[self.view viewWithTag:i+2];
//                        if(tf.placeholder)
//                        {
//                            [dict setValue:tf.placeholder forKey:arrLblKey[i]];
//                        }
//                      
//                    }
//                    [arr addObject:dict];
//                }
//            }
//    }
    
    return arr;
}
-(void)openManualFieldViewController:(NSMutableArray *)arrPartInfo
{
    AddUnitManualFieldsViewController *vc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitManualFieldsViewController"];
    
    vc.headingTitle         = headingTitle  ;
    vc.unitType             = unitType      ;
    vc.unitId               = unitId        ;
    vc.UnitDetail           = unitDetail    ;
    vc.shouldCallWebservice = !shouldCallWebservice;
    vc.arrModelSerial       = arrModelSerial;
    vc.isMatched            = isMatched     ;
    vc.arrUnitExtraInfo     = arrPartInfo   ;
    vc.dictclientInfo       = dictClientInfo;
    vc.paymentOption        = _paymentOption;
    vc.isHeatingMatched     = isHeatingMatched;
    
    if ([headingTitle isEqualToString:@"Add Unit"] || isMatched == 3)
    {
        vc.shouldCallWebservice = NO;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)openPartController:(NSString *)partId
{
    SearchPartViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchPartViewController"];
    svc.isFromAddOrder  = YES;
    svc.delegate        = self;
    svc.partId          = partId;
    [self presentViewController:svc animated:YES completion:nil];
}
-(BOOL)isValidInfo
{
        ZWTValidationResult result;
        
        result = [txtMfBrand validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankManufactureBrand belowView:txtMfBrand];
            
            return NO;
        }
        
        result = [txtTon validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankUnitTon belowView:txtTon];
            return NO;
        }
    
    if([unitType isEqualToString:GUnitTypeSplit])
    {
        result = [txtCMfBrand validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankManufactureBrand belowView:txtCMfBrand];
            return NO;
        }
        
        result = [txtCTon validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
        
        if (result == ZWTValidationResultBlank)
        {
            [self showErrorMessage:ACEBlankUnitTon belowView:txtCTon];
            return NO;
        }
    }
    
    return YES;
}
#pragma mark - tableview delegate method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        return arrManuals.count;
    }
    else if(tableView.tag  == 200)
    {
       return arrCoolingManuals.count;
    }
    else
    {
        return 0;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView.tag == 100)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ManualCell"];
        
       // cell.textLabel.text          = [NSString stringWithFormat:@"Manual %ld",indexPath.row + 1];
    }
    else if(tableView.tag == 200)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"coolingManualCell"];
    }
    
    cell.textLabel.text          = [NSString stringWithFormat:@"Manual %ld",(long)indexPath.row + 1];

    
    tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle          = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font          = [UIFont fontWithName:@"OpenSans" size:15];
    cell.textLabel.backgroundColor = [UIColor selectedBackgroundColor];
    
    if (indexPath.row > 0)
    {
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor separatorColor];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url ;
    
    if(tableView.tag == 100)
    {
        NSDictionary *dict = arrManuals[indexPath.row];
        
        url =  [NSURL URLWithString:dict[ACKeyManualUrl]];
    }
    else if (tableView.tag == 200)
    {
        NSDictionary *dict = arrCoolingManuals[indexPath.row];
        
        url =  [NSURL URLWithString:dict[ACKeyManualUrl]];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication]openURL:url];
    }
    else
    {
        [self showAlertWithMessage:ACECanNotOpenUrl];
    }
    
}

#pragma mark - UITextField delegate methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectedTxtTag = textField.tag;
    
    if(!(textField == txtTon || textField == txtMfBrand || textField == txtCTon || textField == txtCMfBrand))
    {
        [self doneTap];
        if(textField.tag > 29)
        {
            if(textField.tag == 32) // for refrigerent part
            {
                [self openPartController:[NSString stringWithFormat:@"%ld",(long)textField.tag - 29 + 1]];
            }
            else if (textField.tag == 33) // for electrical service
            {
                [self openPartController:@"Electrical"];
            }
            else if (textField.tag == 34) // for max breaker
            {
                [self openPartController:@"MaxBreaker"];
            }
            else
            {
               [self openPartController:[NSString stringWithFormat:@"%ld",(long)textField.tag - 29 - 1]];
            }
        }
        else
        {
            
            if(textField.tag == 3) // for refrigerent part
            {
                [self openPartController:[NSString stringWithFormat:@"%ld",(long)textField.tag + 1]];
            }
            else if (textField.tag == 4) // for electrical service
            {
                [self openPartController:@"Electrical"];
            }
            else if (textField.tag == 5) // for max breaker
            {
                [self openPartController:@"MaxBreaker"];
            }
            else
            {
                [self openPartController:[NSString stringWithFormat:@"%ld",(long)textField.tag-1]];
            }
        }
        return NO;
    }
    else
    {
        return YES;
    }

    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    
    textField.layer.borderColor = [UIColor separatorColor].CGColor;
    
    if(textField == txtTon || textField == txtCTon)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 20)
        {
            return NO;
        }
    }
    return YES;
}
-(void)doneTap
{
    if([unitType isEqualToString:GUnitTypeSplit])
    {
         [scrlv setContentSize:CGSizeMake(scrlv.width,vwCooling.height + vwHeating.height )];
    }
    else
    {
        [scrlv setContentSize:CGSizeMake(scrlv.width,vwHeating.height )];//+ 50

    }
}
/*-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        selectedTxtTag = textField.tag;
    
    if(!(textField == txtTon || textField == txtMfBrand || textField == txtCTon || textField == txtCMfBrand))
    {
       // [self.view endEditing:YES];
        //[textField resignFirstResponder];
        
        if(textField.tag > 26)
        {
            [self openPartController:[NSString stringWithFormat:@"%ld",(long)textField.tag - 26]];
        }
        else
        {
            [self openPartController:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
        }
    
    }
}/*/

#pragma mark - Search Part Delegate Method
-(void)SelectedPartName:(ACEParts *)part
{
    UITextField *tf = (UITextField *)[self.view viewWithTag:selectedTxtTag];
    
    tf.text = [NSString stringWithFormat:@"%@ %@",part.partName,part.partSize];
    tf.placeholder = part.ID;
    
    if([part.ID isEqualToString:@"0"])
    {
        tf.placeholder = part.partSize;
    }
}

#pragma mark - Event methods
- (IBAction)btnBack:(id)sender
{
    //[self.delegate dismissUnmatchedPoppup];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNextTap:(id)sender
{
//    if(isMatched == 1)
//    {
//        [self openManualFieldViewController:nil];
//    }
//    else
//    {
        if([self isValidInfo])
        {
            [self openManualFieldViewController:[self makeDictionary]];
        }
        
  //  }
    
}

#pragma mark - Webservice method
-(void)callWebserviceOfUnitDetail
{
    if([ACEUtil reachable])
    {
        [self getUnitDetail];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)getUnitDetail
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                               ACKeyID : unitId,
                               UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    [ACEWebServiceAPI getUnitClientInfo:dict completionHandler:^(ACEAPIResponse *response, ACEACUnit *unit)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             unitDetail = unit;
             //[arrUnitInfo addObject:unitDetail];
             //unitType   = unitDetail.unitType   ;
             [self prepareUnitData:unitDetail.arrPartsInfo];
             [self setFramesOfView];
             
             //[self prepareView];
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


#pragma mark - Unused Methods
/*-(void)unusedMethod
{
        NSDictionary *dict = @{
                               ACKeyRefrigerantType : txtRefType.placeholder,
                               ACKeyEleService      : txtEleService.placeholder,
                               ACKeyMaxBreaker      : txtMaxBreaker.placeholder,
                               ACKeyCompressor      : txtCompressor.placeholder,
                               ACKeyCapacitor       : txtCapacitor.placeholder,
                               ACKeyContractor      : txtContractor.placeholder,
                               ACKeyFilterDryer     : txtFilterDryer.placeholder,
                               ACKeyDfrostBoard     : txtDefrostBoard.placeholder,
                               ACKeyRelay           : txtRelay.placeholder,
                               ACKeyTXVvalve        : txtTXVValve.placeholder,
                               ACKeyReversingValve  : txtReversingValve.placeholder,
                               ACKeyBlowerMotor     : txtBlowerMotor.placeholder,
                               ACKeyCondensingMotor : txtCondensingMotor.placeholder,
                               ACKeyInducerMotor    : txtInducerDraft.placeholder,
                               ACKeyTransformer     : txtTransformer.placeholder,
                               ACKeyControlBoard    : txtControlBoard.placeholder,
                               ACKeyLimitSwitch     : txtLimitSwitch.placeholder,
                               ACKeyIgnitor         : txtIgnitor.placeholder,
                               ACKeyGasvalve        : txtGasValve.placeholder,
                               ACKeyPressureSwitch  : txtPressureSwitch.placeholder,
                               ACKeyFlameSensor     : txtFlameSensor.placeholder,
                               ACKeyRollSensor      : txtRolloutSensor.placeholder,
                               ACKeyDoorSwitch      : txtDoorSwitch.placeholder,
                               ACKeyIgnitionCntrlBoard : txtIgControlBoard.placeholder
                               };
}*/
@end
