//
//  AddEmployeeNoteViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 01/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "AddEmployeeNoteViewController.h"

@interface AddEmployeeNoteViewController ()<ZWTTextboxToolbarHandlerDelegate>

@property ZWTTextboxToolbarHandler *handler;

@property NSDictionary *imgDict;
@property AppDelegate  *delegate;


@end

@implementation AddEmployeeNoteViewController

@synthesize arrserviceImages,arrselectedPart,arrselectedUnits,arrrequestedParts,arrrequestedNewPart,lblEndTime,email,ccEmail,startTime,endTime,scheduleDetail,isWorkNoteDone,workPerformed,recomm,txtEmpNotes,signature,scrlvBg,imgDict,handler,startReportLattitude,startReportLongitude,delegate;

#pragma mark - ACEViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
#pragma mark - Helper Method
-(NSMutableArray *)makeUnitArray
{
    NSMutableArray *arrUnit = [[NSMutableArray alloc]init];
    for(int i=0 ; i< scheduleDetail.unitList.count;i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        NSDictionary *unit = scheduleDetail.unitList[i];
        NSString *uid =  unit[SDKeyUnitId];
        
        [dict setValue:uid forKey:SRKeyUnitId];
        
        BOOL isComplete = NO;
        for(NSDictionary *selectedDict in arrselectedUnits)
        {
            
            if([selectedDict[SRKeyUnitId] isEqualToString:uid])
            {
                isComplete = YES;
                break;
            }
        }
        [dict setValue:@(isComplete) forKey:SRKeyIsCompleted];

        NSMutableArray *arrPart = [[NSMutableArray alloc]init];
        
        /*for(int j =0 ; j< [scheduleDetail.unitList[i][SDKeyPartsList] count];j++)
        {
            NSDictionary *udict = scheduleDetail.unitList[i];
            
            ACEParts *part = scheduleDetail.unitList[i][SDKeyPartsList][j];
            
            for(NSDictionary *dict in arrselectedPart)
            {
                ACEParts * selectedPart = dict[GKeyPart];
                int qty                 = [dict[SRKeyPartQnty] intValue];
                
                if([selectedPart.ID isEqualToString:part.ID] && [dict[SRKeyUnitId] isEqualToString:udict[SRKeyUnitId]])
                {
                    NSDictionary *dict = @{
                                           SRKeyPartId      : part.ID,
                                           SRKeyPartQnty    : @(qty)
                                           };
                
                    [arrPart addObject:dict];
                    break;
                }
            }
            
        }*/
        for(NSDictionary *dict in arrselectedPart)
        {
            if([dict[SRKeyUnitId] isEqualToString:uid])
            {
                ACEParts * selectedPart = dict[GKeyPart];
                int qty                 = [dict[SRKeyPartQnty] intValue];
                
                NSDictionary *dict = @{
                                       SRKeyPartId      : selectedPart.ID,
                                       SRKeyPartQnty    : @(qty)
                                       };
                
                [arrPart addObject:dict];
            }
        }
        [dict setValue:arrPart forKey:SRKeyServiceUnitParts];
        [arrUnit addObject:dict];
    }
    return arrUnit;
}
-(NSMutableArray *)makeRequestedPartArray
{
    
    NSMutableArray *arrRequest = [[NSMutableArray alloc]init];
    
    [arrrequestedParts enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop)
    {
        ACEParts *part = dict[SRKeySelectedPart];
        
        NSMutableArray *unitarr = dict[SRKeyUnitArray];
        
        NSString *notes = dict[SRKeyReqPartNotes];
        
        [unitarr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull uDict, NSUInteger idx, BOOL * _Nonnull stop)
        {
                NSDictionary *dict = @{
                                   SRKeyReqUnitId   :uDict[SRKeyReqUnitId],
                                   SRKeyReqPartId   :part.ID,
                                   SRKeyReqPartQnty :uDict[SRKeyReqPartQnty],
                                   SRKeyReqPartNotes :notes,
                                   SRKeyReqPartName : part.partName,
                                   SRKeyReqPartSize : part.partSize,
                                   SRKeyReqPartDes  : part.partInfo
                                    };
            [arrRequest addObject:dict];
            
        }];
        
    }];
    
    return arrRequest;
}
-(NSMutableArray *)makeImageArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for(int i =0 ;i < arrserviceImages.count;i++)
    {
        ACEServiceImage *serviceImg = arrserviceImages[i];
        
        if(serviceImg.status == ACEImageStatusSet)
        {
            UIImage *compressImage = [serviceImg.image compressImages];
            [arr addObject:UIImagePNGRepresentation(compressImage)];
        }
    }
    return arr;
}
-(void)prepareView
{
    lblEndTime.text            = endTime    ;
    handler.showNextPrevious   = NO         ;
    delegate                   = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    handler        = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:[NSMutableArray arrayWithObjects:txtEmpNotes, nil] andScroll:scrlvBg];
}

