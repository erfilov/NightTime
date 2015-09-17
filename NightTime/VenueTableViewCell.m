//
//  VenueTableViewCell.m
//  NightTime
//
//  Created by Vik on 22.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "VenueTableViewCell.h"
#import <AFNetworking/AFURLSessionManager.h>



@interface VenueTableViewCell () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSessionTask *currentTask;
@property (strong, nonatomic) NSMutableData *currentData;
@property (strong, nonatomic) UIImage *image;
@end

@implementation VenueTableViewCell



- (void)setVenue:(Venue *)venue {
    _venue = venue;
    _titleVenue.text = venue.title;
    _categoryVenue.text = [NSString stringWithFormat:@"%@  %@", venue.category, venue.price = venue.price == nil ? @"" : venue.price];
    _rating.textColor = [UIColor whiteColor];
    _ratingRect.backgroundColor = venue.ratingColor;
    _ratingRect.layer.cornerRadius = 5.f;
    _rating.text = venue.rating;
    
}




- (void)loadImageFromURL:(NSURL *)url sessionManager:(AFURLSessionManager *)sessionManager withBlock:(NetworkRequestCompletionBlock)completionBlock {
    
        if (self.currentTask != nil && self.currentTask.state == NSURLSessionTaskStateRunning) {
            [self.currentTask cancel];
        } else if (self.currentTask == nil) {
            self.image = nil;

            self.currentTask = [sessionManager.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
                return;
            }
            self.image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(self.image, nil);
            });
        }];
            self.currentData = [NSMutableData new];
            [self.currentTask resume];
        }
    
    

}


@end
