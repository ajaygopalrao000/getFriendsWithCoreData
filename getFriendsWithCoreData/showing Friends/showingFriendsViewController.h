//
//  showingFriendsViewController.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/29/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//Declare the block that will execute after receiving success from the method
typedef void (^FriendsCallbackSuccess)(NSArray *successArray);
//Declre the block that will execute after receiving error from the method
typedef void (^FriendsCallbackError)(NSString *errorString);

@interface showingFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * table;
    NSMutableArray * dataSource;
}
@property (strong, nonatomic) NSString * colorString;


@property (strong,nonatomic)FriendsCallbackSuccess success;
@property (strong,nonatomic)FriendsCallbackError error;
//Create an array that will be used for storing the dictionary of friends from facebook
@property (strong, nonatomic)NSArray *theFriendsArray;


@end
