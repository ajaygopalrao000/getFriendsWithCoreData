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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "FriendsTable.h"

//Declare the block that will execute after receiving success from the method
typedef void (^FriendsCallbackSuccess)(NSArray *successArray);
//Declre the block that will execute after receiving error from the method
typedef void (^FriendsCallbackError)(NSString *errorString);


// ## Creating Delegate
@protocol showingFriendsVCDelegate <NSObject>

-(void) notificationObject : (NSMutableArray *) dataSource;

@end


@interface showingFriendsViewController : UIViewController<MFMailComposeViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ABPeoplePickerNavigationController * peoplePicker;
    
    NSMutableArray * dataSource;
    
    // ## Mail Composer
    MFMailComposeViewController * mailComposer;
}

// ## property for delegate
@property (nonatomic, weak) id<showingFriendsVCDelegate> delegate;

@property (strong, nonatomic) NSString * colorString;


@property (strong,nonatomic)FriendsCallbackSuccess success;
@property (strong,nonatomic)FriendsCallbackError error;
//Create an array that will be used for storing the dictionary of friends from facebook
@property (strong, nonatomic)NSArray *theFriendsArray;

// ## index for get friends list
@property (nonatomic, assign) int index;


// TableView Delegate

@property (weak, nonatomic) IBOutlet UITableView *table;

// ## Compose Mail Method

-(void)composeMailMethod : (NSString * )name;

@end
