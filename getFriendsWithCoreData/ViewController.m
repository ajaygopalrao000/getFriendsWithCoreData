//
//  ViewController.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/28/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "FriendsTable.h"
#import "UserDataTable.h"
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MySingleton.h"

@interface ViewController ()
{
    AppDelegate * appDel;
    BOOL conn;
    
    // ## edit button
    //UIBarButtonItem * edit;
    
    // ## for camera
    UIActionSheet * objAction;
    UIAlertView * objAlert;
    NSMutableArray * usrDataSource;
    
    UserDataTable * objUser;
    
    // ## for results count
    NSArray * results;
    
    //## index for passing
    int indexLocal;
    NSString * frndName;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDel = [[UIApplication sharedApplication] delegate];
    self.title = @" List of Friends ";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // ## fbloginButton
    self.FacebookButton = [[FBSDKLoginButton alloc] init];
    [self.FacebookButton setReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    
    // disabling the buttons
    [self.getMyFriendButton setEnabled:NO];
    [self.deleteDataButton setEnabled:NO];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    
    // calling getUserData method to set the logged in user detail's like name, image.
    [self getUserData];
    
    // ## Calling createNotification Method
    //[self createNotification];
    
}


// ## delegate for ShowingFriends VC for notification

-(void) notificationObject : (NSMutableArray *)  dataSource;
{
    //NSLog(@"VC.m, notificationObject, dataSource count %li",[dataSource count]);
    //FriendsTable * objFriend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTable" inManagedObjectContext:appDel.managedObjectContext];
    //NSLog(@"VC.m, notificationObject delegate, with");
//    for (int i = 0; i< [dataSource count]; i++) {
//        objFriend = [dataSource objectAtIndex:i];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationMethod:) name:objFriend.uId object:nil];
//    }

}


// ## Create Notification
- (void) createNotification
{
    NSLog(@"VC.m, createNotification ");
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * resultsFriends = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    
    //NSLog(@" results count in showingFriendsViewController is %li",[resultsFriends count]);
    
    if (error == nil) {
        //NSLog(@"error == nil");
        FriendsTable * objFriend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTable" inManagedObjectContext:appDel.managedObjectContext];
        [self removeNotification:objFriend withDictionary:resultsFriends];
        for (int i = 0; i< [resultsFriends count]; i++) {
            objFriend = [resultsFriends objectAtIndex:i];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationMethod:) name:objFriend.uId object:nil];
        }
    }
}

-(void) removeNotification :(FriendsTable *) objFrnd withDictionary : (NSArray *) resultsFrnd;
{
    NSLog(@"VC.m, removeNotification ");
    for (int i = 0; i< [resultsFrnd count]; i++) {
        objFrnd = [resultsFrnd objectAtIndex:i];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:objFrnd.uId object:nil];
    }
}

// ## NOtification method
- (void) updateNotificationMethod : (NSNotification *) nsNote;
{
    //NSString * name = nsNote.name;
    NSDictionary *dict = nsNote.userInfo;
    NSLog(@"VC.m, updateNotificationMethod, Recvd Notification for name : %@",[dict objectForKey:@"friendName"]);
    //NSLog(@"VC.m, buttonIndex == 2, Before Compose Mail method");
    indexLocal = 2;
    frndName = [dict objectForKey:@"friendName"];
    [self performSegueWithIdentifier:@"ShowFriendsListSegue" sender:self];
}


// ## performing Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueToEditUserInfoVC"])
    {
        editUserInfoVC * destVC = (editUserInfoVC *) segue.destinationViewController;
        destVC.delegate = self;
    }
    else if([[segue identifier] isEqualToString:@"ShowFriendsListSegue"])
    {
        //NSLog(@"ViewController, PrepareForSegue, ShowFriendsListSegue, indexLocal is %d",indexLocal);
        showingFriendsViewController * destVC = (showingFriendsViewController *) segue.destinationViewController;
        destVC.delegate = self;
        destVC.index = indexLocal;
        if (indexLocal == 2) {
            //NSLog(@"VC.m, prepareForSegue, before setting frnds name : %@",frndName);
            destVC.fName = frndName;
        }
        
    }
}

// ## editUSerInfoVCDelegate Moethods
-(void) doneBtnClicked : (editUserInfoVC*)viewController
        didChooseValue : (BOOL) flag withUpdateddataRef:(UserDataTable *)objUserData;
{
    //NSLog(@"In ViewController, doneBtnClicked method, flag : %s",flag ? "True" : "False");
    if (flag) {
        objUser = objUserData;
        [self updateUserDataWithObject:objUser];
    }
}
- (UserDataTable*)getCurrentUser
{
    //NSLog(@" Name in getCurrentUser is %@", objUser.userName);
    //NSLog(@"Results Count is %li", [results count]);
    return objUser;
}

// ## storing user data in the database

