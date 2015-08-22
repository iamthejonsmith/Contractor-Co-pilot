//
//  vendorLocation.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#define api_key @"svu68f2kz5snynqrdnetv76u"

#import "vendorLocation.h"
#import "MBProgressHUD.h"


@interface vendorLocation()
{
    NSMutableData *retrievedData;
}
@end

@implementation vendorLocation

- (void)getItems
{
    NSString *urlString = @"http://api.sandbox.yellowapi.com";
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:urlString];
    // Create the request
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    //[urlRequest setHTTPMethod:@"GET"];
    [urlRequest setURL:jsonFileUrl];
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [self.delegate loadingOverlay];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    retrievedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [retrievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate itemsRetrieved:retrievedData];
    [self.delegate hideOverlay];
}


@end
