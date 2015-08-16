//
//  DetailViewController.m
//  NightTime
//
//  Created by Vik on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import "DetailViewController.h"
#import "Venue.h"
@import UIKit;
@import MapKit;
#import "UIColor+HexColors.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *titleVenue;
@property (strong, nonatomic) IBOutlet UILabel *categoryVenue;
@property (strong, nonatomic) IBOutlet UILabel *addressVenue;
@property (strong, nonatomic) IBOutlet UILabel *cityVenue;
@property (strong, nonatomic) IBOutlet UITextView *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextView *websiteURL;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleVenue.text = self.venue.title;
    self.categoryVenue.text = self.venue.category;
    self.addressVenue.text = self.venue.contacts[@"address"];
    self.cityVenue.text = self.venue.contacts[@"city"];
    self.phoneNumber.text = self.venue.contacts[@"phone"];
    self.websiteURL.text = self.venue.contacts[@"url"];
    self.title = self.venue.title;
    
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"30559D"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];



    
    
    CLLocationDistance regionRadius = 200.0;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.venue.location.coordinate, regionRadius * 2, regionRadius * 2)];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = self.venue.location.coordinate;
    myAnnotation.title = self.titleVenue.text;
    myAnnotation.subtitle = self.categoryVenue.text;
    [self.mapView addAnnotation:myAnnotation];
    
    

    
 }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
