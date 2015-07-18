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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"textFieldChanged" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

}
+ (void) removeListenerMethod;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"textFieldChanged" object:nil];
}

-(void)textFieldDidChange:(NSNotification*)notification
{
    // do something
    NSLog(@"Recvd notification for name : %@",notification.name);
}

@end
