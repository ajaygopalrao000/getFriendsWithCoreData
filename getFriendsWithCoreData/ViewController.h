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
#import "editUserInfoVC.h"
#import "showingFriendsViewController.h"


@interface ViewController : UIViewController<showingFriendsVCDelegate,editUserInforVCDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *userDataArray;
    NSDictionary *userDataCollection;
}

// References from storyboard
@property (weak, nonatomic) IBOutlet UILabel *usrNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *usrImgView;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *FacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *getMyFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteDataButton;
@property (weak, nonatomic) IBOutlet UILabel *usrEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMobileNoLabel;



-(UserDataTable*)addUserInfoToCoreData : (NSMutableArray *) usrDataArray;


@end

