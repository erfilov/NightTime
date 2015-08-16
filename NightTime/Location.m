//
//  Location.m
//  NightTime
//
//  Created by Величко Евгений on 01.08.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import "Location.h"

@interface Location () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) LocationUpdateCompletionBlock completionBlock;

@end

@implementation Location 

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
        
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
 

    }
    return self;
}

+ (instancetype)sharedInstance {

    static Location *location = nil;
    if ([CLLocationManager locationServicesEnabled]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            location = [Location new];
        });
    } else {
        NSLog(@"Location services are not enabled");
    }

    return location;
}

- (void)startUpdatingLocationWithCompletionBlock:(LocationUpdateCompletionBlock)block {
    self.completionBlock = block;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.completionBlock(location, nil);
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        self.completionBlock(nil, error);
        [self.locationManager stopUpdatingLocation];
    }
}





@end
