//
//  TableViewController.m
//  NightTime
//
//  Created by Величко Евгений on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//

#import "TableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"
#import "VenuesModel.h"
#import "Location.h"
#import "TableViewCell.h"
#import "UIColor+HexColors.h"


@interface TableViewController () 
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic) VenuesModel *venuesModel;
@property (strong, nonatomic) NSDictionary *locationVenue;
@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation TableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.venuesModel = [[VenuesModel alloc] init];
    
    [[Location sharedInstance] startUpdatingLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
        [self.venuesModel updateVenuesFromCurrentLocation:location completionBlock:^(NSArray *result, NSError *error) {
            self.venues = result;
            [self.tableView reloadData];
        }];
    }];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"30559D"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
    cell.venue = [self.venues objectAtIndex:indexPath.row];
    cell.cellIdentifier = indexPath.row;
    NSLog(@"%ld", cell.cellIdentifier);
    if ([cell.venue.photos firstObject] != nil) {

        [self.activityIndicator stopAnimating];
        NSURL *imageURL = [NSURL URLWithString:[cell.venue.photos firstObject]];
        [cell loadImageFromURL:imageURL venue:cell.venue withBlock:^(id result, NSError *error) {
            cell.photoVenue.image = result;
        }];
    }
    cell.price.text = cell.venue.price[@"message"];
    
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *detailViewController = segue.destinationViewController;
        TableViewCell *cell = sender;
        detailViewController.venue = cell.venue;
    }
}







@end
