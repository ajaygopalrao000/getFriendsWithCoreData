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
#import "showingFriendsViewController.h"
#import "editUserInfoVC.h"

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
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDel = [[UIApplication sharedApplication] delegate];
    self.title = @" List of Friends ";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // ## Camera
//    edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
//    self.navigationItem.rightBarButtonItem = edit;
    
    self.FacebookButton = [[FBSDKLoginButton alloc] init];
    [self.FacebookButton setReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    
    // disabling the buttons
    [self.getMyFriendButton setEnabled:NO];
    [self.deleteDataButton setEnabled:NO];
    
    // calling getUserData method to set the logged in user detail's like name, image.
    [self getUserData];
  
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    
}

// ## storing user data in the database

-(void)addUserInfoToCoreData : (NSMutableArray *) usrDataArray
{
    
    NSLog(@" in addUserInfoToCoreData ");
    NSLog(@" userDataArray size is %li",[userDataArray count]);
    NSDictionary * dict;
    UserDataTable * objUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserDataTable" inManagedObjectContext:appDel.managedObjectContext];
    
    
    dict = [usrDataArray objectAtIndex:0];
    objUser.userName = [dict objectForKey:@"userNme"];
    objUser.userImageData = [dict objectForKey:@"usrImgData"];
    objUser.userEmail = [dict objectForKey:@"usrEmail"];
    objUser.userId = [dict objectForKey:@"usrId"];
    objUser.userMobileNo = [dict objectForKey:@"usrMobileNo"];
    NSLog(@" Name is %@", [dict objectForKey:@"userNme"]);
    NSLog(@" user id  is %@",[dict objectForKey:@"usrId"]);
    NSLog(@" Email is %@",[dict objectForKey:@"usrEmail"]);
    NSError * error;
    [appDel.managedObjectContext save:&error];
        
    if (error == nil) {
        NSLog(@"Success in storing the data");
    }
    
}

// ## Return from editUserinfoVC when user clicks on cancel
-(IBAction)retturnFromeditUserInfoVC:(UIStoryboardSegue*)cancelButton
{
    
}

// get's the details of the user who is currently logged in
- (void) getUserData
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             //NSLog(@"fetched user:");
             if (!error) {
                 //NSLog(@"fetched user:%@", result);
                 NSString *userNme = [result objectForKey:@"name"];
                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                 NSURL *picUrl = [NSURL URLWithString:userImageURL];
                 NSData * usrImgData = [NSData dataWithContentsOfURL:picUrl];
                 NSString * usrEmail = [result objectForKey:@"email"];
                 NSString * usrId = [result objectForKey:@"id"];
                 NSString * usrMobileNo = [NSString stringWithFormat:@"9999999999"];
                 
                 
                 // ## Fetching User data from core data
                 NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"UserDataTable"];
                 NSError * error;
                 NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
                 usrDataSource = [[NSMutableArray alloc] init];
                 [usrDataSource addObjectsFromArray:results];
                 
                 
                 
                 //NSLog(@" results count is %li",[results count]);
                 
                 if (error == nil && [results count] == 1) {
                     NSLog(@" [results count] == 1 ");
                     UserDataTable * objUser = [usrDataSource objectAtIndex:0];
                     self.usrNameLabel.text = [NSString stringWithFormat:@" Hello : %@",objUser.userName];
                     self.usrImgView.image = [UIImage imageWithData:objUser.userImageData];
                     //[self deleteMethod:@"UserDataTable"];
                 }
                 else
                 {
                     NSLog(@" [results count] != 1 ");
                     self.usrNameLabel.text = [NSString stringWithFormat:@" Hello : %@",userNme];
                     self.usrImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picUrl]];
                     userDataCollection = [[NSDictionary alloc]initWithObjects:@[userNme, usrImgData, usrEmail, usrId, usrMobileNo] forKeys:@[@"userNme", @"usrImgData", @"usrEmail", @"usrId", @"usrMobileNo"]];
                     //Store each dictionary inside the array that we created
                     userDataArray = [[NSMutableArray alloc] init];
                     [userDataArray addObject:userDataCollection];
                     [self addUserInfoToCoreData : userDataArray];
                 }
                 
                 
                 self.getMyFriendButton.enabled = YES;
                 self.deleteDataButton.enabled = YES;
                 
                 conn = YES;
             }
         }];
    }
    else
    {
        self.usrNameLabel.text = [NSString stringWithFormat:@" Hello : %@",@"User"];
        self.usrImgView.image = [UIImage imageNamed:@"profile_Pic_Default 128*128"];
        conn = NO;
    }
    
}

- (void)onProfileUpdated:(NSNotification*)notification {
    conn = NO;
    if ([FBSDKAccessToken currentAccessToken]) {
        //If Logged in
        conn = YES;
        //NSLog(@"Login");
        [self deleteMethod:@"UserDataTable"];
        [self getUserData];
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
    //error handling goes here
    if ([cars count] == 0) {
        //NSLog(@"Count == 0");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sorry, the database is already empty !!" message:@" Please click GetMyfriendslist button to add elements to the database " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
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
    
}


- (IBAction)deleteButtonClicked:(UIButton *)sender {
    //NSLog(@"deleteButtonClicked");
    [self deleteMethod:@"FriendsTable"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
