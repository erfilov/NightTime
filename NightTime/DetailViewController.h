//
//  DetailViewController.h
//  NightTime
//
//  Created by Vik on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@class Venue;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *category;


@property (strong, nonatomic) Venue *venue;


@end
