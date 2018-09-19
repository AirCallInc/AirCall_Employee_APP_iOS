//
//  ExpYearMonthPopupViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 22/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@protocol ExpYearMonthPopupViewControllerDelegate <NSObject>

-(void)selectedValue:(NSString *)value forOption:(NSString *)option;

@end

@interface ExpYearMonthPopupViewController : ACEViewController

@property (strong, nonatomic) IBOutlet UIView       *vwPopUp;
@property (strong, nonatomic) IBOutlet UILabel      *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView  *tblvData;

@property NSString *selectedOption;

@property (nonatomic)id<ExpYearMonthPopupViewControllerDelegate> delegate;

@end
