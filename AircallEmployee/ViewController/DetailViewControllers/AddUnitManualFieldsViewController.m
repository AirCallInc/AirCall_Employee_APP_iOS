//
//  AddUnitManualFieldsViewController.m
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddUnitManualFieldsViewController.h"

@interface AddUnitManualFieldsViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ChooseQty,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SearchPart,ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;
@property (weak, nonatomic) IBOutlet UIView *vwFilter;
@property (weak, nonatomic) IBOutlet UITextField *txtFilterQty;
@property (weak, nonatomic) IBOutlet UITableView *tblvFilter;
@property (weak, nonatomic) IBOutlet UIView *vwFuses;
@property (weak, nonatomic) IBOutlet UITextField *txtFuseQty;
@property (weak, nonatomic) IBOutlet UITableView *tblvFuses;
@property (weak, nonatomic) IBOutlet UIView *vwBooster;
@property (weak, nonatomic) IBOutlet UITextField *txtBooster;
@property (weak, nonatomic) IBOutlet UIView *vwPictures;
@property (weak, nonatomic) IBOutlet UICollectionView *collv;
@property (weak, nonatomic) IBOutlet UIView *vwHeating;
@property (weak, nonatomic) IBOutlet UIView *vwInfo;
@property (weak, nonatomic) IBOutlet SAMTextView *txtvNotes;

@property (weak, nonatomic) IBOutlet UILabel *txtPlanPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoRenew;
@property (weak, nonatomic) IBOutlet UIButton *btnSpecialOffer;
@property (weak, nonatomic) IBOutlet UIView    *vwSpOffer;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;


//Colling View
@property (weak, nonatomic) IBOutlet UIView *vwCooling;
@property (weak, nonatomic) IBOutlet UIView *vwCFilter;
@property (weak, nonatomic) IBOutlet UITextField *txtCFilterQty;
@property (weak, nonatomic) IBOutlet UITableView *tblvCFilter;
@property (weak, nonatomic) IBOutlet UIView *vwCFuses;
@property (weak, nonatomic) IBOutlet UITextField *txtCFuseQty;
@property (weak, nonatomic) IBOutlet UITableView *tblvCFuses;
@property (weak, nonatomic) IBOutlet UIView *vwCBooster;
@property (weak, nonatomic) IBOutlet UITextField *txtCBooster;
@property (weak, nonatomic) IBOutlet UICollectionView *collvCooling;
@property (weak, nonatomic) IBOutlet UIView *vwCPictures;
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;

@property (strong, nonatomic) IBOutlet UILabel *lblUnitTypeTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSpecialOffer;
@property (strong, nonatomic) IBOutlet UILabel *lblPerMnthPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblForAllMnths;

@property (strong, nonatomic) IBOutlet UIView *vwPlanPrice;
@property (strong, nonatomic) IBOutlet UIView *vwPlanDetail;
@property (strong, nonatomic) IBOutlet UIView *vwPlanInfo;

@property (weak,nonatomic) ACEServiceImageCell *cellImg;
@property (weak,nonatomic) ACEServiceImageCell *cellCoolingImg;
@property ACEFilterCell     *filterCell         ;
@property ACEFuseCell       *fuseCell           ;
@property UICollectionView  *selectedCollv      ;
@property NSMutableArray    *arrUnitImage       ;
@property NSMutableArray    *arrCoolingImage    ;
@property NSMutableArray    *arrTextBoxes       ;
@property NSMutableArray    *arrManualFields    ;
@property NSMutableArray    *arrImageIndex      ;
@property NSMutableArray    *arrCoolingImageIndex;
@property NSMutableArray    *arrPictures;
@property NSMutableArray    *arrCoolingPictures;

@property NSInteger selectedTxtTag;
@property CGFloat scrlvHeight;
//@property NSString *unitType;
@property BOOL isSpecialOffer;
@property NSInteger imgIndexPath;
@property NSInteger imgSplitIndexPath;
@property UITextField *selectedTextField;
@property UITableView *selectedTableView;

@property ZWTTextboxToolbarHandler *handler;
@end

@implementation AddUnitManualFieldsViewController

@synthesize scrlv,vwFilter,txtFilterQty,tblvFilter,vwFuses,txtFuseQty,tblvFuses,vwBooster,txtBooster,collv,vwInfo,txtvNotes,txtPlanPrice,btnAutoRenew,btnSpecialOffer,btnSubmit,scrlvHeight,vwHeating,vwPictures,vwSpOffer,lblSpecialOffer,vwPlanPrice,vwPlanDetail,lblPerMnthPrice,lblForAllMnths;

@synthesize vwCooling,vwCFilter,txtCFilterQty,tblvCFilter,vwCFuses,txtCFuseQty,tblvCFuses,vwCBooster,txtCBooster,collvCooling,cellCoolingImg,vwCPictures,vwPlanInfo;

@synthesize cellImg,arrUnitImage,unitType,arrCoolingImage,selectedCollv,lblHeading,headingTitle,lblUnitTypeTitle,isSpecialOffer;

@synthesize selectedTxtTag,selectedTextField,selectedTableView,imgIndexPath,imgSplitIndexPath,filterCell,fuseCell,handler,arrTextBoxes,arrManualFields;

@synthesize UnitDetail,unitId,shouldCallWebservice,isMatched,arrModelSerial,arrUnitExtraInfo,dictclientInfo;

@synthesize arrImageIndex,arrCoolingImageIndex,isHeatingMatched,arrPictures,arrCoolingPictures;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[handler btnDoneTap];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    //unitType = @"Split";
    lblHeading.text = headingTitle;
    
    if(![headingTitle isEqualToString:ACEAddUnitTitle])
    {
        [btnSubmit setTitle:@"Update" forState:UIControlStateNormal];
        
        [self hidePaymnetView];
    }
    else
    {
        [btnSubmit setTitle:@"Proceed to summary" forState:UIControlStateNormal];
        [self getPlanInfo];

    }
    
    txtvNotes.placeholder = @"Recommendations to customer";
    
    if (![unitType isEqualToString:GUnitTypeSplit])
    {
        lblUnitTypeTitle.text = unitType;
    }
    
    arrUnitImage    = [[NSMutableArray alloc]init];
    arrCoolingImage = [[NSMutableArray alloc]init];
    arrTextBoxes    = [[NSMutableArray alloc]init];
    arrImageIndex   = [[NSMutableArray alloc]init];
    arrCoolingImage = [[NSMutableArray alloc]init];
    arrPictures     = [[NSMutableArray alloc]init];
    arrCoolingPictures = [[NSMutableArray alloc]init];
    
    if(shouldCallWebservice)
    {
        [self getManualFieldOfUnit];
        
//        for(int i =0 ; i<=3 ; i++)
//        {
//            ACEServiceImage *imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
//            
//            imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
//            
//            [arrUnitImage addObject:imgUnitPlaceholder];
//        }
//        
//        for (int i = 0; i <= 3; i++)
//        {
//            ACEServiceImage *imgCoolingPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
//            
//            imgCoolingPlaceholder.status = ACEImageStatusPlaceholder;
//            
//            [arrCoolingImage addObject:imgCoolingPlaceholder];
//        }

    }
//    else if(UnitDetail)
//    {
//        [self setDataOfUnitManualFields];
//    }
    else
    {
        for(int i =0 ; i<=3 ; i++)
        {
            ACEServiceImage *imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
            
            imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
            
            [arrUnitImage addObject:imgUnitPlaceholder];
        }
        
        for (int i = 0; i <= 3; i++)
        {
            ACEServiceImage *imgCoolingPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
            
            imgCoolingPlaceholder.status = ACEImageStatusPlaceholder;
            
            [arrCoolingImage addObject:imgCoolingPlaceholder];
        }
    }

    [self setframesOfView];
    
    //[self btnPaymentMethodTap:btnAutoRenew];
}

