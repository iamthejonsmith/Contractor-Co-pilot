//
//  Location.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import "myLocation.h"

@implementation myLocation

+ (id)sharedLocation {
    static myLocation *sharedMyLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyLocation = [[self alloc] init];
    });
    return sharedMyLocation;
}

- (id)initWithName:(NSString*)name streetNumber:(NSString*)streetNumber andStreetName:(NSString *)streetName andLocType:(NSString *)locType andDistance:(NSString *)distance andCity:(NSString *)city andState:(NSString *)state andZip:(NSString *)zip andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude
{
    self = [super init];
    
    if(self)
    {
        _name = name;
        _streetNumber = streetNumber;
        _streetName = streetName;
        _distance = distance;
        _city = city;
        _state = state;
        _zip = zip;
        _latitude = latitude;
        _longitude = latitude;
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(self)
    {
        _name = dictionary[@"name"];
        _streetName = dictionary[@"streetName"];
        _streetNumber = dictionary[@"streetNumber"];
        _locType = dictionary[@"locType"];
        _distance = dictionary[@"distance"];
        _city = dictionary[@"city"];
        _state = dictionary[@"state"];
        _zip = dictionary[@"zip"];
        _latitude = dictionary[@"lat"];
        _longitude = dictionary[@"lng"];
    }
    
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    NSString *address = [NSString stringWithFormat:@"%@ %@", _streetNumber, _streetName];
    
    return address;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"myLocation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"NuTechImage.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end