-(UserDataTable*)addUserInfoToCoreData : (NSMutableArray *) usrDataArray
{
    
    //NSLog(@" in addUserInfoToCoreData ");
    //NSLog(@" userDataArray size is %li",[userDataArray count]);
    if ([results count] >= 1) {
        [self deleteMethod:@"UserDataTable"];
    }
    NSDictionary * dict;
    objUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserDataTable" inManagedObjectContext:appDel.managedObjectContext];
    
    
    dict = [usrDataArray objectAtIndex:0];
    objUser.userName = [dict objectForKey:@"userNme"];
    objUser.userImageData = [dict objectForKey:@"usrImgData"];
    objUser.userEmail = [dict objectForKey:@"usrEmail"];
    objUser.userId = [dict objectForKey:@"usrId"];
    objUser.userMobileNo = [dict objectForKey:@"usrMobileNo"];
    //    NSLog(@" Name is %@", [dict objectForKey:@"userNme"]);
    NSError * error;
    [appDel.managedObjectContext save:&error];
    
    if (error == nil) {
        //NSLog(@"Success in storing the data");
        return objUser;
    }
    
    return nil;
    
}

// ## Return from editUserinfoVC when user clicks on cancel
-(IBAction)retturnFromeditUserInfoVC:(UIStoryboardSegue*)cancelButton
{
    
}

- (void)updateUserDataWithObject:(UserDataTable*)object {
    self.usrNameLabel.text = [NSString stringWithFormat:@" Hello : %@",object.userName];
    self.usrImgView.image = [UIImage imageWithData:object.userImageData];
    self.usrEmailLabel.text = [NSString stringWithFormat:@" Email : %@",object.userEmail];
    self.userMobileNoLabel.text = [NSString stringWithFormat:@" Mobile No : %@",object.userMobileNo];
}

// get's the details of the user who is currently logged in
- (void) getUserData
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             //NSLog(@"fetched user:");
             NSMutableString * usrId = nil;
             if ([result objectForKey:@"id"])
                 usrId = [result objectForKey:@"id"];
             else
                 usrId = [NSMutableString stringWithString: @"No-Id"];
             
             NSString * usrMobileNo = [NSString stringWithFormat:@"9999999999"];
             
             // ## Fetching User data from core data
             NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"UserDataTable"];
             NSError * errorDatabase;
             results = [appDel.managedObjectContext executeFetchRequest:fetch error:&errorDatabase];
             usrDataSource = [[NSMutableArray alloc] init];
             [usrDataSource addObjectsFromArray:results];
             //NSLog(@"Results Count is %li",[results count]);
             
             if (!error && errorDatabase == nil && [results count] == 1) {
                 NSLog(@" [results count] == 1 ");
                 objUser = [usrDataSource objectAtIndex:0];
                 [self updateUserDataWithObject:objUser];
                 
                 //[self deleteMethod:@"UserDataTable"];
             }
             else if(!error)
             {
                 //NSLog(@"fetched user:%@", result);
                 NSMutableString *userNme = nil;
                 if ([result objectForKey:@"name"])
                     userNme = [result objectForKey:@"name"];
                 else
                     userNme = [NSMutableString stringWithString: @"User"];
                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                 NSURL *picUrl = [NSURL URLWithString:userImageURL];
                 NSData * usrImgData = [NSData dataWithContentsOfURL:picUrl];
                 if (usrImgData == nil) {
                     UIImage * img = [UIImage imageNamed:@"profile_Pic_Default 128*128"];
                     usrImgData = [NSData dataWithData:UIImagePNGRepresentation(img)];
                 }
                 
                 NSMutableString * usrEmail = nil;
                 if ([result objectForKey:@"email"]) {
                     usrEmail = [result objectForKey:@"email"];
                 } else {
                     usrEmail = [NSMutableString stringWithString: @"No - Email"];
                 }
                 NSLog(@" [results count] != 1 ");
                 userDataCollection = [[NSDictionary alloc]initWithObjects:@[userNme, usrImgData, usrEmail, usrId, usrMobileNo] forKeys:@[@"userNme", @"usrImgData", @"usrEmail", @"usrId", @"usrMobileNo"]];
                 //Store each dictionary inside the array that we created
                 userDataArray = [[NSMutableArray alloc] init];
                 [userDataArray addObject:userDataCollection];
                 UserDataTable *user = [self addUserInfoToCoreData : userDataArray];
                 [self updateUserDataWithObject:user];
             }
             self.getMyFriendButton.enabled = YES;
             self.deleteDataButton.enabled = YES;
             
             conn = YES;
         }];
    }
    else
    {
        self.usrNameLabel.text = [NSString stringWithFormat:@"Hello : %@",[[MySingleton globalInstance] userName]];
        self.usrImgView.image = [UIImage imageNamed:[[MySingleton globalInstance] userImgName]];
        self.usrEmailLabel.text = [NSString stringWithFormat:@"Email : %@",[[MySingleton globalInstance] userEmail]];
        self.userMobileNoLabel.text = [NSString stringWithFormat:@"MobileNo : %@",[[MySingleton globalInstance] userMobileNo]];
        conn = NO;
    }
    
}

