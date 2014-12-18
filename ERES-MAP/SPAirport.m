//  Superpin Airports Example
//  http://getsuperpin.com/
//
//  Copyright (c) 2011-2014 appscape. All rights reserved.

#import "SPAirport.h"

@interface SPAirport() {
    NSString *_code, *_city, *_type;
}
@end

@implementation SPAirport

- (instancetype)initWithCode:(NSString*)code
                        city:(NSString*)city
                    latitude:(CLLocationDegrees)latitude
                   longitude:(CLLocationDegrees)longitude
                        type:(NSString*)type {
    if (self = [super init]) {
        _code = code;
        _city = city;
        _type = type;
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return self;
}

- (NSString*)title {
    return _code;
}

- (NSString*)subtitle {
    return _city;
}

- (UIImage*)icon {
    return [UIImage imageNamed:[NSString stringWithFormat:@"symbol_%@", _type]];
}

+ (NSArray*)allAirports {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"plist"];
    NSError *error;

    NSArray* airports = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:path]
                                                                  options:kCFPropertyListImmutable
                                                                   format:nil
                                                                    error:&error];
    if (error) {
        NSLog(@"Error loading Airports (%@)", error);
        return @[];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* a in airports) {
        [result addObject:[[self alloc] initWithCode:a[@"Code"]
                                                city:a[@"City"]
                                            latitude:[a[@"Latitude"] doubleValue]
                                           longitude:[a[@"Longitude"] doubleValue]
                                                type:a[@"Type"]]];
    }
    return result;
}
@end
