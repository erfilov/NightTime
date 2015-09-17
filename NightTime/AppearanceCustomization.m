//
//  AppearanceCustomization.m
//  NightTime
//
//  Created by Vik on 19.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "AppearanceCustomization.h"
@import UIKit;
#import "UIColor+HexColors.h"

@implementation AppearanceCustomization

+ (instancetype)new {
    return [[AppearanceCustomization alloc] init];
}

+ (UIColor *)blueColor {
    return [UIColor colorWithHexString:@"30559D"];
}

+ (UIColor *)whiteColor {
    return [UIColor whiteColor];
}

- (void)customizeNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:[AppearanceCustomization blueColor]];
    [appearance setTintColor:[AppearanceCustomization whiteColor]];

    appearance.titleTextAttributes = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"SFUIDisplay-Bold" size:17],
                                       NSForegroundColorAttributeName : [AppearanceCustomization whiteColor],
                                       };
}

- (void)applyGeneralCustomizations {
    [self customizeNavigationBar];
}

@end
