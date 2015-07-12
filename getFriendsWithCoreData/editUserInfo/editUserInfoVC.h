//
//  editUserInfoVC.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/8/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataTable.h"

// ## creating Delegate
@protocol editUserInforVCDelegate;


//@protocol editUserInforVCDelegate;


@interface editUserInfoVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UITableView * tableView;
    
    UITextField* nameTextField, * emailTextField, * mobileNoTextField ;
    UIButton * choosePictureButton;
    UIImageView * selectedImgView;
    
    // ## for camera
    UIActionSheet * objAction;
    UIAlertView * objAlert;
    
    // ## to store user data and send it to viewcontroller.m
    NSMutableArray *userDataArray;
    NSDictionary *userDataCollection;
    NSData * usrImgData;
    
}

// ## property for delegate
@property (nonatomic, weak) id<editUserInforVCDelegate> delegate;


@property (weak, nonatomic) IBOutlet UINavigationItem *doneBarButton;

@property (nonatomic,copy) NSString* name ;
@property (nonatomic,copy) NSString* email ;
@property (nonatomic,copy) NSString* mobileNo ;

@end


@protocol editUserInforVCDelegate <NSObject>

-(void) doneBtnClicked : (editUserInfoVC*)viewController
didChooseValue : (BOOL) flag;
- (UserDataTable*)getCurrentUser;

//-(void)buttonClicked:(NSString *)text;

@end


//@protocol editUserInforVCDelegate <NSObject>
//
//@required
//-(void) doneBtnClicked : (BOOL) flag;
//
//
//@end