#pragma mark - Webservice Method
-(void)sendServiceReportData
{
    [SVProgressHUD show];
    NSDictionary *dict;
    
    if (isWorkNoteDone)
    {
        dict = @{
                 SRKeyEmployeeId      : ACEGlobalObject.user.userID,
                 SRKeyID              : scheduleDetail.ID,
                 SDKeyScheduleStartTime : startTime,
                 SDKeyScheduleEndTime   : endTime,
                 SRKeyIsWorkNoteDone  : @(isWorkNoteDone),
                 SRKeyWorkPerformed   : workPerformed,
                 SRKeyRecomm          : recomm,
                 SRKeyEmpNotes        : txtEmpNotes.text,
                 SRKeyEmail           : @[email,ccEmail],
                 SRKeyCCEmail         : ccEmail,
                 SRKeyRequestedPart   : @[],
                 SRKeyUnitList        : @[],
                 SRKeyStartReportLattitude : startReportLattitude,
                 SRKeyStartReportLongitude : startReportLongitude,
                 SRKeyEndReportLattitude   : delegate.latitude,
                 SRKeyEndReportLongitude   : delegate.longitude
                 };

        
        signature = [[UIImage alloc]init];
    
        imgDict = @{
                    SRKeySignature       : signature,
                    SRKeyPictures        :@[]
                    };
    }
    else
    {
            dict = @{
                           SRKeyEmployeeId      : ACEGlobalObject.user.userID,
                           SRKeyID                    : scheduleDetail.ID,
                           SDKeyScheduleStartTime     : startTime,
                           SDKeyScheduleEndTime       : endTime,
                           SRKeyIsWorkNoteDone  : @(isWorkNoteDone),
                           SRKeyWorkPerformed   : workPerformed,
                           SRKeyRecomm          : recomm,
                           SRKeyEmpNotes        : txtEmpNotes.text,
                           SRKeyEmail           : @[email,ccEmail],
                           SRKeyCCEmail         : ccEmail,
                           SRKeyRequestedPart   : [self makeRequestedPartArray],
                           SRKeyUnitList        : [self makeUnitArray],
                           SRKeyStartReportLattitude : startReportLattitude,
                           SRKeyStartReportLongitude : startReportLongitude,
                           SRKeyEndReportLattitude   : delegate.latitude,
                           SRKeyEndReportLongitude   : delegate.longitude
                        };
        
        if(!signature)
        {
            signature = [[UIImage alloc]init];
            
        }
            imgDict   = @{
                              SRKeySignature       : signature,
                              SRKeyPictures        :[self makeImageArray]
                         };
    }
    
    [ACEWebServiceAPI submitServiceReportData:dict completionHandler:^(ACEAPIResponse *response, NSString *successId)
    {
        //[SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [self sendImageData:successId];
           
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
            [self showAlertWithMessage:ACEUnknownError];
            //[self showAlertWithMessage:response.error.localizedDescription];
        }
    }];
    
}
-(void)sendImageData:(NSString *)successId
{
    
    NSDictionary *dict = @{
                           @"Id" : successId
                           };
    
    if([ACEUtil reachable])
    {
        [ACEWebServiceAPI submitServiceReportImage:dict withImage:imgDict completionHandler:^(ACEAPIResponse *response)
         {
             [SVProgressHUD dismiss];
            
             if(response.code == RCodeSuccess)
             {
                 [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  }];
             }
             else
             {
                 [self showAlertFromWithMessageWithSingleAction:ACEUnknownError andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }];
             }
        }];
        
    }
}

#pragma mark - Event Method
- (IBAction)btnCancelTap:(id)sender
{
    
}
- (IBAction)btnSubmitTap:(id)sender
{
    if (![txtEmpNotes.text isEqualToString:@""])
    {
        if([ACEUtil reachable])
        {
            [self sendServiceReportData];
        }
        else
        {
            [self showAlertWithMessage:ACENoInternet];
        }
    }
    else
    {
        [self showAlertWithMessage:ACEBlankEmployeeNotes];
    }
}

@end
