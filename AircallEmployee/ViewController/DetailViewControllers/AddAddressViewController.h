//
//  AddAddressViewController.h
//  AircallEmployee
//
//  Created by Manali on 13/06/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddAddressViewControllerDelegate <NSObject>
-(void)addedAddress:(NSDictionary*)dict;
@end
@interface AddAddressViewController : UIViewController
@property  id<AddAddressViewControllerDelegate> delegate;
@end
