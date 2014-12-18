//  Superpin Airports Example
//  http://getsuperpin.com/
//
//  Copyright (c) 2011-2014 appscape. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SPAirport : NSObject<MKAnnotation>

@property (nonatomic, readonly) NSString *code, *city;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (UIImage*)icon;

/** Synchronously loads all airports from Airports.plist, returning an array of 
    SPAirport objects. */
+ (NSArray*)allAirports;

@end