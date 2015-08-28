//
//  NSNumber+Foursquare.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 09/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "NSNumber+Foursquare.h"

@implementation NSNumber (Foursquare)

- (NSString *)gf_priceTierRerepresentationString {
    NSInteger tier = [self integerValue];
    NSMutableString *repr = [NSMutableString stringWithCapacity:tier];
    for (NSInteger idx = 0; idx < tier; idx++) {
        [repr appendString:@"$"];
    }
    return [repr copy];
}

@end
