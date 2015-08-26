//
//  FoursquareAPI.h
//  NightTime
//
//  Created by Vik on 21.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
@import CoreLocation;
#import "Venue.h"
#import "UIColor+HexColors.h"

typedef void(^NetworkRequestCompletionBlock)(id result, NSError *error);

@interface FoursquareAPI : NSObject
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientSecret;
@property (assign, nonatomic) NSInteger radius;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) dispatch_group_t group;
@property (strong, nonatomic) NSURLSession *session;




- (void)updateVenuesFromCurrentLocation:(CLLocation *)location completionBlock:(NetworkRequestCompletionBlock)completionBlock;
- (NSArray *)parsePhotoFromArray:(NSArray *)array;
- (void)getInfoFromVenue:(Venue *)venue completionBlock:(NetworkRequestCompletionBlock)completionBlock;

- (NSArray *)createArrayVenues:(NSDictionary *)responseDictionary;
- (void)showAlertWhenNoInternetConnection;
- (void)showAlertWhenNoVenues;
- (void)showAlertWhenParsingError;
@end
