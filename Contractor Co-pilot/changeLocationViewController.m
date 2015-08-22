//
//  changeLocationViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Jon Smith. All rights reserved.
//

#import "changeLocationViewController.h"
#import "locationViewController.h"
#import "MBProgressHUD.h"

@interface changeLocationViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *streetNumberField;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;
@property (strong, nonatomic) IBOutlet UITextField *zipField;
@property (strong, nonatomic) IBOutlet UIButton *submitAddressButton;

@property (strong, nonatomic) NSString *addressString;
@property (strong, nonatomic) NSString *changeAddressString;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic, strong) CLLocation *firstLoc;
@property (nonatomic, strong) CLLocation *pointBLocation;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *destinationText;

@property (nonatomic, assign) CLLocationCoordinate2D there;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float longi;
@property (nonatomic, assign) float distanceMeters;
@property (nonatomic, assign) float distanceInMiles;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation changeLocationViewController
myLocation *changedLocation;
CLLocationCoordinate2D center;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Set the delegate of the text fields to self
    _streetNumberField.delegate = self;
    _addressField.delegate = self;
    _cityField.delegate = self;
    _stateField.delegate = self;
    _zipField.delegate = self;
    
    _submitAddressButton.layer.cornerRadius = 4;
    _submitAddressButton.layer.masksToBounds = YES;
    
    UIToolbar* streetNumberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    streetNumberToolbar.barStyle = UIBarStyleBlackTranslucent;
    streetNumberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelStreetNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithStreetNumberPad)]];
    UIImage* toolbarImage = [UIImage imageNamed: @"redGradient.png"];
    [streetNumberToolbar setBackgroundImage:toolbarImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [streetNumberToolbar setTintColor:[UIColor whiteColor]];
    [streetNumberToolbar sizeToFit];
    _streetNumberField.inputAccessoryView = streetNumberToolbar;
    
    UIToolbar* zipToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    zipToolbar.barStyle = UIBarStyleBlackTranslucent;
    zipToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelZipNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithZipNumberPad)]];
    [zipToolbar setTintColor:[UIColor whiteColor]];
    [zipToolbar setBackgroundImage:toolbarImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [zipToolbar sizeToFit];
    _zipField.inputAccessoryView = zipToolbar;
    _locationManager.delegate = self;
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
}

// UITextFieldDelegate method that is called when the return key is pressed on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Dismiss the keyboard
    [textField resignFirstResponder];
    
    return YES;
}

// cancels text entry and dismisses the keyboard for numberpad input
-(void)cancelStreetNumberPad{
    [_streetNumberField resignFirstResponder];
    _streetNumberField.text = @"";
}

-(void)doneWithStreetNumberPad{
    
    [_streetNumberField resignFirstResponder];
}

-(void)cancelZipNumberPad{
    [_zipField resignFirstResponder];
    _zipField.text = @"";
}

-(void)doneWithZipNumberPad{
    
    [_zipField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAddressPressed:(id)sender
{
    [self displayAlert];
}

#pragma mark Alert View Methods

-(void)displayAlert

{
    NSString *streetNumber = _streetNumberField.text;
    NSString *address = _addressField.text;
    NSString *city = _cityField.text;
    NSString *state = _stateField.text;
    NSString *zip = _zipField.text;
    
    _addressString = [NSString stringWithFormat:@"%@ %@,\n %@ %@, %@", streetNumber, address, city, state, zip];
    
    NSString *alertString = [NSString stringWithFormat:@"Your current location is:\n %@", _addressString];
    
    // Create the alert view
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Address"
                                                    message:alertString
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    // show the alert view
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    changedLocation = [[myLocation alloc]init];
    changedLocation.name = @"Current Location";
    changedLocation.streetNumber = _streetNumberField.text;
    changedLocation.streetName = _addressField.text;
    changedLocation.city = _cityField.text;
    changedLocation.state = _stateField.text;
    changedLocation.zip = _zipField.text;
    
    _destinationText = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", changedLocation.streetNumber, changedLocation.streetName, changedLocation.city, changedLocation.state, changedLocation.zip];
    
    [self getLocationFromAddressString:_destinationText];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CLLocationCoordinate2D)getLocationFromAddressString:(NSString *)addressStr
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr = [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if(result){
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
        }
        }
    }
        center.latitude = latitude;
        center.longitude = longitude;
        changedLocation.latitude = [NSString stringWithFormat:@"%f", center.latitude];
        changedLocation.longitude = [NSString stringWithFormat:@"%f", center.longitude];
        [self getFullLocation:changedLocation];
        
        return center;
}

-(void)getFullLocation:(myLocation *)location
{
    [self.delegate updateCurrentLocation:location];
}

#pragma mark - Loading Overlay methods

// loading progress overlay method
-(void)loadingOverlay
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"Loading Vendors";
    [_hud show: YES];
}

// hide progress indicator method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES];
}

@end
