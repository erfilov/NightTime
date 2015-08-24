//
//  VenueTableViewCell.m
//  NightTime
//
//  Created by Vik on 22.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "VenueTableViewCell.h"


@interface VenueTableViewCell () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSessionTask *currentTask;
@property (strong, nonatomic) NSMutableData *currentData;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) FoursquareAPI *api;
@end

@implementation VenueTableViewCell

- (void)setVenue:(Venue *)venue {
    _venue = venue;
    _titleVenue.text = venue.title;
    _categoryVenue.text = venue.category;
    _ratingRect.backgroundColor = venue.ratingColor != nil ? venue.ratingColor : [UIColor lightGrayColor];
    _ratingRect.layer.cornerRadius = 5.f;
    _rating.textColor = [UIColor whiteColor];
    NSString *rating = [NSString stringWithFormat:@"%.1f", [venue.rating floatValue]];
    _rating.text = [rating isEqualToString:@"0.0"] ? @"--" : rating;
    _price.text = venue.price;
    
    
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.currentData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        self.image = [UIImage imageWithData:self.currentData];
    }
    self.currentData = nil;
    self.currentTask = nil;
}

- (void)loadImageFromURL:(NSURL *)url venue:(Venue *)venue withBlock:(NetworkRequestCompletionBlock)completionBlock {
    
    
    self.currentTask = [self.api.manager.session dataTaskWithURL:url
                                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                   if (error != nil) {
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           completionBlock(nil, error);
                                                       });
                                                       return;
                                                   }
                                                   
                                                   UIImage *image = [UIImage imageWithData:data];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completionBlock(image, nil);
                                                   });
                                               }];
    [self.currentTask resume];
    
    

    
    
    
//    if (self.currentTask != nil && self.currentTask.state == NSURLSessionTaskStateCompleted) {
//        [self.currentTask cancel];
//    } else {
//        
//        if (self.currentTask == nil) {
//            self.image = nil;
//            self.currentTask = [self.api.manager dataTaskWithRequest:[NSURLRequest requestWithURL:url]
//                                                   completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
//                                                       
//                                                       if (error != nil) {
//                                                           dispatch_async(dispatch_get_main_queue(), ^{
//                                                               completionBlock(nil, error);
//                                                           });
//                                                           return;
//                                                       }
//                                                       
//                                                       UIImage *image = responseObject;//[UIImage imageWithData:data];
//                                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                                           completionBlock(image, nil);
//                                                       });
//                                                       
//                                                   }];
//            
//            self.currentData = [NSMutableData new];
//            [self.currentTask resume];
//            
//        }
//    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
