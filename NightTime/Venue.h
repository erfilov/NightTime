//
//  Venue.h
//  NightTime
//
//  Created by Величко Евгений on 08.08.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreLocation;

@interface Venue : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSMutableArray *photosImage;
@property (strong, nonatomic) UIImageView *photoVenue;
@property (strong, nonatomic) NSString *venueID;
@property (strong, nonatomic) NSString *addressVenue;
@property (strong, nonatomic) NSString *cityVenue;
@property (strong, nonatomic) NSDictionary *contacts;
@property (strong, nonatomic) NSDictionary *price;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) UIColor *ratingColor;
@property (strong, nonatomic) NSDictionary *hours;
@property (strong, nonatomic) NSURLSession *session;


@end