-(void)disableView
{
    txtFuseQty.userInteractionEnabled       = NO;
    txtFilterQty.userInteractionEnabled     = NO;
    txtCFilterQty.userInteractionEnabled    = NO;
    txtCFuseQty.userInteractionEnabled      = NO;
    tblvCFuses.userInteractionEnabled       = NO;
    tblvCFilter.userInteractionEnabled      = NO;
    tblvFuses.userInteractionEnabled        = NO;
    tblvFilter.userInteractionEnabled       = NO;
}
-(void)hidePaymnetView
{
    vwInfo.height = vwInfo.height - vwPlanDetail.height;
    vwPlanDetail.hidden = YES;
    //vwPlanDetail
}
-(void)setPaymentInfoView:(NSDictionary *)paymentInfo
{
    float perMnth = [paymentInfo[GPricePerMonth]floatValue];
    float forMnth = [paymentInfo[GPrice]floatValue];
    
    lblPerMnthPrice.text = [NSString stringWithFormat:@"$%0.2f",
    perMnth];
    
    txtPlanPrice.text    = [NSString stringWithFormat:@"For %@ Months",paymentInfo[GPlanDuration]];
    
    
    lblForAllMnths.text  = [NSString stringWithFormat:@"$%0.2f",
    forMnth];
    
    lblSpecialOffer.text = paymentInfo[GSpecialText];
    bool shouldDisplay   = [paymentInfo[GShouldDisplay]boolValue];
    
    bool isAutoRenewal = [paymentInfo[GShowAutoRenewal]boolValue];
    
    if(!shouldDisplay && isAutoRenewal)
    {
        vwSpOffer.hidden         = YES;
        vwPlanInfo.height        = vwPlanInfo.height - vwSpOffer.height;
    }
    else if (!isAutoRenewal && shouldDisplay)
    {
        btnAutoRenew.hidden   = YES                 ;
        vwSpOffer.y           = btnAutoRenew.y      ;
        vwPlanInfo.height     = vwSpOffer.height    ;
    }
    else if(!isAutoRenewal && !shouldDisplay)
    {
        vwPlanInfo.hidden   = YES;
        vwPlanInfo.height   = 0  ;
    }
    
    vwPlanDetail.height = vwPlanPrice.height + vwPlanInfo.height;
    vwInfo.height       = vwPlanDetail.y + vwPlanDetail.height;
    [self setframesOfView];
}
-(void)setDataOfUnitManualFields
{
    if([unitType isEqualToString:GUnitTypeSplit])
    {
        if(UnitDetail.arrPartsInfo.count > 0)
        {
            ACEACPartInfo *part = UnitDetail.arrPartsInfo[0];
            
            txtFilterQty.text   = [NSString stringWithFormat:@"%d",
                                   part.filterQnty];
            txtFuseQty.text     = [NSString stringWithFormat:@"%d",part.fuseQnty];
            
            txtBooster.text        = part.booster;
            txtBooster.placeholder = [part.boosterId isEqualToString:@"0"]?@"":part.boosterId;
            
            [tblvFilter reloadData];
            [tblvFuses reloadData];
            
            for(int i =0 ; i<=3 ; i++)
            {
                ACEServiceImage *imgUnitPlaceholder;
                
                if(part.arrPictures.count > i)
                {
                   // UIImageView *imgv = [[UIImageView alloc]init];
                    
                    NSDictionary *dict = part.arrPictures[i];
                    
                    //[imgv setImageWithURL:[NSURL URLWithString:
                    // dict[ACKeyPictureUrl]]];
                    
                   imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                    
                   // imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:imgv.image];
                    
                    imgUnitPlaceholder.status = ACEImageStatusSet;
                }
                else
                {
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    
                    imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                }
                
                [arrUnitImage addObject:imgUnitPlaceholder];
            }
            
            [collv reloadData];
            
        }
        if(UnitDetail.arrPartsInfo.count > 1)
        {
            ACEACPartInfo *part = UnitDetail.arrPartsInfo[1];
            txtCFilterQty.text  = [NSString stringWithFormat:@"%d",
                                   part.filterQnty];
            
            txtCFuseQty.text    = [NSString stringWithFormat:@"%d",part.fuseQnty];
            txtCBooster.text    = part.booster;
            
            txtCBooster.placeholder = [part.boosterId isEqualToString:@"0"]?@"":part.boosterId;
            
            [tblvCFilter reloadData];
            [tblvCFuses reloadData];
            
            for (int i = 0; i <= 3; i++)
            {
                ACEServiceImage *imgUnitPlaceholder;
                
                if(part.arrPictures.count > i)
                {
                    //UIImageView *imgv = [[UIImageView alloc]init];
                    
                    NSDictionary *dict = part.arrPictures[i];
                    
                    //[imgv setImageWithURL:[NSURL URLWithString:
                                          // dict[ACKeyPictureUrl]]];

                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                    
                    imgUnitPlaceholder.status = ACEImageStatusSet;
                    
//                    UIImageView *imgv = [[UIImageView alloc]init];
//                    
//                    NSDictionary *dict = part.arrPictures[i];
//                    
//                    [imgv setImageWithURL:[NSURL URLWithString:
//                                           dict[ACKeyPictureUrl]]];
//                    
//                    
//                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:imgv.image];
//                    
//                    imgUnitPlaceholder.status = ACEImageStatusSet;
                }
                else
                {
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                }
            
                [arrCoolingImage addObject:imgUnitPlaceholder];
            }
            
            [collvCooling reloadData];

        }
        
        txtvNotes.text = UnitDetail.notes;
        
    }
    else
    {
        if(UnitDetail.arrPartsInfo.count > 0)
        {
            ACEACPartInfo *part = UnitDetail.arrPartsInfo[0];
            
            txtFilterQty.text   = [NSString stringWithFormat:@"%d",
                                   part.filterQnty];
            
            txtFuseQty.text     = [NSString stringWithFormat:@"%d",part.fuseQnty];
            txtBooster.text        = part.booster;
            txtBooster.placeholder = [part.boosterId isEqualToString:@"0"]?@"":part.boosterId;
            txtvNotes.text         = UnitDetail.notes;
            
            [tblvFilter reloadData];
            [tblvFuses reloadData];
            
            for(int i =0 ; i<=3 ; i++)
            {
                ACEServiceImage *imgUnitPlaceholder;
                
                if(part.arrPictures.count > i)
                {
                   // UIImageView *imgv = [[UIImageView alloc]init];
                    NSDictionary *dict = part.arrPictures[i];
                    
                    //[imgv setImageWithURL:[NSURL URLWithString:
                                           //dict[ACKeyPictureUrl]]];
                    
                   // imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:imgv.image];
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                    
                    imgUnitPlaceholder.status = ACEImageStatusSet;
                   /*UIImageView *imgv = [[UIImageView alloc]init];
                    
                    NSDictionary *dict = part.arrPictures[i];
                    
                    [imgv setImageWithURL:[NSURL URLWithString:
                                           dict[ACKeyPictureUrl]]];
                    
                    
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:imgv.image];
                    
                    imgUnitPlaceholder.status = ACEImageStatusSet;*/

                }
                else
                {
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    
                    imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                }
                
                [arrUnitImage addObject:imgUnitPlaceholder];
            }
            [collv reloadData];
        }
        else if (UnitDetail.arrPartsInfo.count > 1)
        {
            
        }
        
    }

}
-(void)setDataOfMAnualFieldsFromWebservice
{
    if([unitType isEqualToString:GUnitTypeSplit])
    {
        if(arrManualFields.count > 0)
        {
            NSDictionary * dict =  arrManualFields[0];
            
            if([dict[ACKeyUnitType] isEqualToString:GUnitTypeHeating])
            {
                txtFilterQty.text   = [NSString stringWithFormat:@"%@",
                                   dict[ACKeyQntFilter]];
                txtFuseQty.text     = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                txtBooster.text        = dict[ACKeyBooster];
                txtBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                 arrPictures = dict[ACKeyPictures];
                
                [tblvFilter reloadData];
                [tblvFuses reloadData];
                
                for(int i =0 ; i<=3 ; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    
                    if(arrPictures.count > i)
                    {
                        // UIImageView *imgv = [[UIImageView alloc]init];
                        
                        NSDictionary *dict = arrPictures[i];
                        
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusSet;
                        
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgUnitPlaceholder.imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                         {
                             imgUnitPlaceholder.image = [UIImage imageWithData:data];
                             [collv reloadData];
                         }];
                    }
                    else
                    {
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    }
                    
                    [arrUnitImage addObject:imgUnitPlaceholder];
                }
                
                [collv reloadData];
                
                for (int i = 0; i <= 3; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                   
                    [arrCoolingImage addObject:imgUnitPlaceholder];
                }
                
                [collvCooling reloadData];
            }
            else if([dict[ACKeyUnitType] isEqualToString:GUnitTypeCooling])
            {
                txtCFilterQty.text  = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                
                txtCFuseQty.text    = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                txtCBooster.text        = dict[ACKeyBooster];
                txtCBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                arrCoolingPictures = dict[ACKeyPictures];
                
                [tblvFilter reloadData];
                [tblvFuses reloadData];
                
                for (int i = 0; i <= 3; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    
                    if(arrCoolingPictures.count > i)
                    {
                        NSDictionary *dict = arrCoolingPictures[i];
                        
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusSet;
                        
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgUnitPlaceholder.imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                         {
                             imgUnitPlaceholder.image = [UIImage imageWithData:data];
                             [collvCooling reloadData];
                         }];
                    }
                    else
                    {
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                        imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    }
                    
                    [arrCoolingImage addObject:imgUnitPlaceholder];
                }
                
                [collvCooling reloadData];
                
                for (int i = 0; i <= 3; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    
                    [arrUnitImage addObject:imgUnitPlaceholder];
                }
                
                [collv reloadData];

            }
            else
            {
                txtFilterQty.text   = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                txtFuseQty.text     = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                txtBooster.text        = dict[ACKeyBooster];
                txtBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                arrPictures = dict[ACKeyPictures];
                
                [tblvFilter reloadData];
                [tblvFuses reloadData];
                
                for(int i =0 ; i<=3 ; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    
                    imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    
                    [arrUnitImage addObject:imgUnitPlaceholder];
                }
                
                [collv reloadData];
                
                txtCFilterQty.text  = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                
                txtCFuseQty.text    = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                txtCBooster.text        = dict[ACKeyBooster];
                txtCBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                arrCoolingPictures = dict[ACKeyPictures];
                
                [tblvFilter reloadData];
                [tblvFuses reloadData];
                
                for (int i = 0; i <= 3; i++)
                {
                    ACEServiceImage *imgCoolingPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    
                    imgCoolingPlaceholder.status = ACEImageStatusPlaceholder;
                    
                    [arrCoolingImage addObject:imgCoolingPlaceholder];
                }
                
                [collvCooling reloadData];
            }
        }
        if(arrManualFields.count > 1)
        {
            NSDictionary * dict =  arrManualFields[1];
            
            if([dict[ACKeyUnitType] isEqualToString:GUnitTypeHeating])
            {
                txtFilterQty.text   = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                txtFuseQty.text     = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                
                txtBooster.text         = dict[ACKeyBooster];
                txtBooster.placeholder  = [dict[ACKeyBoosterId]stringValue];
                
                arrPictures = dict[ACKeyPictures];
                
                [tblvCFilter reloadData];
                [tblvCFuses reloadData];
                
                arrUnitImage = [[NSMutableArray alloc]init];
                
                for(int i =0 ; i<=3 ; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    
                    if(arrPictures.count > i)
                    {
                        NSDictionary *dict = arrPictures[i];
                        
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusSet;
                        
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgUnitPlaceholder.imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                         {
                             imgUnitPlaceholder.image = [UIImage imageWithData:data];
                             [collv reloadData];
                         }];
                    }
                    else
                    {
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    }
                    
                    [arrUnitImage addObject:imgUnitPlaceholder];
                }
                
                [collv reloadData];
            }
             else if([dict[ACKeyUnitType] isEqualToString:GUnitTypeCooling])
            {
                txtCFilterQty.text  = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                txtCFuseQty.text    = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                txtCBooster.text    = dict[ACKeyBooster];
                txtCBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                arrCoolingPictures = dict[ACKeyPictures];
                
                [tblvCFilter reloadData];
                [tblvCFuses reloadData];
                
                arrCoolingImage = [[NSMutableArray alloc]init];
                
                for (int i = 0; i <= 3; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    
                    if(arrCoolingPictures.count > i)
                    {
                        NSDictionary *dict = arrCoolingPictures[i];
                        
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusSet;
                        
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgUnitPlaceholder.imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                         {
                             imgUnitPlaceholder.image = [UIImage imageWithData:data];
                             [collvCooling reloadData];
                         }];
                    }
                    else
                    {
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                        imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    }
                    
                    [arrCoolingImage addObject:imgUnitPlaceholder];
                }
                
                [collvCooling reloadData];
            }
            else
            {
                txtCFilterQty.text  = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                txtCFuseQty.text    = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                txtCBooster.text    = dict[ACKeyBooster];
                txtCBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                arrCoolingPictures = dict[ACKeyPictures];
                
                [tblvCFilter reloadData];
                [tblvCFuses reloadData];
                
                arrCoolingImage = [[NSMutableArray alloc]init];
                
                for (int i = 0; i <= 3; i++)
                {
                    ACEServiceImage *imgCoolingPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                    
                    imgCoolingPlaceholder.status = ACEImageStatusPlaceholder;
                    
                    [arrCoolingImage addObject:imgCoolingPlaceholder];
                }
                
                [collvCooling reloadData];
            }
        }
        //txtvNotes.text = UnitDetail.notes;
    }
    else
    {
        if(arrManualFields.count > 0)
        {
            NSDictionary * dict =  arrManualFields[0];
            
            if([dict[ACKeyUnitType] isEqualToString:GUnitTypeHeating] ||[dict[ACKeyUnitType] isEqualToString:GUnitTypePackaged])
            {
                txtFilterQty.text   = [NSString stringWithFormat:@"%@",
                                       dict[ACKeyQntFilter]];
                
                txtFuseQty.text     = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
                
                txtBooster.text     = dict[ACKeyBooster];
                
                txtvNotes.text      = dict[ACKeyNotes];
                
                arrPictures = dict[ACKeyPictures];
                
                if (![dict[ACKeyBoosterId] isKindOfClass:[NSNull class]])
                {
                    txtBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
                }
                
                [tblvFilter reloadData];
                [tblvFuses reloadData];
                
                
                for(int i =0 ; i<=3 ; i++)
                {
                    ACEServiceImage *imgUnitPlaceholder;
                    
                    if(arrPictures.count > i)
                    {
                        NSDictionary *dict = arrPictures[i];

                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUrl:dict[ACKeyPictureUrl]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusSet;
                        
//                        NSData *imageData = [NSData dataWithContentsOfURL:imgUnitPlaceholder.imageURL];
//                        imgUnitPlaceholder.image = [UIImage imageWithData:imageData];
                        
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgUnitPlaceholder.imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                         {
                             imgUnitPlaceholder.image = [UIImage imageWithData:data];
                             [collv reloadData];
                         }];
                        
//                        imgUnitPlaceholder.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:imgUnitPlaceholder.imageURL]];
                        
//                        imgUnitPlaceholder.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUnitPlaceholder.imageURL]];
                    }
                    else
                    {
                        imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                        
                        imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                    }
                    
                    [arrUnitImage addObject:imgUnitPlaceholder];
                }
                
                [collv reloadData];
            }
        }
        else if(arrManualFields.count > 1)
        {
            NSDictionary * dict =  arrManualFields[0];
            
            
            txtFilterQty.text   = [NSString stringWithFormat:@"%@",
                                   dict[ACKeyQntFilter]];
            
            txtFuseQty.text     = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
            
            txtBooster.text     = dict[ACKeyBooster];
            
            txtvNotes.text      = dict[ACKeyNotes];
            
            arrPictures = dict[ACKeyPictures];
            
            if (![dict[ACKeyBoosterId] isKindOfClass:[NSNull class]])
            {
                txtBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
            }
            
            [tblvFilter reloadData];
            [tblvFuses reloadData];
            
        
            for(int i =0 ; i<=3 ; i++)
            {
                ACEServiceImage *imgUnitPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                
                imgUnitPlaceholder.status = ACEImageStatusPlaceholder;
                
                [arrUnitImage addObject:imgUnitPlaceholder];
            }
            
            [collv reloadData];
            
            txtCFilterQty.text  = [NSString stringWithFormat:@"%@",
                                   dict[ACKeyQntFilter]];
            txtCFuseQty.text    = [NSString stringWithFormat:@"%@",dict[ACKeyQntFuses]];
            txtCBooster.text    = dict[ACKeyBooster];
            txtCBooster.placeholder = [dict[ACKeyBoosterId]stringValue];
            
            txtvNotes.text      = dict[ACKeyNotes];
            
            arrCoolingPictures = dict[ACKeyPictures];
            
            [tblvCFilter reloadData];
            [tblvCFuses reloadData];

            
            for (int i = 0; i <= 3; i++)
            {
                ACEServiceImage *imgCoolingPlaceholder = [[ACEServiceImage alloc]initWithUIImage:[UIImage imageNamed:@"defimage"]];
                
                imgCoolingPlaceholder.status = ACEImageStatusPlaceholder;
                
                [arrCoolingImage addObject:imgCoolingPlaceholder];
            }
            
            [collvCooling reloadData];
        }
    }
    
    [self setframesOfView];

}
-(void)setImagesOfUnit
{
    
}
-(void)setFramesOfHeatingView
{
    tblvFilter.height =  tblvFilter.contentSize.height;
    tblvFuses.height  =  tblvFuses.contentSize.height;
    vwFilter.height   =  tblvFilter.contentSize.height + 50;
    vwFuses.frame     =  CGRectMake(vwFuses.x, CGRectGetMaxY(vwFilter.frame), vwFuses.width, tblvFuses.contentSize.height + 50);
    
    vwBooster.y     =  CGRectGetMaxY(vwFuses.frame);
    vwPictures.y    =  CGRectGetMaxY(vwBooster.frame);
    
    //collv.frame = CGRectMake(collv.x, CGRectGetMaxY(vwBooster.frame), collv.width, collv.height);
    vwHeating.height = vwFilter.height + vwFuses.height + vwBooster.height + vwPictures.height + 80;
    
    vwInfo.y    = CGRectGetMaxY(vwHeating.frame);
    
    //scrlvHeight = vwFilter.height + vwFuses.height + vwBooster.height + vwPictures.height + vwInfo.height;
    
    scrlvHeight = vwInfo.y + vwInfo.height;
    
    [scrlv setContentSize:CGSizeMake(scrlv.width,scrlvHeight)];
    
    arrTextBoxes = [NSMutableArray arrayWithObject:txtvNotes];
    
    handler      = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextBoxes andScroll:scrlv];
    
    handler.showNextPrevious = NO;
}

