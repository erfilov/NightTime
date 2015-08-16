//
//  TableViewCell.m
//  NightTime
//
//  Created by Vik on 03.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "TableViewCell.h"
#import "Venue.h"


@interface TableViewCell () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (strong, nonatomic) NSURLSessionTask *currentTask;
@property (strong, nonatomic) NSMutableData *currentData;
@property (strong, nonatomic) UIImage *image;


@end



@implementation TableViewCell

- (void)setVenue:(Venue *)venue {
    _venue = venue;
    _titleVenue.text = venue.title;
    _categoryVenue.text = venue.category;
    _ratingRect.backgroundColor = venue.ratingColor != nil ? venue.ratingColor : [UIColor lightGrayColor];
    _ratingRect.layer.cornerRadius = 5.f;
    _rating.textColor = [UIColor whiteColor];
    NSString *rating = [NSString stringWithFormat:@"%.1f", [venue.rating floatValue]];
    _rating.text = [rating isEqualToString:@"0.0"] ? @"--" : rating;
    

    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.currentData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        self.image = [UIImage imageWithData:self.currentData];
//        NSLog(@"ident: %ld, state:%ld", self.currentTask.taskIdentifier, (long)self.currentTask.state);
    }
    self.currentData = nil;
    self.currentTask = nil;
}

- (void)loadImageFromURL:(NSURL *)url venue:(Venue *)venue withBlock:(NetworkRequestCompletionBlock)completionBlock {
    
    
//    if (self.currentTask != nil && self.currentTask.state == NSURLSessionTaskStateCompleted) {
//        [self.currentTask cancel];
//    } else
    
        if (self.currentTask == nil) {
        self.image = nil;
        self.currentTask = [venue.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
        
        self.currentData = [NSMutableData new];
        [self.currentTask resume];

    }

 
//    [[venue.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        
//        if (error != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock(nil, error);
//            });
//            return;
//        }
//        UIImage *image = [UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completionBlock(image, nil);
//            
//            
//        });
//    }] resume];
}




@end
