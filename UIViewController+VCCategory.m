//
//  UIViewController+VCCategory.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "UIViewController+VCCategory.h"

@implementation UIViewController (VCCategory)

- (void)addListenerMethod:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTriggerMethod:) name:name object:nil];
}
- (void)removeListenerMethod:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)postNotification:(NSString*)name withData : (NSDictionary *)dict{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:dict];
}



@end
