//
//  ScreenOneVC.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ParentVC.h"
#import "ScreenTwoVC.h"

@interface ScreenOneVC : ParentVC//<ScreenTwoDelegate>

//-(void) observeValues;

@property (nonatomic, weak) NSString * usernameValue;
@property (nonatomic, weak) NSString * emailValue;
@property (nonatomic, weak) IBOutlet UITableView * myTable;

@end
