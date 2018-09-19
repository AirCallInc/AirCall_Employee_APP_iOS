//
//  AddUnitACHeatingViewController.h
//  AircallEmployee
//
//  Created by Manali on 30/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

/* ***************Notes**************/
//isMatched variable status
// 1 for not editable
// 2 for partial editable
// 3 for full editable
/* ***************Notes**************/

#import <UIKit/UIKit.h>

@interface AddUnitACHeatingViewController : ACEViewController

@property int        isMatched              ;
@property BOOL       shouldCallWebservice   ;

@property NSString * unitType           ;
@property NSString * unitId             ;
@property NSString * headingTitle       ;

@property NSMutableArray * arrUnitInfo      ;
@property NSMutableArray * arrModelSerial   ;
@property ACEACUnit      * unitDetailFull   ;
@property NSDictionary   * dictClientInfo   ;
@property NSString       * paymentOption    ;

@end
