//
//  MapViewController.m
//  AircallEmployee
//
//  Created by ZWT112 on 5/6/16.
//  Copyright © 2016 com.zwt. All rights reserved.
//

// **** static location ****
//33.8684025
//-117.8324004

#import "MapViewController.h"

@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,DirectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *vwMap;

@property CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UILabel *lblExpTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;

@property NSMutableArray *arrSteps;
@property NSString *strTime;
@end

@implementation MapViewController
@synthesize vwMap,locationManager,destLattitude,destLongitude,lblExpTime,lblDistance,arrSteps,strTime,destAddress;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];

    
    arrSteps = [[NSMutableArray alloc]init];
    
    vwMap.mapType               = MKMapTypeStandard;
    vwMap.showsUserLocation     = YES;
    
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
    {
       vwMap.showsTraffic       = YES;
    }
    
    
    [vwMap setRegion:[self regionFromLocations] animated:NO];
    
    vwMap.delegate = self;
    
    if (![destLattitude isKindOfClass:[NSNull class]] && ![destLongitude isKindOfClass:[NSNull class]])
    {
        [self getDirections];
        
        // **** opening default map application *****
    
       /* CLLocationCoordinate2D coordinate = [self getCurrentLocation];
        
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([destLattitude doubleValue], [destLongitude doubleValue]) addressDictionary:nil];
        
        MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        
        MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) addressDictionary:nil];
        
        //MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.5018431,  -119.7796647) addressDictionary:nil];
        
        MKMapItem *currentMapItem = [[MKMapItem alloc] initWithPlacemark:placemark1];
        
        [currentMapItem setName:@""];
        
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        
        [MKMapItem openMapsWithItems:@[currentMapItem, destMapItem]
                       launchOptions:launchOptions];*/
        
        // complete

    }
}

#pragma mark - Helper Method
-(CLLocationCoordinate2D) getCurrentLocation
{
    locationManager.delegate          = self;
    locationManager.desiredAccuracy   = kCLLocationAccuracyBest;
    locationManager.distanceFilter    = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location              = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

-(void)getDirections
{

    [SVProgressHUD show];
    
    CLLocationCoordinate2D coordinate = [self getCurrentLocation];
    
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *currentPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) addressDictionary:nil];
    
   // MKPlacemark *currentPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.5018431, -119.7796647) addressDictionary:nil];
    MKPointAnnotation *currentAnno = [[MKPointAnnotation alloc]init];
    currentAnno.coordinate = currentPlacemark.coordinate;
    currentAnno.title      = @"Current Location";
    
    [vwMap addAnnotation:currentAnno];
    
    MKMapItem *mapItems = [[MKMapItem alloc] initWithPlacemark:currentPlacemark];
    request.source = mapItems;
    
    MKPlacemark *destPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([destLattitude doubleValue], [destLongitude doubleValue]) addressDictionary:nil];
    
    MKPointAnnotation *destAnno = [[MKPointAnnotation alloc]init];
    destAnno.coordinate = destPlacemark.coordinate;
    destAnno.title      = @"Destination";
    destAnno.subtitle   = destAddress   ;
   
    [vwMap addAnnotation:destAnno];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:destPlacemark];
    
    request.destination             = mapItem;
    request.requestsAlternateRoutes = YES;
    request.transportType           = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions        =
    [[MKDirections alloc] initWithRequest:request];
    
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error)
    {
         if (error)
         {
             [SVProgressHUD dismiss];
             // Handle error
         }
         else
         {
             [self showRoute:response];
         }
     }];

}

-(void)showRoute:(MKDirectionsResponse *)response
{

    NSSortDescriptor *sortDescriptor;
    //distance
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"expectedTravelTime" ascending:YES];
    
    //Get the routes array sorted by expectedTravelTime
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedRoutes;
    sortedRoutes = [response.routes sortedArrayUsingDescriptors:sortDescriptors];
    
    //The fastest route is the one at index 0 of the sorted array
    MKRoute * fastestRoute = [sortedRoutes objectAtIndex:0];
    
   
    int expSec,expMin,expHr,expday;
    
    expSec = fastestRoute.expectedTravelTime ;
    
    if(expSec > 60)
    {
        expMin = expSec/60;
        expSec = expSec - (expMin *60);
        
        if(expMin > 60)
        {
            expHr  = expMin / 60;
            expMin = expMin - (expHr* 60);
            
            if(expHr > 24)
            {
                expday = expHr / 24;
                expHr  = expHr - (expday * 24);
                strTime = [NSString stringWithFormat:@"%d %s %d %s",expday,expday>1?"days" : "day",expHr,expHr>1?"hours" : "hour"];
            }
            else
            {
                strTime = [NSString stringWithFormat:@"%d %s %d %s",expHr,expHr>1?"hours" : "hour",expMin,expMin>1?"minutes" : "minute"];
            }
        }
        else
        {
            strTime = [NSString stringWithFormat:@"%d %s",expMin,expMin>1?"minutes" : "minute"];
        }
    }
    
    
    lblExpTime.text  = strTime;
    lblDistance.text = [NSString stringWithFormat:@"%0.2f Miles",(fastestRoute.distance * 0.000621371192)];
    [vwMap addOverlay:fastestRoute.polyline level:MKOverlayLevelAboveRoads];
    
    for (MKRouteStep *step in fastestRoute.steps)
    {
        [arrSteps addObject:step];
        //NSLog(@"Instruction : %@\n",step.instructions);
    }
    
    [SVProgressHUD dismiss];
}

