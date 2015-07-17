//
//  UIViewController+VCCategory.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "UIViewController+VCCategory.h"

@implementation UIViewController (VCCategory)

+ (void) addListenerMethod;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingHappens:) name:@"notificationName" object:nil];
}
+ (void) removeListenerMethod;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationName" object:nil];
}

-(void)somethingHappens:(NSNotification*)notification
{
    // do something
}

@end