- (void)onProfileUpdated:(NSNotification*)notification {
    conn = NO;
    if ([FBSDKAccessToken currentAccessToken]) {
        //If Logged in
        conn = YES;
        NSLog(@"Login");
        //[self deleteMethod:@"UserDataTable"];
        //[self getUserData];
    } else {
        //Logged out
        //NSLog(@"LogOut");
        [self.getMyFriendButton setEnabled:NO];
        [self.deleteDataButton setEnabled:NO];
    }
    [self getUserData];
}


-(void)deleteMethod : (NSString *) tableName;
{
    NSLog(@"deleteMethod for %@",tableName);
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:appDel.managedObjectContext]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [appDel.managedObjectContext executeFetchRequest:allCars error:&error];
    NSLog(@"AT START Results Count is %li and cars count is %li",[results count], [cars count]);
    //error handling goes here
    if ([cars count] == 0) {
        //NSLog(@"Count == 0");
        if ([tableName isEqualToString:@"FriendsTable"]) {
            objAlert = [[UIAlertView alloc] initWithTitle:@"Sorry, the database is already empty !!" message:@" Please click GetMyfriendslist button to add elements to the database " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        }
        else
        {
            objAlert = [[UIAlertView alloc] initWithTitle:@"Sorry, the database is already empty !!" message:@" Please click Edit button to add user data to the database " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        }
        
        [objAlert show];
        return;
    }
    else
    {
        for (NSManagedObject * car in cars) {
            [appDel.managedObjectContext deleteObject:car];
        }
        NSError *saveError = nil;
        [appDel.managedObjectContext save:&saveError];
    }
    NSLog(@" AT END Results Count is %li and cars count is %li",[results count], [cars count]);
}


// ## Action sheet for deleting user data and friends data when delete button was clicked
- (IBAction)deleteButtonClicked:(UIButton *)sender {
    NSLog(@"deleteButtonClicked");
    objAction = [[UIActionSheet alloc] initWithTitle:@"Select..." delegate:self cancelButtonTitle:@" Cancel " destructiveButtonTitle:Nil otherButtonTitles:@" Delete User Data ",@" Delete Friends List ", @"Schedule Notification",nil];
    objAction.tag = 2;
    [objAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.tag == 1) {
        //NSLog(@"action sheet for getMyFriendsListBtnClicked");
        if (buttonIndex == 0) {
            //NSLog(@"Get Facebook Friends");
            indexLocal = 0;
            [self performSegueWithIdentifier:@"ShowFriendsListSegue" sender:self];
        }
        else if (buttonIndex == 1)
        {
            //NSLog(@"Get Contacts");
            indexLocal = 1;
            [self performSegueWithIdentifier:@"ShowFriendsListSegue" sender:self];
        }
        else if (buttonIndex == 2)
        {
            //NSLog(@"VC.m, buttonIndex == 2, Before Compose Mail method");
            indexLocal = 2;
            
//            showingFriendsViewController * destVC = [[showingFriendsViewController alloc] init];
//            
//            [destVC composeMailMethod:@"Testing"];
            
            [self performSegueWithIdentifier:@"ShowFriendsListSegue" sender:self];
        }
        else
        {
            [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
            return;
        }
    }
    else
    if (buttonIndex == 0) {
        NSLog(@"Delete User Data ButtonClicked");
        [self deleteMethod:@"UserDataTable"];
        [self addingdefaultUserData];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"Delete Friends List ButtonClicked");
        [self deleteMethod:@"FriendsTable"];
    }
    else if (buttonIndex == 2)
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        for (int i=1; i<6; i++) {
            notification.fireDate = [[NSDate date] dateByAddingTimeInterval:10*i];
            notification.alertBody =[NSString stringWithFormat: @"Notification with time interval : 10 Sec with index : %d",i];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            NSLog(@"Notification with time interval : 10 Sec with index : %d",i);
        }
        
    }
    else
    {
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
        return;
    }
    
}

-(void) addingdefaultUserData
{
    NSLog(@"addingdefaultUserData");
    self.usrNameLabel.text = [NSString stringWithFormat:@"Hello : %@",[[MySingleton globalInstance] userName]];
    self.usrImgView.image = [UIImage imageNamed:[[MySingleton globalInstance] userImgName]];
    self.usrEmailLabel.text = [NSString stringWithFormat:@"Email : %@",[[MySingleton globalInstance] userEmail]];
    self.userMobileNoLabel.text = [NSString stringWithFormat:@"MobileNo : %@",[[MySingleton globalInstance] userMobileNo]];
}


// ## get My Friends List btn clicked
- (IBAction)getMyFriendsListBtnClicked:(UIButton *)sender {
    //NSLog(@"getMyFriendsListBtnClicked");
    objAction = [[UIActionSheet alloc] initWithTitle:@"Select..." delegate:self cancelButtonTitle:@" Cancel " destructiveButtonTitle:Nil otherButtonTitles:@" Facebook Friends ",@" Contact List ", @"Compose Email", nil];
    objAction.tag = 1;
    [objAction showInView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
