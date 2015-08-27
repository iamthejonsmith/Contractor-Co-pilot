//
//  ViewController.h
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "myLocation.h"
#import "AppDelegate.h"
#import "changeLocationViewController.h"

@interface locationViewController : UIViewController<CLLocationManagerDelegate, LocationDelegate, ChangeLocationDelegate>
{
    CLLocationManager *locationManager;
    
}

@end

