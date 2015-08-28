//
//  VenueTableViewCell.m
//  NightTime
//
//  Created by Vik on 22.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "VenueTableViewCell.h"
#import <AFNetworking/AFURLSessionManager.h>


@interface VenueTableViewCell ()
@property (strong, nonatomic) NSURLSessionTask *currentTask;
@property (strong, nonatomic) NSMutableData *currentData;
@property (strong, nonatomic) UIImage *image;
@end

@implementation VenueTableViewCell



- (void)setVenue:(Venue *)venue {
    _venue = venue;
    _titleVenue.text = venue.title;
    
    
    
    _categoryVenue.text = [NSString stringWithFormat:@"%@  %@", venue.category, venue.price = venue.price == nil ? @"" : venue.price];
    
    if (venue.ratingColor == nil) {
        _ratingRect.hidden = YES;
    }
    _ratingRect.hidden = NO;

    _ratingRect.backgroundColor = venue.ratingColor != nil ? venue.ratingColor : [UIColor lightGrayColor];
    _ratingRect.layer.cornerRadius = 5.f;
    _rating.textColor = [UIColor whiteColor];
    NSString *rating = [NSString stringWithFormat:@"%.1f", [venue.rating floatValue]];
    _rating.text = [rating isEqualToString:@"0.0"] ? @"--" : rating;
}




@end
