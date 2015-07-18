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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

}
- (void)removeListenerMethod:(NSString*)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)postNotification:(NSString*)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self];
}
/*
-(void)textFieldDidChange:(NSNotification*)notification
{
    // do something
    NSLog(@"Recvd notification for name : %@",notification.name);
}*/

@end
