//
//  UIViewController+VCCategory.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (VCCategory)
//Add method for adding a method to add viewcontroller as a listener for a notification name
//Add method for adding a method to removing viewcontroller as a listener for a notification name



- (void)addListenerMethod:(NSString*)name;
- (void)postNotification:(NSString*)name;
- (void)removeListenerMethod:(NSString*)name;

@end
