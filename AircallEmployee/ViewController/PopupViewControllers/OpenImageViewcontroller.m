//
//  OpenImageViewcontroller.m
//  AircallEmployee
//
//  Created by ZWT111 on 30/08/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "OpenImageViewcontroller.h"

@interface OpenImageViewcontroller ()
@property (strong, nonatomic) IBOutlet UIView *vwPopup;

@end

@implementation OpenImageViewcontroller
@synthesize vwPopup,imgv,unitImage,arrImages,index;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandler)];
    
    [rightGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:rightGestureRecognizer];
    
    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandler)];
    
    [leftGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self.view addGestureRecognizer:leftGestureRecognizer];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopup.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^
                    {
                         vwPopup.transform = CGAffineTransformIdentity;
                         vwPopup.hidden    = NO;
                         if(unitImage.imageURL)
                         {
                             [imgv setImageWithURL:unitImage.imageURL];
                         }
                         else
                         {
                             imgv.image = unitImage.image;
                         }
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)rightSwipeHandler
{
    index --;
    
    if(arrImages.count > index && index >= 0)
    {
        if([arrImages[index] isKindOfClass:[ACEServiceImage class]])
        {
            unitImage = arrImages[index];
        }
        else
        {
            unitImage.imageURL  = arrImages[index];
        }
        if(unitImage.imageURL)
        {
            [UIView transitionWithView:self.vwPopup
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [imgv setImageWithURL:unitImage.imageURL];
                                
                            } completion:nil];
            
        }
        else
        {
            [UIView transitionWithView:self.view
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^
             {
                 imgv.image = unitImage.image;
                 
             } completion:nil];
            
        }
    }
    
}
-(void)leftSwipeHandler
{
 
    index ++;
    if(arrImages.count > index)
    {
        if([arrImages[index] isKindOfClass:[ACEServiceImage class]])
        {
            unitImage = arrImages[index];
        }
        else
        {
            unitImage.imageURL  = arrImages[index];
        }
        if(unitImage.imageURL)
        {
            [UIView transitionWithView:self.vwPopup
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [imgv setImageWithURL:unitImage.imageURL];

                            } completion:nil];
            
        }
        else
        {
            [UIView transitionWithView:self.view
                              duration:1.0f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^
                            {
                                imgv.image = unitImage.image;
                                
                            } completion:nil];

        }
    }
    
}
#pragma mark - Event Method
- (IBAction)btnCloseTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
