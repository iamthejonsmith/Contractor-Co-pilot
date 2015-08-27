//
//  ViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import "locationViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface locationViewController ()

@property (strong, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) myLocation *location;
@property (strong, nonatomic) IBOutlet UIButton *changeAddressButon;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation locationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _appDelegate.locDelegate = self;
    
    _currentLocationLabel.text = _appDelegate.currLocation;
    
    _continueButton.layer.cornerRadius = 4;
    _continueButton.layer.masksToBounds = YES;
    _changeAddressButon.layer.cornerRadius = 4;
    _changeAddressButon.layer.masksToBounds = YES;
    
    self.navigationItem.title = @"Current Location";
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
}

-(void)updateInitialLocation:(myLocation *)location
{
    _location = location;
}

-(void)setLocationLabel:(NSString *)locString
{
    [self loadingOverlay];
    _currentLocationLabel.text = _appDelegate.currLocation;
    [_hud hide:YES];
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Services Code

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
    }
}

#pragma mark - Loading Overlay methods

// loading progress overlay method
- (void)loadingOverlay
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"Loading Location";
    [_hud show: YES];
}

// load progress overlay when webView Startes
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self loadingOverlay];
}

// hide progress indicator method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES];
}

-(void)updateCurrentLocation:(myLocation *)location
{
    _currentLocationLabel.text = [NSString stringWithFormat:@"%@ %@\n %@, %@ %@\n",
                                  location.streetNumber,
                                  location.streetName,
                                  location.city,
                                  location.state,
                                  location.zip];
    
    NSDictionary *locDict = @{@"StreetNumber": location.streetNumber,
                              @"StreetName": location.streetName,
                              @"City": location.city,
                              @"State": location.state,
                              @"Zip": location.zip,
                              @"Latitude": location.latitude,
                              @"Longitude": location.longitude};
    _appDelegate.myLocation = location;
    
    [[NSUserDefaults standardUserDefaults]setObject:locDict forKey:@"SavedLocation"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[changeLocationViewController class]])
    {
        changeLocationViewController *clvc = (changeLocationViewController *)segue.destinationViewController;
        clvc.passedLocation = _location;
        clvc.delegate = self;
    }
}


@end
