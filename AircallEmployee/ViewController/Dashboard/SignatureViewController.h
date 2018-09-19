//
//  SignatureViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 31/05/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"
@protocol SignatureCaptured


-(void)Signature:(UIImage *)signature;
    
@end
@interface SignatureViewController : ACEViewController

@property (weak) id<SignatureCaptured> delegate;

@end
