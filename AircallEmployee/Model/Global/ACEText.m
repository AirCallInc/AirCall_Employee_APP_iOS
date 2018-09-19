//
//  ACEText.m
//  AircallEmployee
//
//  Created by ZWT112 on 3/29/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

#import "ACEText.h"

#pragma mark - Common Texts
NSString *const appName           = @"AirCall";
NSString *const ACETextOk         = @"OK"     ;
NSString *const ACETextYes        = @"Yes"    ;
NSString *const ACETextNo         = @"No"     ;
NSString *const ACEDeviceType     = @"iPhone" ;
NSString *const ACETextShowDetail = @"Show Detail";

NSString *const ACENoInternet = @"There is no network connection available. Please connect to the internet and try again.";

NSString *const ACENoConnectionToServer  =@"Could not connect to server. Please try again.";

NSString *const ACEUnknownError    = @"Some error occured. Please try again later."          ;
NSString *const ACETextLoading     = @"Loading ..."     ;
NSString *const ACETextNoMoreData  = @"No more data"    ;
NSString *const ACENoDataFound     = @"No Data Found"   ;
NSString *const ACESessionExpired  = @"Oops!!! Your session expired or your account may be logged using another device.";


#pragma mark - Card Type
NSString *const ACECardVisa            = @"Visa"        ;
NSString *const ACECardDiscover        = @"Discover"    ;
NSString *const ACECardMaseter         = @"MasterCard"  ;
NSString *const ACECardAmericanExpress = @"AMEX"        ;

#pragma mark - Validation Messages
NSString *const ACEDatenotMatch = @"You can fill service report of Today's services only.";

NSString *const ACERescheduleDate = @"Sorry, you can not reschedule today's service.";

NSString *const ACEReportAlreadySaved = @"You are already working on other report. Please complete that report first";


#pragma mark - Validation Messages

NSString *const ACEBlankAddress     = @"Please enter Address"        ;
NSString *const ACEBlankState       = @"Please select State"         ;
NSString *const ACESelectState      = @"Please select state first"   ;
NSString *const ACEBlankCity        = @"Please select City"          ;
NSString *const ACEBlankZipCode     = @"Please enter Zip Code"       ;
NSString *const ACEInvalidZipcode   = @"Please enter valid zip code" ;
NSString *const ACEShortZipcode     = @"Please enter five letters"   ;

NSString *const ACERecommendation = @"Please enter recommendations"      ;
NSString *const ACEBlankReason    = @"Please enter reason for reschedule";
NSString *const ACEBlankDate      = @"Please choose the date"            ;

NSString *const ACENoEmailSelected = @"Please select email or enter CC email";

// For Password
NSString *const ACEBlankPassword        = @"Please enter Password"              ;
NSString *const ACEBlankNewPassword     = @"Please enter new Password"          ;
NSString *const ACEBlankConfirmPassword = @"Please enter confirm Password"      ;
NSString *const ACEPasswordNotMatch     = @"Password doesn't match"             ;
NSString *const ACEPasswordSpace        = @"Password contains space, Please re-enter password";
NSString *const ACEShortPassword        = @"Please enter minimum 6 digit"       ;

// For account setting
NSString *const ACEBlankFirstName       = @"Please enter first name"            ;
NSString *const ACEBlankLastName        = @"Please enter last name"             ;
NSString *const ACEInvalidFirstName     = @"Please enter valid first name"      ;
NSString *const ACEInvalidLastName      = @"Please enter valid last name"       ;
NSString *const ACEBlankMobileNumber    = @"Please enter Mobile number"         ;
NSString *const ACEBLankPhoneNumber     = @"Please enter Phone number"          ;

NSString *const ACEInvalidMobileNumber  = @"Mobile Number must have minimum 10 digits";
NSString *const ACEInvalidPhoneNumber   = @"Phone Number must have minimum 8 digits" ;
NSString *const ACEBlankEmail           = @"Please enter Email Address"         ;
NSString *const ACEInvalidEmail         = @"Please enter valid Email Address"   ;
NSString *const ACEInvalidDate          = @"Please select valid dates"          ;
NSString *const ACEBlankNotes           = @"Please enter a notes"               ;
NSString *const ACEInvalidUserName      = @"You have entered invalid username"  ;


#pragma mark - New service report submission Message

NSString *const ACENoUnitsSelected      = @"Please select units"  ;
NSString *const ACENoPartsSelected      = @"Please select parts"  ;
NSString *const ACENoPlanSelected       = @"Please select plan"   ;

NSString *const ACEBlankNotesToCustomer = @"Please enter notes to customer"     ;
NSString *const ACEBlankEmployeeNotes   = @"Please enter employee Notes"        ;
NSString *const ACENoEmailselected      = @"Please select email or enter CC email ";
NSString *const ACEBlankCCEmail         = @"Please enter CC email"              ;
NSString *const ACEInvalidCCEmail       = @"Please enter valid CC email"        ;
NSString *const ACEBlankClientSignature = @"Please enter client's signature"    ;

NSString *const ACEUnMatchedUnitsParts  = @"Please select units and Material Properly" ;

NSString *const ACEBlankWorkPerformed   = @"Please enter what work you have performed" ;

NSString *const ACESubmitServiceReport  = @"Are you sure want to submit service report? Once you submit it, you will not be able to change it.";

