//
//  MySingleton.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/15/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton


+(id) globalInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    //NSLog(@"+(id) globalInstance");
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


//+(MySingleton *) globalInstance1
//{
//    static MySingleton * objSingleton;
//    NSLog(@"+(MySingleton *) gloabalInstance");
//    if (!objSingleton) {
//        objSingleton = [[MySingleton alloc] init];
//    }
//    return objSingleton;
//}

-(id)init
{
    self = [super init];
    if (self) {
        _userName = @"User";
        _userMobileNo = @"9999999999";
        _userEmail = @"xyz@domain.com";
        _userImgName = @"profile_Pic_Default 128*128";
        _nameField = @"User";
        _emailField = @"xyz@domain.com";
    }
    return self;
}

@end
