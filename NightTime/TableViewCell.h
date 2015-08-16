//
//  TableViewCell.h
//  NightTime
//
//  Created by Vik on 03.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@class Venue;
typedef void(^NetworkRequestCompletionBlock)(id result, NSError *error);


@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) IBOutlet UILabel *titleVenue;
@property (strong, nonatomic) IBOutlet UILabel *categoryVenue;
@property (strong, nonatomic) IBOutlet UIImageView *photoVenue;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (strong, nonatomic) IBOutlet UIView *ratingRect;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (assign, nonatomic) NSInteger cellIdentifier;


- (void)loadImageFromURL:(NSURL *)url venue:(Venue *)venue withBlock:(NetworkRequestCompletionBlock)completionBlock;

@end
