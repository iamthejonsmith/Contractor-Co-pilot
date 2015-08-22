//
//  MapViewController.m
//  JPMorganChaseSample
//
//  Created by Joffrey Mann on 7/30/15.
//  Copyright (c) 2015 Nutech. All rights reserved.
//

#import "MapViewController.h"
#import "Vendor.h"
#import "myLocation.h"

@interface MapViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSString *destinationText;
@property (nonatomic, strong) CLLocation *firstLoc;
@property (nonatomic, strong) CLLocation *pointBLocation;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, assign) CLLocationCoordinate2D there;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float longi;
@property (nonatomic, assign) float distanceMeters;
@property (nonatomic, assign) float distanceInMiles;
@property (nonatomic) NSUInteger index;
@property (nonatomic) CLLocationCoordinate2D poiCoordinates;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    for (int i = 0; i < _passedArray.count; i++) {
        Vendor *vendor = _passedArray[i];
        _poiCoordinates.latitude = [vendor.latitude doubleValue];
        _poiCoordinates.longitude= [vendor.longitude doubleValue];
        vendor.coordinate = _poiCoordinates;
        [self.map addAnnotation:vendor];
    }
    self.map.delegate = self;
    
    // Initialize a MKMapRect variable to null.
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in _map.annotations)
    {
        // For each MKAnnotation in the mapview's annotions array, create an annotation point for the annotation's coordinate.
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        
        //Then create a rectangle based on the annotationPoint's size and position.
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        
        // Join the annotation point's rectangle and the zoom rectangle.
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    // Set the visible rectangle of the map.
    [_map setVisibleMapRect:zoomRect animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    myLocation *location = view.annotation;
    self.index = [mapView.annotations indexOfObject:location];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Directions" message:@"Would you like directions to this destination?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        Vendor *loc = self.map.annotations[_index];
        [self routeMapWithLocation:loc];
    }
    
    else
    {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
}

-(void)routeMapWithLocation:(Vendor *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    NSString *destinationText = location.vendorAddress;
    [geocoder geocodeAddressString:destinationText completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _location = placemark.location;
            _there = _location.coordinate;
            MKPlacemark *destPlace = [[MKPlacemark alloc] initWithCoordinate:_there addressDictionary:nil];
            MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:destPlace];
            destMapItem.name = destinationText;
            _pointBLocation = [[CLLocation alloc] initWithLatitude:_location.coordinate.latitude longitude:_location.coordinate.longitude];
            NSArray* mapItems = [[NSArray alloc] initWithObjects: destMapItem, nil];
            NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey, nil];
            [MKMapItem openMapsWithItems:mapItems launchOptions:options];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
