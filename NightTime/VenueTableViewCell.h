//
//  VenueTableViewCell.h
//  NightTime
//
//  Created by Vik on 22.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import "Venue.h"
#import "FoursquareAPI.h"

@interface VenueTableViewCell : UITableViewCell

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) IBOutlet UILabel *titleVenue;
@property (strong, nonatomic) IBOutlet UILabel *categoryVenue;
@property (strong, nonatomic) IBOutlet UIImageView *photoVenue;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (strong, nonatomic) IBOutlet UIView *ratingRect;

@end