//
//  ViewController.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/28/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//Declare the block that will execute after receiving success from the method
typedef void (^FriendsCallbackSuccess)(NSArray *successArray);
//Declre the block that will execute after receiving error from the method
typedef void (^FriendsCallbackError)(NSString *errorString);




@interface ViewController : UIViewController<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *userDataArray;
    NSDictionary *userDataCollection;
}

// References from storyboard
@property (weak, nonatomic) IBOutlet UILabel *usrNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *usrImgView;
@property (strong, nonatomic) NSString * usrId;
@property (strong, nonatomic) NSString * usrEmail;
@property (strong, nonatomic) NSString * usrMobileNo;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *FacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *getMyFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteDataButton;

// References for edit, cancel bar buttons
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;



@property (strong,nonatomic)FriendsCallbackSuccess success;
@property (strong,nonatomic)FriendsCallbackError error;
//Create an array that will be used for storing the dictionary of friends from facebook
@property (strong, nonatomic)NSArray *theFriendsArray;

-(void)addUserInfoToCoreData : (NSMutableArray *) usrDataArray;


@end

