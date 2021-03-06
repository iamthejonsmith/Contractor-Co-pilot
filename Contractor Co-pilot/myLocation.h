//
//  Location.h
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface myLocation : NSObject<MKAnnotation>


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *streetNumber;
@property (nonatomic, strong) NSString *streetName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *locType;
@property (nonatomic, strong) NSString *distance;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (nonatomic) CLLocationCoordinate2D coordinate;

+ (id)sharedLocation;

- (id)initWithName:(NSString*)name streetNumber:(NSString*)streetNumber andStreetName:(NSString *)streetName andLocType:(NSString *)locType andDistance:(NSString *)distance andCity:(NSString *)city andState:(NSString *)state andZip:(NSString *)zip andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude;

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(MKAnnotationView *)annotationView;

@end