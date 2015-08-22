//
//  Location.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/19/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)initWithName:(NSString*)name address:(NSString*)address andLocType:(NSString *)locType andDistance:(NSString *)distance andCity:(NSString *)city andState:(NSString *)state andZip:(NSString *)zip andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude
{
    self = [super init];
    
    if(self)
    {
        _name = name;
        _address = address;
        _locType = locType;
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
        _address = dictionary[@"address"];
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
    return _address;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"myLocation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"NutechImage.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end

