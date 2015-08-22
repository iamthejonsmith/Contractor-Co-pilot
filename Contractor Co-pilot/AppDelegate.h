//
//  AppDelegate.h
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "myLocation.h"

@protocol LocationDelegate <NSObject>

-(void)setLocationLabel:(NSString *)locString;
-(void)updateInitialLocation:(myLocation *)location;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSString *currLocation;
@property (strong,nonatomic) myLocation *myLocation;
@property (weak, nonatomic) id <LocationDelegate> locDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(CAGradientLayer *)makeBackgroundLayerForView:(UIView *)view;

@end

