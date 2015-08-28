//
//  NSObject+Associating.m
//  NightTime
//
//  Created by Vik on 28.08.15.
//  Copyright © 2015 Ерфилов Виктор. All rights reserved.
//

#import "NSObject+Associating.h"
#import <objc/runtime.h>




@implementation NSObject (Associating)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
