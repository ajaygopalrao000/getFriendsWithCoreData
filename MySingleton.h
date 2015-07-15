//
//  MySingleton.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/15/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingleton : NSObject

@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userEmail;
@property (strong, nonatomic) NSString * userMobileNo;
@property (strong, nonatomic) NSString * userImgName;

+ (id) globalInstance;
//+ (MySingleton *) globalInstance1;

@end