#pragma mark - Add Unit Message
NSString *const ACEBlankModelNumber  = @"Please enter Model Number"     ;
NSString *const ACEBlankSerialNumber = @"Please enter diffrent Serial Number"    ;
NSString *const ACESameModelNumber   = @"Please enter diffrent Model Number";
NSString *const ACESameModelSerialNumber =@"Please enter different Model Number & Serial Number";
NSString *const ACESameSerialNumber      = @"Please enter different Serial Number";
NSString *const ACEBlankManufactureBrand = @"Please enter Manufacture Brand";
NSString *const ACEBlankUnitTon          = @"Please enter Unit Ton";

NSString *const ACEBlankManufactureDate  = @"Please choose the Manufacture Date";
NSString *const ACEInvalidManufactureDate= @"Please select valid Manufacture Date";

NSString *const ACEUnitLimit             = @"You can not add more than 5 units at the same time";
NSString *const ACEInactiveZipcode       = @"Sorry!! Currently we are not providing service in your area";

NSString *const ACEPendingUnitMsg        = @"Previously added unit failed to complete. Did you want to load them first? If you answer NO they will be deleted.";
NSString *const ACEInvalidQty            = @"Please enter valid quantity";

#pragma mark - Part request Message
// for New part
NSString *const ACEBlankPartName         = @"Please enter part name"        ;
NSString *const ACEBlankPartSize         = @"Please enter part size"        ;
NSString *const ACEBlankPartDescription  = @"Please enter part description" ;

//For request Part
NSString *const ACEBlankClientName      = @"Please select Client";
NSString *const ACEBlankRequestPartNotes= @"Please enter notes"  ;

#pragma mark - No Data Messages
//For ScheduleDetail
NSString *const ACENoOfficeNumber         = @"No office number added"       ;
NSString *const ACENoMobileNumber         = @"No mobile number added"       ;
NSString *const ACENoHomeNumber           = @"No home number added"         ;

NSString *const ACENoUnitManuals     = @"No manuals have been added for the unit";
NSString *const ACENoServiceReports  = @"No service reports have been found";
NSString *const ACENoUnitPictures    = @"No pictures have been added";
NSString *const ACENoScheduleForDate = @"There is no service scheduled for this date";

#pragma mark - Note Message
NSString *const ACETextAskImageSource = @"How do you want to select an image?";

#pragma mark - Button Message
NSString *const ACETextFromCamera  = @"Take Photo";
NSString *const ACETextFromLibrary = @"From Albums";
NSString *const ACETextCancel      = @"Cancel";

#pragma mark - Other Messages
NSString *const ACEAllowAccessPhotoLibrary = @"Please turn on allow access for Photo Library from the Settings.";
NSString *const ACEAllowAccessCamera       = @"Please turn on allow access for Camera from the Settings.";

NSString *const ACEAskToDeleteUnit         = @"Are you sure you want to delete unit?";

#pragma mark - CreditCard validation Messages
//Credit Card Validation Messages
NSString *const ACEBlankNameOnCard   = @"Please enter your name"   ;
NSString *const ACEInvalidNameOnCard = @"Please enter valid name"  ;
NSString *const ACEBlankCardNumber   = @"Please enter card number" ;
NSString *const ACEInvalidCardNumberLength = @"Please enter valid card number" ;
NSString *const ACEInvalidCardNumber = @"Please enter only numeric characters"  ;
NSString *const ACEBlankCVV          = @"Please enter CVV"   ;
NSString *const ACEInvalidExpDate    = @"Invalid month"      ;
NSString *const ACEInvalidCVV        = @"Invalid CVV"        ;
NSString *const ACEBlankExpMonth     = @"Enter ExpMonth "    ;
NSString *const ACEBlankExpYear      = @"Enter ExpYear"      ;

//for check
NSString *const ACEBlankChequeNumber   = @"Please enter Check Number" ;
NSString *const ACEBlankBankName       = @"Please enter Bank Name"    ;
NSString *const ACEBlankChequeDate     = @"Please select Check Date"  ;
NSString *const ACEBlankChargeBy       = @"Please select Charge By"   ;
NSString *const ACEBlankChequeFrontImage = @"Please take front image of check";
NSString *const ACEBlankChequeBackImage  = @"Please take back image of check";

//for po
NSString *const ACEBlankPONumber       = @"Please enter PO Number"    ;
NSString *const ACEInvalidPONumber     = @"Please enter only numeric character";  ;
//Rate & review
NSString *const ACEBlankReviewNotes = @"Please enter notes";

//Request for New Schedule
NSString *const ACENoAddressFound = @"No address has been found for the client";
NSString *const ACENoUnitsFound   = @"No Units available for selected Address" ;
NSString *const ACENoPlanFound    = @"No plan has been found for this address" ;
NSString *const ACESelectAddress  = @"Please select address";
NSString *const ACECanNotOpenUrl  = @"Url can not be opened";
NSString *const ACERequestUnitLimit = @"More hours required to perform the service. Morning timeslot must be picked.";
NSString *const ACEInvalidSelectedDate = @"Only emergency services can be scheduled on weekends. Either change this request to Emergency (fee will incur) or please request the service during regular business hours.";
#pragma mark - Controller Title
NSString *const ACEAddUnitTitle   = @"Add Unit";
NSString *const ACEEditUnitTitle  = @"Unit Detail";


