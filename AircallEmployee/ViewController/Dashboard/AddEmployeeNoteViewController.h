//
//  AddEmployeeNoteViewController.h
//  AircallEmployee
//
//  Created by ZWT111 on 01/07/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEViewController.h"

@interface AddEmployeeNoteViewController : ACEViewController

@property ACEScheduleDetail *scheduleDetail        ;

@property NSMutableArray    *arrselectedPart       ;
@property NSMutableArray    *arrselectedUnits      ;
@property NSMutableArray    *arrrequestedParts     ;
@property NSMutableArray    *arrrequestedNewPart   ;
@property NSMutableArray    *arrserviceImages      ;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvBg    ;

@property UIImage           *signature              ;

@property NSString          *email                  ;
@property NSString          *ccEmail                ;
@property NSString          *workPerformed          ;
@property NSString          *recomm                 ;
@property NSString          *startTime              ;
@property NSString          *endTime                ;
@property NSString          *startReportLattitude   ;
@property NSString          *startReportLongitude   ;

@property BOOL              isWorkNoteDone          ;

@property (strong, nonatomic) IBOutlet SAMTextView *txtEmpNotes  ;
@property (strong, nonatomic) IBOutlet UILabel *lblEndTime       ;

@end
