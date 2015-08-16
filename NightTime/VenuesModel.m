//
//  VenuesModel.m
//  NightTime
//
//  Created by Величко Евгений on 01.08.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import "VenuesModel.h"
#import "UIColor+HexColors.h"

@interface VenuesModel ()
@property (strong, nonatomic) NSString *currentDate;
@property (strong, nonatomic) NSArray *addressVenues;
@property (strong, nonatomic) dispatch_group_t group;
@end

@implementation VenuesModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        _clientID       = @"P2JOKBXE0DCVTWLUB43KKAB5FBURSCRPJUF32YQGWSIUJBRI";
        _clientSecret   = @"51B2RFMD0ULFSLKZD3SRQLGDBAFQICV5PSJDXFL0VDYAYZT2";
        _radius         = 20000;
        
        self.URLSession = [NSURLSession sharedSession];
        
        _group = dispatch_group_create();

        
    }
    return self;
}

#pragma mark - Methods


- (void)updateVenuesFromCurrentLocation:(CLLocation *)location completionBlock:(NetworkRequestCompletionBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?categoryId=4d4b7105d754a06376d81259&ll=%f,%f&client_id=%@&client_secret=%@&v=%@&radius=%ld", location.coordinate.latitude, location.coordinate.longitude, self.clientID, self.clientSecret, @"20150815", (long)self.radius];
    
    
    [[self.URLSession dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionBlock(nil, error);
            return;
        }
        NSError *serialisationError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&serialisationError];
        NSDictionary *responseDict = dict[@"response"];
        NSArray *venues = [self createArrayVenues:responseDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(venues, nil);
        });
    }] resume];
}

- (NSArray *)parsePhotoFromArray:(NSArray *)array {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:array.count];
    NSString *prefix, *suffix, *width, *height;
    NSInteger index = 0;
    for (id photo in array) {
        prefix  = photo[@"prefix"];
        suffix  = photo[@"suffix"];
        
//        if (index == 0) {
//            width = height = @"300";
//        } else {
            width   = photo[@"width"];
            height  = photo[@"height"];
//        }
        NSString *url = [NSString stringWithFormat:@"%@%@x%@%@", prefix, width, height, suffix];
        [results addObject:url];
        index++;
    }
    return [results copy];
}

- (void)getInfoFromVenues:(NSArray *)venues completionBlock:(NetworkRequestCompletionBlock)completionBlock{
    
    for (int i = 0; i < [venues count]; i++) {
        Venue *venue = [venues objectAtIndex:i];
        NSString *urlPhoto = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=%@&limit=10",
                              venue.venueID, self.clientID, self.clientSecret, @"20150815"];
        
        dispatch_group_async(self.group, dispatch_get_main_queue(), ^{
            [[self.URLSession dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPhoto]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error != nil) {
                    completionBlock(nil, error);
                    return;
                }
                NSError *serialisationError;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&serialisationError];
                
                NSDictionary *responseDictionary = dict[@"response"];
                NSDictionary *photos = responseDictionary[@"photos"];
                NSArray *items = photos[@"items"];
                venue.photos = [self parsePhotoFromArray:items];
            }] resume];
        });
        
        NSString *urlInfo = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@&v=%@",
                             venue.venueID, self.clientID, self.clientSecret, @"20150815"];
        
        dispatch_group_async(self.group, dispatch_get_main_queue(), ^{
            [[self.URLSession dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlInfo]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error != nil) {
                    completionBlock(nil, error);
                    return;
                }
                NSError *serialisationError;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&serialisationError];
                
                NSDictionary *responseDictionary = dict[@"response"];
                NSDictionary *venueInfo = responseDictionary[@"venue"];
                venue.price = venueInfo[@"price"];
                venue.rating = venueInfo[@"rating"];
                venue.ratingColor = [UIColor colorWithHexString:venueInfo[@"ratingColor"]];
                venue.hours = venueInfo[@"hours"];
            }] resume];
        });
        
    }
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        completionBlock(venues, nil);
    });
    
}

- (NSArray *)createArrayVenues:(NSDictionary *)responseDictionary {
    NSArray *array = responseDictionary[@"venues"];
    __block NSMutableArray *results = [NSMutableArray arrayWithCapacity:array.count];
    
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *venues = [array objectAtIndex:i];
        NSDictionary *location = venues[@"location"];
        NSString *lat = location[@"lat"];
        NSString *lng = location[@"lng"];
        CLLocation *locationVenue = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
        NSString *titleVenue = venues[@"name"];
        NSArray *categories = venues[@"categories"];
        NSDictionary *dict = categories[0];
        NSString *categoryVenue = dict[@"name"];
        NSString *venueID = venues[@"id"];
        NSDictionary *contact = venues[@"contact"];
        Venue *venue = [[Venue alloc] init];
        venue.session = self.URLSession;
        venue.location = locationVenue;
        venue.title = titleVenue;
        venue.category = categoryVenue;
        venue.venueID = venueID;
        venue.contacts = @{
                           @"address" : location[@"address"] == nil ? @"" : location[@"address"],
                           @"city": location[@"city"] == nil ? @"" : location[@"city"],
                           @"phone" : contact[@"formattedPhone"] == nil ? @"" : contact[@"formattedPhone"],
                           @"url" : venues[@"url"] == nil ? @"" : venues[@"url"],
                           };
        [results addObject:venue];

    }
    
    [self getInfoFromVenues:results completionBlock:^(id result, NSError *error) {
        results = result;
    }];
    return [results copy];
}

@end
