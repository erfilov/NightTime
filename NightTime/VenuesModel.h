//
//  VenuesModel.h
//  NightTime
//
//  Created by Величко Евгений on 01.08.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Venue.h"
@import CoreLocation;

typedef void(^NetworkRequestCompletionBlock)(id result, NSError *error);

@interface VenuesModel : NSObject
@property (assign, nonatomic) NSInteger radius;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientSecret;
@property (strong, nonatomic) NSURLSession *URLSession;


- (void)updateVenuesFromCurrentLocation:(CLLocation *)location completionBlock:(NetworkRequestCompletionBlock)completionBlock;
- (void)getInfoFromVenues:(NSArray *)venues completionBlock:(NetworkRequestCompletionBlock)completionBlock;
- (NSArray *)createArrayVenues:(NSDictionary *)responseDictionary;
- (NSArray *)parsePhotoFromArray:(NSArray *)array;





@end
