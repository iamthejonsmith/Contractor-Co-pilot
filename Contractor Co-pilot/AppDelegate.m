//
//  AppDelegate.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "AppDelegate.h"
#import "locationViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate

    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:5];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"redGradient.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"SavedLocation"] == nil)
    {
        [self startUpdating];
    }
    
    else
    {
        NSDictionary *locDict = [userDefaults objectForKey:@"SavedLocation"];
        
        _myLocation = [[myLocation alloc]init];
        
        _myLocation.streetNumber = locDict[@"StreetNumber"];
        _myLocation.streetName = locDict[@"StreetName"];
        _myLocation.city = locDict[@"City"];
        _myLocation.state = locDict[@"State"];
        _myLocation.zip = locDict[@"Zip"];
        _myLocation.latitude = locDict[@"Latitude"];
        _myLocation.longitude = locDict[@"Longitude"];
        
        _currLocation = [NSString stringWithFormat:@"%@ %@\n %@, %@ %@", _myLocation.streetNumber, _myLocation.streetName, _myLocation.city, _myLocation.state, _myLocation.zip];
        
    }
    
    
    return YES;
}

-(CAGradientLayer *)makeBackgroundLayerForView:(UIView *)view
{
    CAGradientLayer *viewLayer = [CAGradientLayer layer];
    viewLayer.frame = view.bounds;
    viewLayer.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor darkGrayColor] CGColor],
                        (id)[[UIColor darkTextColor] CGColor],
                        nil];
    
    return viewLayer;
}

-(void)setInitialLocation:(NSString *)location
{
    [self.locDelegate setLocationLabel:location];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "NutechSystemsInc.Contractor_Co_pilot" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Contractor_Co_pilot" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Contractor_Co_pilot.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)startUpdating{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER){
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *currentLocation = (CLLocation *)[locations lastObject];
    __block CLPlacemark *placemark = self.placemark;
    self.placemark = placemark;
    if (currentLocation != nil) {
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
           _myLocation = [[myLocation alloc]init];
            
            _myLocation.name = @"";
            _myLocation.streetNumber = placemark.subThoroughfare;
            _myLocation.streetName = placemark.thoroughfare;
            _myLocation.city = placemark.locality;
            _myLocation.state = placemark.administrativeArea;
            _myLocation.zip = placemark.postalCode;
            _myLocation.latitude = [NSString stringWithFormat:@"%.02f", currentLocation.coordinate.latitude];
            _myLocation.longitude = [NSString stringWithFormat:@"%.02f", currentLocation.coordinate.longitude];
            
            
            _currLocation = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@",
                             placemark.subThoroughfare,
                             placemark.thoroughfare,
                             placemark.postalCode,
                             placemark.locality,
                             placemark.administrativeArea];
            
            if(_currLocation != nil){
                [self setInitialLocation:_currLocation];
                // Stop Location Manager
                [self.locationManager stopUpdatingLocation];
            }
            else{
                [self.locDelegate setLocationLabel:@"Updating Location ..."];
            }
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
}

@end
