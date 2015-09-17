//
//  DetailViewController.m
//  NightTime
//
//  Created by Vik on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import "VenueDetailViewController.h"


@interface Venue (MKAnnotation) <MKAnnotation>
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *category;


@end

@interface VenueDetailViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *titleVenue;
@property (strong, nonatomic) IBOutlet UILabel *categoryVenue;
@property (strong, nonatomic) IBOutlet UILabel *addressVenue;
@property (strong, nonatomic) IBOutlet UILabel *cityVenue;
@property (strong, nonatomic) IBOutlet UITextView *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextView *websiteURL;
@end

@implementation VenueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleVenue.text = self.venue.title;
    self.categoryVenue.text = self.venue.category;
    self.addressVenue.text = self.venue.addressVenue;
    self.cityVenue.text = self.venue.cityVenue;
    self.phoneNumber.text = self.venue.phoneVenue;
    self.websiteURL.text = self.venue.websiteUrl;
    self.title = self.venue.title;
    
    
    
    
    
    CLLocationDistance regionRadius = 200.0;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.venue.location.coordinate, regionRadius * 2, regionRadius * 2)];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = self.venue.location.coordinate;
    myAnnotation.title = self.titleVenue.text;
    myAnnotation.subtitle = self.categoryVenue.text;
    [self.mapView addAnnotation:myAnnotation];
    
    
    
    
}




@end