#pragma mark -MKMapView Delegate method
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth   = 3.0;
    renderer.lineCap     = kCGLineCapSquare;
    renderer.lineJoin    = kCGLineCapRound;
    return renderer;
}
/*- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;  //return nil to use default blue dot view
    
    if([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
        
        annView.pinTintColor = [UIColor headerColor];
        return annView;
    }
    return nil;
}*/

#pragma mark -CLLocationManager Delegate Method
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //NSLog(@"didFailWithError: %@", error);
    
     CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied)
    {
        NSString *title;
        
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        
        UIAlertAction *setting = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }];
        
        [alert addAction:setting];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // CLLocation *location = [locations lastObject];
    CLGeocoder *coder=[[CLGeocoder alloc]init];
    
    [coder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        //CLPlacemark *place=[placemarks lastObject];
        
        //        address.text=[NSString stringWithFormat:@"%@, %@,  %@, %@, %@",place.locality,place.subLocality,place.country,place.ISOcountryCode,place.postalCode];
    }];
    
//    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
//    region.center.latitude = location.coordinate.latitude;
//    region.center.longitude = location.coordinate.longitude;
//    region.span.latitudeDelta = 0.0005f;
//    region.span.longitudeDelta = 0.0005f;
//    
//    [self.vwMap setRegion:region animated:YES];
    
    //    MKPointAnnotation *ann=[[MKPointAnnotation alloc]init];
    //    ann.coordinate=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    //    ann.title=@"ZealousWeb Technologies";
    //    [self.map addAnnotation:ann];
    
}
- (MKCoordinateRegion)regionFromLocations
{
    //CLLocationCoordinate2D clocation = CLLocationCoordinate2DMake(39.5018431, -119.7796647);
    
    CLLocationCoordinate2D clocation = [self getCurrentLocation];
    
    CLLocationCoordinate2D dlocation = CLLocationCoordinate2DMake([destLattitude doubleValue], [destLongitude doubleValue]);
    
    //MKMapRect destRect = MKMapRectMake([destLongitude doubleValue], [destLattitude doubleValue], 0, 0);
    
    CLLocationCoordinate2D upper = clocation;
    CLLocationCoordinate2D lower = clocation;
    
    // FIND LIMITS
    
    if(clocation.latitude > upper.latitude)
        upper.latitude = clocation.latitude;
    if(clocation.latitude < lower.latitude)
        lower.latitude = clocation.latitude;
    if(clocation.longitude > upper.longitude)
        upper.longitude = clocation.longitude;
    if(clocation.longitude < lower.longitude)
        lower.longitude = clocation.longitude;
    
    if(dlocation.latitude > upper.latitude)
        upper.latitude = dlocation.latitude;
    if(dlocation.latitude < lower.latitude)
        lower.latitude = dlocation.latitude;
    if(dlocation.longitude > upper.longitude)
        upper.longitude = dlocation.longitude;
    if(dlocation.longitude < lower.longitude)
        lower.longitude = dlocation.longitude;
    
    // FIND REGION
    MKCoordinateSpan locationSpan;
    locationSpan.latitudeDelta  = upper.latitude  - lower.latitude;
    locationSpan.longitudeDelta = upper.longitude - lower.longitude;
    
    CLLocationCoordinate2D locationCenter;
    locationCenter.latitude  = (upper.latitude  + lower.latitude) / 2;
    locationCenter.longitude = (upper.longitude + lower.longitude) / 2;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(locationCenter, locationSpan);
    
    return region;
}
#pragma mark - Event Method
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnDirectionTap:(id)sender
{
    // **** opening default map application *****
    
     CLLocationCoordinate2D coordinate = [self getCurrentLocation];
     
     
     MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([destLattitude doubleValue], [destLongitude doubleValue]) addressDictionary:nil];
     
     MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [destMapItem setName:destAddress];
     MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) addressDictionary:nil];
     
     //MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(39.5018431,  -119.7796647) addressDictionary:nil];
     
     MKMapItem *currentMapItem = [[MKMapItem alloc] initWithPlacemark:placemark1];
     
     [currentMapItem setName:@"Current Location"];
     
     NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
     
     [MKMapItem openMapsWithItems:@[currentMapItem, destMapItem]
     launchOptions:launchOptions];
    
    // complete

}
- (IBAction)btnDetailsTap:(id)sender
{
    DirectionViewController * vc = [ACEGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"DirectionViewController"];
    
    vc.arrInfo  = arrSteps;
    vc.strTime  = strTime ;
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - DirectionViewControllerDelegate method
-(void)selectedDirection:(MKPolyline *)line
{
    MKCoordinateRegion region  = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude     = line.coordinate.latitude ;
    region.center.longitude    = line.coordinate.longitude;
    region.span.longitudeDelta = 0.15f;
    region.span.latitudeDelta  = 0.15f;
    [vwMap setRegion:region animated:YES];
}
@end
