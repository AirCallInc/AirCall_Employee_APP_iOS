//
//  ChangePasswordViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 26/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface ChangePasswordViewController : ACEViewController

@property (strong, nonatomic) IBOutlet UITextField *txtfOldPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtfNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtfConfirmPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrlv;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;

@end
