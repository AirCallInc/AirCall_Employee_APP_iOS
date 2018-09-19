//
//  SalesPersonNotiDetailController.h
//  AircallEmployee
//
//  Created by ZWT111 on 24/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface SalesPersonNotiDetailController : ACEViewController

@property NSString *notificationId  ;
@property NSString *salesVisitId    ;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress;

@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnMobileNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnOfficeNumber;

@end
