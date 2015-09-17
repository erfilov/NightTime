//
//  TableViewController.h
//  NightTime
//
//  Created by Vik on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "FoursquareAPI.h"
#import "Location.h"
#import "VenueTableViewCell.h"
#import "UIColor+HexColors.h"
#import <CoreLocation/CoreLocation.h>
#import "VenueDetailViewController.h"


@interface VenueTableViewController : UITableViewController
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) FoursquareAPI *api;
@end
