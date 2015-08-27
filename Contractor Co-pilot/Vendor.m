//
//  vendor.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/18/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import "Vendor.h"

@implementation Vendor

-(id)initWithVendor:(NSString *)vendorName andAddress:(NSString *)vendorAddress andPhone:(NSString *)vendorPhone andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude andDistance:(double)distance
{
    self = [super init];
    
    if(self)
    {
        _vendorName = vendorName;
        _vendorAddress = vendorAddress;
        _vendorPhone = vendorPhone;
        _latitude = latitude;
        _longitude = longitude;
        _distance = distance;
        
    }
    
    return self;
}

-(id)init
{
    return [self initWithVendor:nil andAddress:nil andPhone:nil andLatitude:nil andLongitude:nil andDistance:0];
}


@end