-(void)setStatusOfImage:(ACEServiceImage *)unitImage
{
    //ACEServiceImage *unitImage = arrUnitImage[indexPath.item];
    
    switch (unitImage.status)
    {
        case ACEImageStatusPlaceholder:
        {
            [self askImageSource];
            break;
        }
        case ACEImageStatusSet:
        {
            [self openImageController:unitImage];
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

-(void)setFramesOfCoolingView
{
    // Heating
    tblvFilter.height =  tblvFilter.contentSize.height;
    tblvFuses.height  =  tblvFuses.contentSize.height;
    vwFilter.height   = tblvFilter.contentSize.height + tblvFilter.y ; //+ 50
    
    vwFuses.frame = CGRectMake(vwFuses.x, CGRectGetMaxY(vwFilter.frame), vwFuses.width, tblvFuses.contentSize.height + tblvFuses.y ); //+ 50
    
    vwBooster.y     =  CGRectGetMaxY(vwFuses.frame);
    vwPictures.y    = CGRectGetMaxY(vwBooster.frame);
    
    //vwHeating.height = vwFilter.height + vwFuses.height + vwBooster.height + vwPictures.height ; //+ 40
    vwHeating.height   = vwPictures.y + vwPictures.height;
    
    //Cooling
    vwCooling.y = CGRectGetMaxY(vwHeating.frame);
    vwCFilter.frame = CGRectMake(vwCFilter.x,30, vwCFilter.width, tblvCFilter.contentSize.height + tblvCFilter.y ); //+ 50
    
    tblvCFilter.frame = CGRectMake(tblvCFilter.x, CGRectGetMaxY(txtCFilterQty.frame) + 10, tblvCFilter.width, tblvCFilter.contentSize.height);
    
    vwCFuses.frame = CGRectMake(vwCFuses.x, CGRectGetMaxY(vwCFilter.frame), vwCFuses.width, tblvCFuses.contentSize.height + tblvCFuses.y); //+ 50
    
    tblvCFuses.frame = CGRectMake(tblvCFuses.x, CGRectGetMaxY(txtCFuseQty.frame) + 10, tblvCFuses.width, tblvCFuses.contentSize.height);
    
    vwCBooster.y =  CGRectGetMaxY(vwCFuses.frame);
    
    vwCPictures.y = CGRectGetMaxY(vwCBooster.frame);
    
   // vwCooling.frame = CGRectMake(vwCooling.x, CGRectGetMaxY(vwHeating.frame) + 30, vwCooling.width, vwCFilter.height + vwCFuses.height + vwCBooster.height + vwCPictures.height ); //+ 40
    vwCooling.height  = vwCPictures.y + vwCPictures.height;
    
    vwInfo.frame = CGRectMake(vwInfo.x,CGRectGetMaxY(vwCooling.frame), vwInfo.width, vwInfo.height ); //+ 30
    
    //scrlvHeight = vwHeating.height + vwCooling.height + vwInfo.height;
    
    scrlvHeight = vwInfo.height + vwInfo.y;
    
    [scrlv setContentSize:CGSizeMake(scrlv.width,scrlvHeight)];
    
    arrTextBoxes = [NSMutableArray arrayWithObject:txtvNotes];
    handler      = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextBoxes andScroll:scrlv];
    handler.showNextPrevious = NO;
}

-(void)setframesOfView
{
    if ([unitType isEqualToString:GUnitTypeSplit])
    {
        vwCooling.hidden = false;
        [self setFramesOfCoolingView];
    }
    else
    {
        vwCooling.hidden = true;
        [self setFramesOfHeatingView];
    }
}
-(void)openPopupView
{
    ChooseQtyPopupViewController *qtyPopup  = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ChooseQtyPopupViewController"];
    qtyPopup.providesPresentationContextTransitionStyle = YES;
    qtyPopup.definesPresentationContext = YES;
    [qtyPopup setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    qtyPopup.delegate = self;
    [self presentViewController:qtyPopup animated:YES completion:nil];
}
-(void)openPartController:(NSString *)partId
{
    SearchPartViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchPartViewController"];
    svc.isFromAddOrder = YES;
    svc.delegate = self;
    svc.partId   = partId;
    [self presentViewController:svc animated:YES completion:nil];
}
-(void)openSummaryViewController :(NSDictionary *)dictUnitInfo
{
    UnitSummaryViewController *usvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitSummaryViewController"];
    
    usvc.dictUnitInfo     = dictUnitInfo    ;
    usvc.dictClientInfo   = dictclientInfo  ;
    usvc.paymentOption    = _paymentOption  ;
    
    [self.navigationController pushViewController:usvc animated:YES];
}
-(void)openUnitListViewController
{
    ACUnitListViewController *aulvc = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ACUnitListViewController"];
    
    [self.navigationController pushViewController:aulvc animated:YES];
 
}
-(NSMutableArray *)makeDictionaryOfManualFields
{
    NSMutableArray *arrParts = [[NSMutableArray alloc]init];
    
    if(isMatched == 1)
    {
        if([unitType isEqualToString:GUnitTypeSplit])
        {
            NSMutableDictionary *dict  = [[NSMutableDictionary alloc]init];
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
            
            if(UnitDetail)
            {
                dict  = [self makeDictFromPartInfo:UnitDetail.arrPartsInfo[0]];
                dict1 = [self makeDictFromPartInfo:UnitDetail.arrPartsInfo[1]];
            }
            else
            {
                dict  = [arrModelSerial[0] mutableCopy];
                dict1 = [arrModelSerial[1] mutableCopy];
            }
            
            [dict setValue:@(true) forKey:ACKeyIsMatched];
            [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
            [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
            [arrParts addObject:dict];
            
            [dict1 setValue:@(true) forKey:ACKeyIsMatched];
            [dict1 setValue:[self makeSplitDataDictionary] forKey:ACKeyOptionalInfo];
            [dict1 addEntriesFromDictionary:arrUnitExtraInfo[1]];
            [arrParts addObject:dict1];
        }
        else
        {
            NSMutableDictionary *dict  = [[NSMutableDictionary alloc]init];
            
            if(UnitDetail)
            {
                dict  = [self makeDictFromPartInfo:UnitDetail.arrPartsInfo[0]];
            }
            else
            {
                dict  = [arrModelSerial[0] mutableCopy];
            }
            
            [dict setValue:@(true) forKey:ACKeyIsMatched];
            [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
            [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
            [arrParts addObject:dict];
        }
    }
    else if(isMatched == 2)
    {
       if([unitType isEqualToString:GUnitTypeSplit])
       {
           if (isHeatingMatched)
           {
               NSMutableDictionary *dict = [arrModelSerial[0] mutableCopy];
               [dict setValue:@(true) forKey:ACKeyIsMatched];
               
               [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
               [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
               [arrParts addObject:dict];
               
               NSMutableDictionary *dict1 = [arrModelSerial[1] mutableCopy];
               [dict1 setValue:@(false) forKey:ACKeyIsMatched];
               [dict1 setValue:[self makeSplitDataDictionary] forKey:ACKeyOptionalInfo];
               [dict1 addEntriesFromDictionary:arrUnitExtraInfo[1]];
               [arrParts addObject:dict1];
           }
           else
           {
               NSMutableDictionary *dict = [arrModelSerial[0] mutableCopy];
               [dict setValue:@(false) forKey:ACKeyIsMatched];
               
               [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
               [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
               [arrParts addObject:dict];
               
               NSMutableDictionary *dict1 = [arrModelSerial[1] mutableCopy];
               [dict1 setValue:@(true) forKey:ACKeyIsMatched];
               [dict1 setValue:[self makeSplitDataDictionary] forKey:ACKeyOptionalInfo];
               [dict1 addEntriesFromDictionary:arrUnitExtraInfo[1]];
               [arrParts addObject:dict1];
           }
           
//           NSDictionary *dictPart =  arrUnitExtraInfo [0];
//           
//           NSMutableDictionary *dict = [arrModelSerial[0] mutableCopy];
//           [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
//           
//           if([dictPart[ACKeyUnitType] isEqualToString:GUnitTypeHeating])
//           {
//               [dict setValue:@(false) forKey:ACKeyIsMatched];
//               [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
//           }
//           else
//           {
//               [dict setValue:@(true) forKey:ACKeyIsMatched];
//               [dict addEntriesFromDictionary:arrUnitExtraInfo[1]];
//           }
//           
//           [arrParts addObject:dict];
//           
//           NSMutableDictionary *dict1 = [arrModelSerial[1] mutableCopy];
//           [dict1 setValue:[self makeSplitDataDictionary] forKey:ACKeyOptionalInfo];
//           
//           if([dictPart[ACKeyUnitType] isEqualToString:GUnitTypeCooling])
//           {
//               [dict1 setValue:@(false) forKey:ACKeyIsMatched];
//               [dict1 addEntriesFromDictionary:arrUnitExtraInfo[0]];
//           }
//           else
//           {
//               [dict1 setValue:@(true) forKey:ACKeyIsMatched];
//           }
//           
//           [arrParts addObject:dict1];
       }
    }
    else if (isMatched == 3)
    {
        if([unitType isEqualToString:GUnitTypeSplit])
        {
            NSMutableDictionary *dict = [arrModelSerial[0] mutableCopy];
            [dict setValue:@(false) forKey:ACKeyIsMatched];
            
            [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
            [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
            [arrParts addObject:dict];
            
            NSMutableDictionary *dict1 = [arrModelSerial[1] mutableCopy];
            [dict1 setValue:@(false) forKey:ACKeyIsMatched];
            [dict1 setValue:[self makeSplitDataDictionary] forKey:ACKeyOptionalInfo];
            [dict1 addEntriesFromDictionary:arrUnitExtraInfo[1]];
            [arrParts addObject:dict1];
        }
        else
        {
            NSMutableDictionary *dict = [arrModelSerial[0] mutableCopy];
            [dict setValue:@(false) forKey:ACKeyIsMatched];
            [dict setValue:[self makeHeatingDataDictionary] forKey:ACKeyOptionalInfo];
            [dict addEntriesFromDictionary:arrUnitExtraInfo[0]];
            [arrParts addObject:dict];
        }
    }
    return arrParts;
}
-(NSDictionary *)makeSplitDataDictionary
{
    NSDictionary *dictOptionalInfo = @{
                                       ACKeyQntyFilter  : txtCFilterQty.text,
                                       ACKeyFilter      : [self getUnitData:txtCFilterQty  OfTableView:tblvCFilter],
                                       ACKeyQntyFuse    : txtCFuseQty.text,
                                       
                                       ACKeyFuseTypes   :[self getUnitData:txtCFuseQty OfTableView:tblvCFuses],
                                       ACKeyBoosterTypes : txtCBooster.placeholder?txtCBooster.placeholder:@""
                                       };
    return dictOptionalInfo;
}
-(NSDictionary *)makeHeatingDataDictionary
{
    NSDictionary *dictOptionalInfo = @{
                                       
                                       ACKeyQntyFilter : txtFilterQty.text,
                                       ACKeyFilter      : [self getUnitData:txtFilterQty OfTableView:tblvFilter],
                                        ACKeyQntyFuse    :txtFuseQty.text,
                                       ACKeyFuseTypes    :
                                           [self getUnitData:txtFuseQty OfTableView:tblvFuses],
                                       
                                       ACKeyBoosterTypes : txtBooster.placeholder?txtBooster.placeholder:@""
                                       };
    return dictOptionalInfo;
    
}

-(NSMutableArray *)getUnitData:(UITextField*)textField OfTableView:(UITableView*)tblv
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [textField.text integerValue] ; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        
        UITableViewCell *cell = [tblv cellForRowAtIndexPath:indexPath];
        NSString  *size = @"";
        BOOL location   = true;
        
        for (UIView *view in  cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *txtField = (UITextField *)view;
                size = txtField.placeholder;
                
                //NSLog(@"%@",size);
            }
            else if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *button = (UIButton *)view;
                
                if (button.selected)
                {
                    if([button.titleLabel.text isEqualToString:@"Inside Equipment"])
                    {
                        location = true;
                    }
                    else
                    {
                        location =  false;
                    }
                    
                   // NSLog(@"%@",button.titleLabel.text);
                }
            }
        }
        
        if (size != nil)
        {
            NSDictionary  *dict;
            
            if(textField == txtFilterQty || textField == txtCFilterQty)
            {
                dict = @{
                         ACKeySizeOfFilter : size,
                         ACKeyLocationOfPart : @(location)
                         };
            }
            else if (textField == txtFuseQty || textField == txtCFuseQty)
            {
                
                dict = @{
                         ACKeyFuseType : size
                        };
            }
            
            [arr addObject:dict];
        }
    }
    
    return arr;
}
-(UITableView *)findParentTableViewOfView :(UIView *)vw
{
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = vw.superview;
    
    while(aView != nil)
    {
        if([aView isKindOfClass:[UITableView class]])
        {
            return (UITableView *)aView;
        }
        
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}

-(NSMutableDictionary *)makeDictFromPartInfo:(ACEACPartInfo *)part
{
    //NSLog(@"%@",part);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM, yyyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *date = [formatter dateFromString:part.manuDate];
    
    NSString *strDate = [NSString stringWithFormat:@"%@",date];
    
    [dict setValue:strDate           forKey:ACKeyMdate];
    [dict setValue:part.modelNumber  forKey:ACKeyMnumber];
    [dict setValue:part.serialNumber forKey:ACKeySerialNumber];
    [dict setValue:part.typeofunit   forKey:ACKeyTypeOfUnit];
    
    return dict;
}
#pragma mark - Webservcie Method
-(void)getManualFieldOfUnit
{
    if([ACEUtil reachable])
    {
        [self callWebservcieToGetManualField];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
    
}
-(void)callWebservcieToGetManualField
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                            ACKeyID : unitId,
                            UKeyEmployeeID : ACEGlobalObject.user.userID
                          };
    
    [ACEWebServiceAPI getUnitManualField:dict completionHandler:^(ACEAPIResponse *response, NSArray *arrUnitInfo)
    {
            [SVProgressHUD dismiss];
        
            if(response.code == RCodeSuccess)
            {
                arrManualFields = [NSMutableArray arrayWithArray:arrUnitInfo];
                [self setDataOfMAnualFieldsFromWebservice];
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
        
            /*else if (response.message)
            {
                [self showAlertWithMessage:response.message];
            }
            else
            {
                [self showAlertWithMessage:ACEUnknownError];
            }*/
        
    }];

}
-(void)updateUnitData
{
    if([ACEUtil reachable])
    {
        [self callWebserviceToUpdateUnitData];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)callWebserviceToUpdateUnitData
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           ACKeyID        : unitId,
                           PKeyParts      : [self makeDictionaryOfManualFields],
                           ACKeyNotes     : txtvNotes.text
                           };
    
    [ACEWebServiceAPI editUnitUnmatched:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *dict)
    {
        //[SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [self updateUnitImages:dict];
            
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
            [SVProgressHUD dismiss];
           //[self showAlertWithMessage:response.error.localizedDescription];
            [self showAlertWithMessage:ACEUnknownError];
        }
        
    }];
}
-(void)addNewUnitData
{
    if([ACEUtil reachable])
    {
        [self callWebserviceToAddNewUnitData];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)callWebserviceToAddNewUnitData
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           
                           CKeyID         : dictclientInfo[CKeyID],
                           GPlanTypeId    : dictclientInfo[GPlanTypeId],
                           SCHKeyAddressId: dictclientInfo[SCHKeyAddressId],
                           ACKeyNameOfUnit: dictclientInfo[ACKeyNameOfUnit],
                           PKeyParts      : [self makeDictionaryOfManualFields],
                           GAutoRenewal   : @(btnAutoRenew.isSelected),
                           GSpecialOffer  : @(btnSpecialOffer.isSelected),
                           ACKeyNotes     : txtvNotes.text,
                           ACKeyPaymentOption  :_paymentOption
                           };
    [ACEWebServiceAPI addNewUnit:dict completionHandler:^(ACEAPIResponse *response, NSString *acunitId)
     {
         
         if(response.code == RCodeSuccess)
         {
             [self sendUnitImages:acunitId];
             
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
             [SVProgressHUD dismiss];
            // [self showAlertWithMessage:response.error.localizedDescription];
             [self showAlertWithMessage:ACEUnknownError];
         }
         
     }];
}
-(void)sendUnitImages:(NSString *)acunitId
{
    NSDictionary *dict = @{
                           GKeyId : acunitId,
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           CKeyID  : dictclientInfo[CKeyID]
                           };
    
    [ACEWebServiceAPI addUnitImages:dict withImages:[self makeImageArray] andSplitImage:[self makeSplitImageArray] completionHandler:^(ACEAPIResponse *response, NSDictionary *dictUnitInfo)
    {
        [SVProgressHUD dismiss];
        
         if(response.code == RCodeSuccess)
         {
             [self openSummaryViewController:dictUnitInfo];
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
-(void)updateUnitImages:(NSDictionary *)dictInfo
{
    NSDictionary *dict = @{
                           GKeyId : dictInfo[ACKeyID],
                           UKeyEmployeeID : ACEGlobalObject.user.userID,
                           CKeyID  : dictInfo[CKeyID]
                           };
    
    [ACEWebServiceAPI UpdateUnitImages:dict withImages:[self makeImageArray] andSplitImage:[self makeSplitImageArray] completionHandler:^(ACEAPIResponse *response, NSDictionary *dictUnitInfo)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
            [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
            {
                [self openUnitListViewController];
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

-(NSMutableArray *)makeImageArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for(int i =0 ;i < arrUnitImage.count;i++)
    {
        ACEServiceImage *serviceImg = arrUnitImage[i];
        
        if(serviceImg.status == ACEImageStatusSet)
        {
            UIImage *compressImage;
            
//            if(serviceImg.imageURL)
//            {
//                NSIndexPath *path = arrImageIndex[i];
//                
//                cellImg = (ACEServiceImageCell *) [collv cellForItemAtIndexPath:path];
//                
//                compressImage = [cellImg.imgvService.image compressImages];
//            }
//            else
//            {
                compressImage = [serviceImg.image compressImages];
            //}
            
            NSDictionary *dict;
            
            if([unitType isEqualToString:GUnitTypeSplit])
            {
                if(compressImage)
                {

                    dict       = @{
                                       ACKeyUnitType : GUnitTypeHeating,
                                       ACKeyPictures : UIImagePNGRepresentation(compressImage)
                               };
                    [arr addObject:dict];
                }
            }
            else
            {
                if(compressImage)
                {
                    dict    = @{
                            ACKeyUnitType : unitType,
                            ACKeyPictures : UIImagePNGRepresentation(compressImage)
                            };
                    [arr addObject:dict];
                }
            }
            
        }
    }
    return arr;
}
-(NSMutableArray *)makeSplitImageArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for(int i =0 ;i < arrCoolingImage.count;i++)
    {
        ACEServiceImage *serviceImg = arrCoolingImage[i];
        
        if(serviceImg.status == ACEImageStatusSet)
        {
            UIImage *compressImage;
            
            NSDictionary *dict;
            
//            if(serviceImg.imageURL)
//            {
//                NSIndexPath *path = arrCoolingImage[i];
//                
//                cellCoolingImg = (ACEServiceImageCell *) [collvCooling cellForItemAtIndexPath:path];
            
//                compressImage = [cellCoolingImg.imgvService.image compressImages];
//            }
//            else
//            {
                compressImage = [serviceImg.image compressImages];
           // }

            if(compressImage)
            {
               dict             = @{
                                   ACKeyUnitType : GUnitTypeCooling,
                                   ACKeyPictures : UIImagePNGRepresentation(compressImage)
                                   };
                [arr addObject:dict];
            }
            
        }
    }
    return arr;
}
-(void)getPlanInfo
{
    if([ACEUtil reachable])
    {
        [self callwebserviceTogetPlanInfo];
    }
    else
    {
        [self showAlertWithMessage:ACENoInternet];
    }
}
-(void)callwebserviceTogetPlanInfo
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           GPlanTypeId : dictclientInfo[GPlanTypeId],
                           UKeyEmployeeID : ACEGlobalObject.user.userID
                           };
    
    [ACEWebServiceAPI getSpecialRateofPlan:dict completionHandler:^(ACEAPIResponse *response, NSDictionary *dictInfo)
     {
         [SVProgressHUD dismiss];
         
         if(response.code == RCodeSuccess)
         {
             [self setPaymentInfoView:dictInfo];
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
    }];
}
#pragma mark - CollectionView Image Helper Methods
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
                                    [self selectUnitImageFrom:UIImagePickerControllerSourceTypeCamera];
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:ACETextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectUnitImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
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

- (void)selectUnitImageFrom:(UIImagePickerControllerSourceType)sourceType
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
                     //[self showAlertWithMessage:ACEAllowAccessPhotoLibrary];
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
    
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType    = sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
         
         if (selectedCollv == collv)
         {
             if (arrUnitImage.count <= 4)
             {
                 ACEServiceImage *unitImage = [[ACEServiceImage alloc]initWithUIImage:selectedImage];
                 
                 unitImage.status = ACEImageStatusSet;
                 
                 [arrUnitImage replaceObjectAtIndex:imgIndexPath withObject:unitImage];
             }
         }
         else if(selectedCollv == collvCooling)
         {
             if (arrCoolingImage.count <= 4)
             {
                 ACEServiceImage *coolingImage = [[ACEServiceImage alloc]initWithUIImage:selectedImage];
        
                 coolingImage.status = ACEImageStatusSet;
                 
                 [arrCoolingImage replaceObjectAtIndex:imgSplitIndexPath withObject:coolingImage];
             }
         }
         
         [selectedCollv reloadData];
     }];
}

//- (void)prepareUnitImage:(ACEServiceImage *)selectedUnitImage
//{
//    selectedUnitImage.status = ACEImageStatusSet;
//    
//    [self uploadUnitImage:selectedUnitImage];
//    
//    [selectedCollv reloadData];
//}
//
//- (void)uploadUnitImage:(ACEServiceImage *)unitImage
//{
//    if([ACEUtil reachable])
//    {
//        unitImage.status = ACEImageStatusUploding;
//        unitImage.status = ACEImageStatusUploded;
//        [selectedCollv reloadData];
//    }
//    else
//    {
//        [self showAlertWithMessage:ACENoInternet];
//    }
//}
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
#pragma mark - tableview delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblvFilter)
    {
        return [txtFilterQty.text integerValue];
    }
    else if (tableView == tblvFuses)
    {
        return [txtFuseQty.text integerValue];
    }
    else if (tableView == tblvCFilter)
    {
        return [txtCFilterQty.text integerValue];
    }
    else if (tableView == tblvCFuses)
    {
        return [txtCFuseQty.text integerValue];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    filterCell.selectionStyle = UITableViewCellSelectionStyleNone;
    fuseCell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    if (tableView == tblvFilter)
    {
        filterCell = [tableView dequeueReusableCellWithIdentifier:@"filterCell" forIndexPath:indexPath];
        
        filterCell.lblFilterLocation.text = [NSString stringWithFormat:@"Filter Location %ld",(long)indexPath.item+1];
        filterCell.lblFilterSize.text = [NSString stringWithFormat:@"Filter Size %ld",(long)indexPath.item + 1];
        
        filterCell.btnInsideEquipment.selected = YES;
        
        if(UnitDetail.arrPartsInfo.count > 0)
        {
            ACEACPartInfo *info = UnitDetail.arrPartsInfo[0];
            
            if(info.arrFilter.count > indexPath.row)
            {
            
                filterCell.txtFilterSize.text = info.arrFilter[indexPath.row][ACKeyFilterSize];
                
                filterCell.txtFilterSize.placeholder =[ info.arrFilter[indexPath.row][PKeyId]stringValue];
                
                if([info.arrFilter[indexPath.row][ACKeyLocOfFilter]boolValue])
                {
                    filterCell.btnInsideEquipment.selected = YES;
                    filterCell.btnInsideSpace.selected = NO;
                }
                else
                {
                    filterCell.btnInsideSpace.selected = YES;
                    filterCell.btnInsideEquipment.selected = NO;
                }
            }
        }
        else if (arrManualFields.count > 0)
        {
            NSDictionary *dict = arrManualFields[indexPath.section];
            
            if([dict[ACKeyUnitType]isEqualToString:GUnitTypeHeating] || [dict[ACKeyUnitType]isEqualToString:GUnitTypePackaged])
            {
                NSArray * arr = dict[ACKeyFilter];
                
                if(arr.count > indexPath.row)
                {
                    filterCell.txtFilterSize.text = arr[indexPath.row][ACKeyFilterSize];
                    
                    filterCell.txtFilterSize.placeholder = [arr[indexPath.row][PKeyId]stringValue];
                    
                    if([arr[indexPath.row][ACKeyLocOfFilter]boolValue])
                    {
                        filterCell.btnInsideEquipment.selected = YES;
                        filterCell.btnInsideSpace.selected     = NO;
                    }
                    else
                    {
                        filterCell.btnInsideSpace.selected     = YES;
                        filterCell.btnInsideEquipment.selected = NO;
                    }
                }
            }
        }
        return filterCell;
        
    }
    else if (tableView == tblvFuses)
    {
        fuseCell = [tableView dequeueReusableCellWithIdentifier:@"fuseCell" forIndexPath:indexPath];
        fuseCell.lblFuseType.text = [NSString stringWithFormat:@"Fuse Type %ld",(long)indexPath.item+1];
        
        if(UnitDetail.arrPartsInfo.count > 0)
        {
            ACEACPartInfo *info  = UnitDetail.arrPartsInfo[0];
            if(info.arrFuse.count > indexPath.row)
            {
                fuseCell.txtFuseType.text = info.arrFuse[indexPath.row][ACKeyFuseType];
                
                fuseCell.txtFuseType.placeholder = [info.arrFuse[indexPath.row][PKeyId]stringValue];
            }
            
        }
        else if (arrManualFields.count > indexPath.row)
        {
            NSDictionary *dict = arrManualFields[indexPath.section];
            
            if([dict[ACKeyUnitType]isEqualToString:GUnitTypeHeating] || [dict[ACKeyUnitType]isEqualToString:GUnitTypePackaged])
            {
                NSArray * arr = dict[ACKeyFuses];
                if(arr.count > indexPath.row)
                {
                    fuseCell.txtFuseType.text = arr[indexPath.row][ACKeyFuseType];
                    
                    fuseCell.txtFuseType.placeholder = [arr[indexPath.row][PKeyId] stringValue];
                }

            }
            
        }
        return fuseCell;
    }
    else if (tableView == tblvCFilter)
    {
        filterCell = [tableView dequeueReusableCellWithIdentifier:@"coolingFilterCell" forIndexPath:indexPath];
        filterCell.lblFilterLocation.text = [NSString stringWithFormat:@"Filter Location %ld",(long)indexPath.item+1];
        filterCell.lblFilterSize.text = [NSString stringWithFormat:@"Filter Size %ld",(long)indexPath.item + 1];
        
        filterCell.btnInsideEquipment.selected = YES;
        
        if(UnitDetail.arrPartsInfo.count > 1)
        {
            ACEACPartInfo *info = UnitDetail.arrPartsInfo[1];
            
            if(info.arrFilter.count > indexPath.row)
            {
                filterCell.txtCFilterSize.text = info.arrFilter[indexPath.row][ACKeyFilterSize];
                
                filterCell.txtCFilterSize.placeholder = [info.arrFilter[indexPath.row][PKeyId] stringValue];
                
                if([info.arrFilter[indexPath.row][ACKeyLocOfFilter]boolValue])
                {
                    filterCell.btnInsideEquipment.selected = YES;
                    filterCell.btnInsideSpace.selected     = NO;
                }
                else
                {
                    filterCell.btnInsideSpace.selected     = YES;
                    filterCell.btnInsideEquipment.selected = NO;
                }
            }
        }
        else if (arrManualFields.count > 1)
        {
            NSDictionary *dict = arrManualFields[1];
            
            if([dict[ACKeyUnitType]isEqualToString:GUnitTypeCooling])
            {
                NSArray * arr = dict[ACKeyFilter];
                if(arr.count > indexPath.row)
                {
                    filterCell.txtCFilterSize.text = arr[indexPath.row][ACKeyFilterSize];
                    filterCell.txtCFilterSize.placeholder = [arr[indexPath.row][PKeyId]stringValue];
                    
                    if([arr[indexPath.row][ACKeyLocOfFilter]boolValue])
                    {
                        filterCell.btnInsideEquipment.selected = YES;
                        filterCell.btnInsideSpace.selected     = NO;
                    }
                    else
                    {
                        filterCell.btnInsideSpace.selected     = YES;
                        filterCell.btnInsideEquipment.selected = NO;
                    }

                }
            }
        }

        return filterCell;
    }
    else if (tableView == tblvCFuses)
    {
        fuseCell = [tableView dequeueReusableCellWithIdentifier:@"coolingFuseCell" forIndexPath:indexPath];
        fuseCell.lblFuseType.text = [NSString stringWithFormat:@"Fuse Type %ld",(long)indexPath.item+1];
        
        if(UnitDetail.arrPartsInfo.count > 1)
        {
            ACEACPartInfo *info  = UnitDetail.arrPartsInfo[1];
            if(info.arrFuse.count > indexPath.row)
            {
               fuseCell.txtCFuseType.text = info.arrFuse[indexPath.row][ACKeyFuseType];
                
                fuseCell.txtCFuseType.placeholder = [info.arrFuse[indexPath.row][PKeyId]stringValue];
            }
            
        }
        else if (arrManualFields.count > 1)
        {
            NSDictionary *dict = arrManualFields[1];
            if([dict[ACKeyUnitType]isEqualToString:GUnitTypeCooling])
            {
                NSArray * arr = dict[ACKeyFuses];
                
                if(arr.count > indexPath.row)
                {
                    fuseCell.txtCFuseType.text = arr[indexPath.row][ACKeyFuseType];
                    
                     fuseCell.txtCFuseType.placeholder = [arr[indexPath.row][PKeyId]stringValue];
                }
                
            }
            
        }
        return fuseCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionView Delegate Method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == collv)
    {
        return arrUnitImage.count;
    }
    else if(collectionView == collvCooling)
    {
        return arrCoolingImage.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collv)
    {
        cellImg = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
        
        cellImg.serviceImage = arrUnitImage[indexPath.item];
        
//        ACEServiceImage *img = arrUnitImage[indexPath.item];
//        
//        if(img.imageURL)
//        {
//            [cellImg.imgvService setImageWithURL:img.imageURL];
//            
////            NSData *imageData = [NSData dataWithContentsOfURL:img.imageURL];
////            UIImage *image = [UIImage imageWithData:imageData];
////            //NSLog(@"imge %@",image);
////            cellImg.imgvService.image = image;
////            img.image = image;
////            
////            if(![arrImageIndex containsObject:indexPath])
////                    [arrImageIndex addObject:indexPath];
//            
//        }
//        else
//        {
//            cellImg.serviceImage = img;
//        }
        return cellImg;
    }
    else
    {
        cellCoolingImg = [collectionView dequeueReusableCellWithReuseIdentifier:@"coolingImgCell" forIndexPath:indexPath];
        
        cellCoolingImg.serviceImage = arrCoolingImage[indexPath.item];
        
//        ACEServiceImage *img = arrCoolingImage[indexPath.item];
//        
//        if(img.imageURL)
//        {
//            NSData *imageData = [NSData dataWithContentsOfURL:img.imageURL];
//            UIImage *image = [UIImage imageWithData:imageData];
//           // NSLog(@"imge %@",image);
//            cellCoolingImg.imgvService.image = image;
//            img.image = image;
//            
//            //[cellCoolingImg.imgvService setImageWithURL:img.imageURL];
//            //img.image = cellCoolingImg.imgvService.image;
//            
//            if(![arrCoolingImageIndex containsObject:indexPath])
//                [arrCoolingImageIndex addObject:indexPath];
//            
//        }
//        else
//        {
//            cellCoolingImg.serviceImage = img;
//        }
        return cellCoolingImg;
    }
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int numberOfCellInRow = 4;
    CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
    return CGSizeMake(cellWidth*1.2, cellWidth*1.3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collv)
    {
        selectedCollv = collv;
        imgIndexPath = indexPath.item;
        ACEServiceImage *unitImage = arrUnitImage[indexPath.item];
        [self setStatusOfImage:unitImage];
    }
    else if(collectionView == collvCooling)
    {
        selectedCollv = collvCooling;
        imgSplitIndexPath = indexPath.item;
        ACEServiceImage *coolingImage = arrCoolingImage[indexPath.item];
        [self setStatusOfImage:coolingImage];
    }
}

#pragma mark - UITextFiled Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtFilterQty)
    {
        selectedTxtTag = textField.tag;
        selectedTableView = tblvFilter;
        [self openPopupView];
        return NO;
    }
    else if (textField == txtFuseQty)
    {
        selectedTxtTag = textField.tag;
        selectedTableView = tblvFuses;
        [self openPopupView];
        return NO;

    }
    else if ( textField == txtCFilterQty)
    {
        selectedTxtTag = textField.tag;
        selectedTableView = tblvCFilter;
        [self openPopupView];
        return NO;

    }
    else if (textField == txtCFuseQty)
    {
        selectedTxtTag = textField.tag;
        selectedTableView = tblvCFuses;
        [self openPopupView];
        return NO;
    }
    else
    {
        selectedTextField = textField;
        
        if(textField == txtBooster)
        {
            [self openPartController:@"3"];
        }
        else if (textField == txtCBooster)
        {
            [self openPartController:@"3"];
        }
        else
        {
            UIView *vw = textField.superview.superview;
            
            if([vw isKindOfClass:[ACEFilterCell class]])
            {
                 [self openPartController:@"1"];
            }
            else if([vw isKindOfClass:[ACEFuseCell class]])
            {
                [self openPartController:@"2"];
            }
        }
    
        return NO;
    }
 
}
/*-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtFilterQty || textField == txtFuseQty || textField == txtCFilterQty || textField == txtCFuseQty)
    {
        [textField resignFirstResponder];
        
        selectedTxtTag = textField.tag;
        
        ChooseQtyPopupViewController *qtyPopup  = [ACEGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ChooseQtyPopupViewController"];
        qtyPopup.providesPresentationContextTransitionStyle = YES;
        qtyPopup.definesPresentationContext = YES;
        [qtyPopup setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        qtyPopup.delegate = self;
        [self presentViewController:qtyPopup animated:YES completion:nil];
    }
    else
    {
        
    }
}*/

#pragma mark - Choosse Quantity Delegate Method
-(void)ChooseQuantity:(NSString *)qty
{
    UITextField *tf = (UITextField *)[self.view viewWithTag:selectedTxtTag];
    tf.text = qty;
    [selectedTableView reloadData];
    [self setframesOfView];
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTap:(id)sender
{
    //[self makeDictionaryOfManualFields];
    
    if ([headingTitle isEqualToString:ACEAddUnitTitle])
    {
        [self addNewUnitData];
    }
    else
    {
        [self updateUnitData];
    }
    
}

- (IBAction)btnPaymentMethodTap:(UIButton *)sender
{
    if (sender == btnAutoRenew)
    {
        isSpecialOffer           = false;
        btnAutoRenew.selected    = !btnAutoRenew.selected;
        btnSpecialOffer.selected = NO;
        
        if(btnAutoRenew.selected)
        {
           vwSpOffer.hidden         = YES;
        }
        else
        {
            vwSpOffer.hidden         = NO;
        }
       // btnSpecialOffer.hidden   = YES;
    }
    else if (sender == btnSpecialOffer)
    {
        isSpecialOffer           = true;
        btnAutoRenew.selected    = NO;
        btnSpecialOffer.selected = !btnSpecialOffer.selected ;
        if(btnSpecialOffer.selected)
        {
            btnAutoRenew.hidden         = YES;
        }
        else
        {
            btnAutoRenew.hidden         = NO;
        }
        
        //btnSpecialOffer.hidden   = NO;
    }
}

- (IBAction)filterLocationTap:(UIButton *)sender
{
    //CGPoint pointInSuperview = [btn.superview convertPoint:btn.center toView:tblv];
    
   // NSIndexPath *indexPath = [tblv indexPathForRowAtPoint:pointInSuperview]
    
    CGPoint buttonPosition = [sender.superview convertPoint:sender.center toView:tblvFilter];
    NSIndexPath *indexPath = [tblvFilter indexPathForRowAtPoint:buttonPosition];
    ACEFilterCell * cell  = (ACEFilterCell*) [tblvFilter cellForRowAtIndexPath:indexPath];
    
    CGPoint splitButtonPosition = [sender.superview convertPoint:sender.center toView:tblvCFilter];
    NSIndexPath *splitIndexPath = [tblvCFilter indexPathForRowAtPoint:splitButtonPosition];
    ACEFilterCell *splitCell = (ACEFilterCell*) [tblvCFilter cellForRowAtIndexPath:splitIndexPath];
    
    if (sender == cell.btnInsideEquipment)
    {
        sender.selected                  = YES;
        cell.btnInsideSpace.selected     = NO;
    }
    else if (sender == cell.btnInsideSpace)
    {
        cell.btnInsideEquipment.selected = NO;
        cell.btnInsideSpace.selected = YES;
    }
    else if (sender == splitCell.btnInsideEquipment)
    {
        splitCell.btnInsideEquipment.selected = YES;
        splitCell.btnInsideSpace.selected     = NO;
    }
    else if (sender == splitCell.btnInsideSpace)
    {
        splitCell.btnInsideEquipment.selected = NO;
        splitCell.btnInsideSpace.selected = YES;
    }
}


- (IBAction)btnDeleteTap:(UIButton *)sender
{
    CGPoint pointInSuperview = [sender.superview convertPoint:sender.center toView:collv];
    
    NSIndexPath *indexPath = [collv indexPathForItemAtPoint:pointInSuperview];
    
    ACEServiceImage *unitImage = arrUnitImage[indexPath.item];
    unitImage.image            = [UIImage imageNamed:@"defimage"];
    unitImage.status           = ACEImageStatusPlaceholder;
    unitImage.imageURL         = nil;
    
    [arrUnitImage replaceObjectAtIndex:indexPath.item withObject:unitImage];
    
    [collv reloadData];
}

- (IBAction)btnDeleteCooling:(UIButton *)sender
{
    CGPoint pointInSuperview = [sender.superview convertPoint:sender.center toView:collvCooling];
    
    NSIndexPath *indexPath = [collvCooling indexPathForItemAtPoint:pointInSuperview];
    
    ACEServiceImage *coolingImage = arrCoolingImage[indexPath.item];
    
    coolingImage.image          = [UIImage imageNamed:@"defimage"];
    coolingImage.status         = ACEImageStatusPlaceholder;
    coolingImage.imageURL       = nil;
    
    [arrCoolingImage replaceObjectAtIndex:indexPath.item withObject:coolingImage];

    [collvCooling reloadData];
}
#pragma mark - SelectedPart delegate method
-(void)SelectedPartName:(ACEParts *)part
{
    
    selectedTextField.text = [NSString stringWithFormat:@"%@ %@",part.partName,part.partSize];
    selectedTextField.placeholder = part.ID;
}

@end
