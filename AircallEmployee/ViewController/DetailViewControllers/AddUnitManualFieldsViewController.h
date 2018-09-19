//
//  AddUnitManualFieldsViewController.h
//  AircallEmployee
//
//  Created by Manali on 01/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUnitManualFieldsViewController : ACEViewController

@property NSString * headingTitle           ;
@property NSString * unitType               ;
@property NSString * unitId                 ;
@property BOOL       shouldCallWebservice   ;
@property int        isMatched              ;
@property ACEACUnit * UnitDetail            ;
@property NSString  * matchedUnittypeId     ;
@property NSString  * paymentOption         ;

@property NSMutableArray * arrModelSerial   ;
@property NSMutableArray * arrUnitExtraInfo ;
@property NSDictionary   * dictclientInfo   ;

@property BOOL isHeatingMatched;

@end
