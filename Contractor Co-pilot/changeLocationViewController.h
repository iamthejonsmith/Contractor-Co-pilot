//
//  changeLocationViewController.h
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "myLocation.h"

@protocol ChangeLocationDelegate <NSObject>

-(void)updateCurrentLocation:(myLocation *)location;

@end
@interface changeLocationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <ChangeLocationDelegate> delegate;

@property (strong, nonatomic) myLocation *passedLocation;

@end
