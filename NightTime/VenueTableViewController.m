//
//  TableViewController.m
//  NightTime
//
//  Created by Vik on 25.07.15.
//  Copyright (c) 2015 Ерфилов Виктор. All rights reserved.
//



#import "VenueTableViewController.h"
#import "NSObject+Associating.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@protocol FoursquareAPIDelegate;



@interface VenueTableViewController ()

- (IBAction)refreshTableView:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


@end


@implementation VenueTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [[FoursquareAPI alloc] init];
    [[Location sharedInstance] startUpdatingLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
        [self showLoadingView];

        [self.api updateVenuesFromCurrentLocation:location completionBlock:^(NSArray *result, NSError *error) {
            self.venues = result;
            [self.tableView reloadData];
            [self hideLoadingView];
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerRefreshButton:) userInfo:nil repeats:NO];
}



- (void) timerRefreshButton:(NSTimer *) timer {
    [self.refreshButton setEnabled:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VenueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
    
    cell.venue = [self.venues objectAtIndex:indexPath.row];
        
    
    
    
        if (cell.venue.photos) {
            NSString *imageURL = [cell.venue.photos firstObject];
            
            [cell.photoVenue setImageWithURL:[NSURL URLWithString:imageURL]];
            
//                [cell loadImageFromURL:[NSURL URLWithString:imageURL] sessionManager:self.api.URLSessionManager withBlock:^(id result, NSError *error) {
//                        cell.photoVenue.image = result;
//                }];
            
        }
        
    
 


    return cell;
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        VenueDetailViewController *detailViewController = segue.destinationViewController;
        VenueTableViewCell *cell = sender;
        detailViewController.venue = cell.venue;
    }
}


#pragma mark - Methods
- (void)showLoadingView {
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 140)];
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0;
    self.loadingView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.frame = CGRectMake(65, 40, self.activityIndicator.bounds.size.width, self.activityIndicator.bounds.size.height);
    [self.loadingView addSubview:self.activityIndicator];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    loadingLabel.text = @"Загрузка...";
    [self.loadingView addSubview:loadingLabel];
    self.loadingView.alpha = 0;
                             self.loadingView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.loadingView.alpha = 1;
                         self.loadingView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) { }];
    
    [self.view addSubview:self.loadingView];
    [self.activityIndicator startAnimating];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.loadingView.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
                         self.loadingView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.loadingView.hidden = YES;
                     }];
    [self.activityIndicator stopAnimating];
    }



- (IBAction)refreshTableView:(UIBarButtonItem *)sender {
    [[Location sharedInstance] startUpdatingLocationWithCompletionBlock:^(CLLocation *location, NSError *error) {
        [self showLoadingView];
        
        [self.api updateVenuesFromCurrentLocation:location completionBlock:^(NSArray *result, NSError *error) {
            self.venues = result;
            [self.tableView reloadData];
            [self hideLoadingView];
            
            
        }];
    }];

}




@end
