//
//  Venue.h
//  NightTime
//
//  Created by Vik on 08.08.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

//#import <Foundation/Foundation.h>
@import UIKit;
@import CoreLocation;

typedef void(^NetworkRequestCompletionBlock)(id result, NSError *error);

@interface Venue : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) UIImageView *photoVenue;
@property (strong, nonatomic) NSString *venueID;
@property (strong, nonatomic) NSString *addressVenue;
@property (strong, nonatomic) NSString *cityVenue;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) UIColor *ratingColor;
@property (strong, nonatomic) NSString *phoneVenue;
@property (strong, nonatomic) NSString *websiteUrl;





@end
