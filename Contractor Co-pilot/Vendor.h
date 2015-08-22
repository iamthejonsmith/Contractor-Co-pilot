//
//  vendor.h
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/18/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface Vendor : NSObject<MKAnnotation>

@property (strong, nonatomic) NSString *vendorName;
@property (strong, nonatomic) NSString *vendorAddress;
@property (strong, nonatomic) NSString *vendorPhone;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) double distance;

-(id)initWithVendor:(NSString *)vendorName andAddress:(NSString *)vendorAddress andPhone:(NSString *)vendorPhone andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andDistance:(double)distance;

@end
