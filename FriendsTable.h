//
//  FriendsTable.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/29/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FriendsTable : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uId;
@property (nonatomic, retain) NSString * url;

@end
