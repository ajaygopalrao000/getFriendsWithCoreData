//
//  ScreeTwoVC.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ParentVC.h"

// ## Creating Delegate
@protocol ScreenTwoDelegate <NSObject>

-(void) doneBtnClicked : (NSDictionary *) flag;

@end

@interface ScreenTwoVC : ParentVC

// ## property for delegate
@property (nonatomic, weak) id<ScreenTwoDelegate> delegate;


@end
