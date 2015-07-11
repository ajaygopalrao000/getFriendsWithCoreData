//
//  UserDataTable.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/10/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserDataTable : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSData * userImageData;
@property (nonatomic, retain) NSString * userMobileNo;

@end
