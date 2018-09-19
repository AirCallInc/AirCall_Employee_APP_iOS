//
//  AddOrderPaymentViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 08/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface AddOrderPaymentViewController : ACEViewController

@property NSMutableArray *arrSelectedParts  ;
@property ACEAddress     *address           ;
@property NSString       *recomm            ;
@property NSString       *clientId          ;
@property NSString       *ccEmail           ;
@property NSString       *selectedOption    ;
@property BOOL            isEmailToClient   ;

@end
