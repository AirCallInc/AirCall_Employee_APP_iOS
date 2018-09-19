//
//  AddUnitPaymentViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 17/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface AddUnitPaymentViewController : ACEViewController

@property NSArray        *arrUnitInfo       ;
@property ACEAddress     *address           ;

@property float     totalAmount     ;
@property NSString  *clientId       ;
@property NSString  *paymentOption  ;
@property NSString  *CCEmail        ;

@end
