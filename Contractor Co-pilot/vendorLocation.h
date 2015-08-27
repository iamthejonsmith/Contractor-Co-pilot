//
//  vendorLocation.h
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myLocation.h"

@protocol vendorLocationDelegate <NSObject>

-(void)loadingOverlay;

-(void)hideOverlay;

- (void)itemsRetrieved:(NSData *)itemData;

@end

@interface vendorLocation : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (nonatomic, weak) id<vendorLocationDelegate> delegate;

- (void)getItems;

@property (strong, nonatomic) vendorLocation *myLocation;

@end
