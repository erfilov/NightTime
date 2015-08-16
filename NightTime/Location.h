//
//  Location.h
//  NightTime
//
//  Created by Величко Евгений on 01.08.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationUpdateCompletionBlock)(CLLocation *location, NSError *error);


@interface Location : NSObject

+ (instancetype)sharedInstance;

- (void)startUpdatingLocationWithCompletionBlock:(LocationUpdateCompletionBlock)block;

@end
