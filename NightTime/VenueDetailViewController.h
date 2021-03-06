//
//  DetailViewController.h
//  NightTime
//
//  Created by Vik on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@import CoreLocation;
#import "Venue.h"
#import "UIColor+HexColors.h"

@interface VenueDetailViewController : UIViewController
@property (strong, nonatomic) Venue *venue;
@end