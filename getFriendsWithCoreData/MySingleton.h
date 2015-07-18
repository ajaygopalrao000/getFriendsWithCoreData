//
//  MySingleton.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/15/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingleton : NSObject

@property (weak, nonatomic) NSString * userName;
@property (weak, nonatomic) NSString * userEmail;
@property (weak, nonatomic) NSString * userMobileNo;
@property (weak, nonatomic) NSString * userImgName;

// ## new properties for Subclassing
@property (strong, nonatomic) NSString * nameField;
@property (strong, nonatomic) NSString * emailField;

+ (id) globalInstance;
//+ (MySingleton *) globalInstance1;

@end
