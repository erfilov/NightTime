//
//  FoursquareAPI.m
//  NightTime
//
//  Created by Vik on 21.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "FoursquareAPI.h"



@interface FoursquareAPI ()
@property (strong, nonatomic) NSURL *baseUrl;
@end

@implementation FoursquareAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clientID       = @"P2JOKBXE0DCVTWLUB43KKAB5FBURSCRPJUF32YQGWSIUJBRI";
        _clientSecret   = @"51B2RFMD0ULFSLKZD3SRQLGDBAFQICV5PSJDXFL0VDYAYZT2";
        _radius         = 10000;
        _version        = @"20150815";
        
        _baseUrl = [NSURL URLWithString:@"https://api.foursquare.com/v2/"];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseUrl];
        
        _group = dispatch_group_create();

        
        
    }
    return self;
}


- (void)updateVenuesFromCurrentLocation:(CLLocation *)location completionBlock:(NetworkRequestCompletionBlock)completionBlock {
    
    NSString *venueListUrl = [NSString stringWithFormat:@"venues/search?categoryId=4d4b7105d754a06376d81259&ll=%f,%f&client_id=%@&client_secret=%@&v=%@&radius=%ld", location.coordinate.latitude, location.coordinate.longitude, self.clientID, self.clientSecret, self.version, (long)self.radius];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrl.description, venueListUrl]];
    [[self.manager dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error != nil) {
            completionBlock(nil, error);
            return;
        }
        NSDictionary *responseDictionary = responseObject[@"response"];
        NSArray *venues = [self createArrayVenues:responseDictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(venues, nil);
        });
    }] resume];
}

- (NSArray *)parsePhotoFromArray:(NSArray *)array {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:array.count];
    __block NSString *prefix, *suffix, *width, *height;
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        prefix = obj[@"prefix"];
        suffix = obj[@"suffix"];
        if (!idx) {
            width = height = @"300";
        } else {
            width = obj[@"width"];
            height = obj[@"height"];
        }
        NSString *url = [NSString stringWithFormat:@"%@%@x%@%@", prefix, width, height, suffix];
        [results addObject:url];
    }];
    return [results copy];
}

- (void)getInfoFromVenues:(NSArray *)venues completionBlock:(NetworkRequestCompletionBlock)completionBlock{
    
    for (int i = 0; i < [venues count]; i++) {
        Venue *venue = [venues objectAtIndex:i];
        dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *venuePhotoUrl = [NSString stringWithFormat:@"venues/%@/photos?client_id=%@&client_secret=%@&v=%@&limit=10",
                                       venue.venueID, self.clientID, self.clientSecret, self.version];
            [[self.manager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrl.description, venuePhotoUrl]]]
             completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
                                 
                                 if (error != nil) {
                                     completionBlock(nil, error);
                                     return;
                                 }
                                 if (responseObject != nil) {
                                     
                                     NSDictionary *responseDictionary = responseObject[@"response"];
                                     NSMutableArray *items = [NSMutableArray new];
                                     if ([responseDictionary[@"photos"] isKindOfClass:[NSDictionary class]] && responseDictionary[@"photos"] != nil) {
                                         NSDictionary *photos = responseDictionary[@"photos"];
                                         if ([photos[@"items"] isKindOfClass:[NSArray class]] && photos[@"items"] != nil) {
                                             items = photos[@"items"];
                                         }
                                     }
                                     venue.photos = [self parsePhotoFromArray:[items copy]];
                                 } else {
                                     [self showAlertWhenParsingError];
                                     return;
                                 }
                             }] resume];
        });
        
        dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *venueInfoUrl = [NSString stringWithFormat:@"venues/%@?client_id=%@&client_secret=%@&v=%@", venue.venueID, self.clientID, self.clientSecret, self.version];
            [[self.manager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrl.description, venueInfoUrl]]]
                             completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
                                 
                                 if (error != nil) {
                                     completionBlock(nil, error);
                                     return;
                                 }
                                 if (responseObject != nil) {
                                     NSDictionary *responseDictionary = responseObject[@"response"];
                                     NSDictionary *venueInfo = responseDictionary[@"venue"];
                                     NSDictionary *price = venueInfo[@"price"];
                                     venue.price = price[@"message"] != nil ? price[@"message"] : @"";
                                     venue.rating = venueInfo[@"rating"];
                                     venue.ratingColor = [UIColor colorWithHexString:venueInfo[@"ratingColor"]];
                                 } else {
                                     [self showAlertWhenParsingError];
                                     return;
                                 }
                             }] resume];
        });
        
    }
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        venue.location = locationVenue;
        venue.title = titleVenue;
        venue.category = categoryVenue;
        venue.venueID = venueID;
        venue.addressVenue = location[@"address"] == nil ? @"" : location[@"address"];
        venue.cityVenue = location[@"city"] == nil ? @"" : location[@"city"];
        venue.phoneVenue = contact[@"formattedPhone"] == nil ? @"" : contact[@"formattedPhone"];
        venue.websiteUrl = venues[@"url"] == nil ? @"" : venues[@"url"];
        
        [results addObject:venue];
        
    }
    
    [self getInfoFromVenues:results completionBlock:^(id result, NSError *error) {
        results = result;
    }];
    return [results copy];
}

#pragma mark - Show Alert Methods

- (void)showAlertWhenNoInternetConnection {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка!"
                                                    message:@"Отсутствует соединение с сервером. Проверьте подключение к сети Интернет."
                                                   delegate:self
                                          cancelButtonTitle:@"Закрыть"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertWhenNoVenues {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Печаль!"
                                                    message:@"Кажется, поблизости нет мест, удовлетворяющих запросу."
                                                   delegate:self
                                          cancelButtonTitle:@"Закрыть"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertWhenParsingError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка!"
                                                    message:@"Парсинг не удался."
                                                   delegate:self
                                          cancelButtonTitle:@"Закрыть"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
