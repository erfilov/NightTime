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

+ (UIColor*)darkCandyAppleColor {
    return [UIColor colorWithRed:0.68 green:0 blue:0 alpha:1];
}

+ (UIColor *)antiFlashWhiteColor {
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.95 alpha:1];
}

- (void)customizeNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:[AppearanceCustomization blueColor]];
    [appearance setTintColor:[AppearanceCustomization whiteColor]];
    //    NSShadow *shadow = [[NSShadow alloc] init];
    //    shadow.shadowColor = [[AppearanceCustomization darkCandyAppleColor] colorWithAlphaComponent:0.5];
    //    shadow.shadowOffset = CGSizeMake(1, 1);
    appearance.titleTextAttributes = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"SFUIDisplay-Bold" size:17],
                                       NSForegroundColorAttributeName : [AppearanceCustomization whiteColor],
                                       };
}

- (void)applyGeneralCustomizations {
    [self customizeNavigationBar];
}

@end
