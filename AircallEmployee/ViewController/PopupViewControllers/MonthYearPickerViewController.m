//
//  MonthYearPickerViewController.m
//  AircallEmployee
//
//  Created by ZWT111 on 14/10/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "MonthYearPickerViewController.h"

@interface MonthYearPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView       *vwPopUp;
@property (strong, nonatomic) IBOutlet UIPickerView *mnthYearPicker;
@property (strong, nonatomic) IBOutlet UIButton     *btnOk;

@property NSMutableArray *monthArray ;
@property NSMutableArray *yearArray  ;
@property NSInteger currentYear      ;
@property NSInteger currentMnth      ;

@property NSInteger selectedMonth    ;
@property NSInteger selectedYear     ;
@property NSCalendar *calender       ;
@property NSDateComponents *components;

@end

@implementation MonthYearPickerViewController
@synthesize mnthYearPicker,vwPopUp,monthArray,yearArray,currentYear,selectedYear,selectedMonth,currentMnth,calender,components,btnOk,showDate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    vwPopUp.hidden = YES;
    
    monthArray     = [[NSMutableArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"Jun",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    
    NSDate *currentDate = [NSDate date];
    calender = [NSCalendar currentCalendar];
    
    components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    currentMnth   =  [components month]; //gives you month
    currentYear   =  [components year];//gives you year
    
    if(showDate)
    {
        components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:showDate]; // Get necessary date components
    }
    
    selectedMonth = [components month];
    selectedYear  = [components year];
    
    yearArray     = [[NSMutableArray alloc]init];
    
    for (NSInteger i=1980; i<=currentYear; i++)
    {
        NSNumber *num = [NSNumber numberWithInteger:i];
        [yearArray addObject:num];
    }
   /* [mnthYearPicker selectRow:yearArray.count - 1 inComponent:1 animated:YES];
    [mnthYearPicker selectRow:currentMnth-1 inComponent:0 animated:YES];*/
    int yearIndex = (int)[yearArray indexOfObject:[NSNumber numberWithInteger:selectedYear]];
    
    [mnthYearPicker selectRow:yearIndex inComponent:1 animated:YES];
    [mnthYearPicker selectRow:selectedMonth-1 inComponent:0 animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    vwPopUp.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwPopUp.transform = CGAffineTransformIdentity;
                         vwPopUp.hidden    = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Event Method
- (IBAction)btnOkTap:(id)sender
{
    selectedYear   = [[yearArray objectAtIndex:[mnthYearPicker selectedRowInComponent:1]]integerValue];
    selectedMonth  = [mnthYearPicker selectedRowInComponent:0]+1;
   
    components     = [[NSDateComponents alloc]init];
    
    [components setYear  :selectedYear];
    [components setMonth :selectedMonth];
    [components setDay   :1];
    [components setHour  :18];
    [components setMinute:30];
    [components setSecond:00];
    
    //NSLog(@"Components : %@",components);
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *selectedDate = [gregorian dateFromComponents:components];
   // NSLog(@"selected Date :%@",selectedDate);
    
    if(selectedYear == currentYear && selectedMonth > currentMnth)
    {
        [self showAlertWithMessage:ACEInvalidManufactureDate];
    }
    else
    {
        [self.delegate selectedDateFromMonthPicker:selectedDate];
        [self zoomOutAnimation];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutAnimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - Picker delegate & datasource method
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return monthArray.count;
    }
    else
    {
        return yearArray.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * nameInRow;
    
    if (component==0)
    {
        nameInRow=[monthArray objectAtIndex:row];
    }
    else if (component==1)
    {
        nameInRow= [NSString stringWithFormat:@"%@",
        [yearArray objectAtIndex:row]];
    }
    return nameInRow;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component == 0)
    {
        return 150.0;
    }
    else
    {
        return 100.0;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    selectedYear   = [[yearArray objectAtIndex:[mnthYearPicker selectedRowInComponent:1]]integerValue];
    
    selectedMonth  = [mnthYearPicker selectedRowInComponent:0]+1;
    
     if(selectedYear == currentYear && selectedMonth > currentMnth)
     {
         [pickerView selectRow:currentMnth-1 inComponent:0 animated:YES];
     }
}

@end
