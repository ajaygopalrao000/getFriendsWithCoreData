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
    //editUserInfoVC *objeditUserInfoVC;
    
    UserDataTable * objUser;
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
    
    // calling getUserData method to set the logged in user detail's like name, image.
    [self getUserData];
  
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    
    // ## calling delegate methods for editUserInfoVC
    //objeditUserInfoVC.delegate = self;
    
}

// ## performing Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueToEditUserInfoVC"])
    {
        editUserInfoVC * destVC = (editUserInfoVC *) segue.destinationViewController;
        destVC.delegate = self;
    }
}

// ## editUSerInfoVCDelegate Moethods
-(void) doneBtnClicked : (editUserInfoVC*)viewController
        didChooseValue : (BOOL) flag updatedDataRef : (UserDataTable *) updatedDataRef;
{
    NSLog(@"In ViewController, doneBtnClicked method, flag : %s",flag ? "True" : "False");
    if (flag) {/*
        if (updatedDataRef != nil) {
            NSLog(@" In doneBtnClicked with updatedDataRef reference and name is : %@",updatedDataRef.userName);
            objUser = updatedDataRef;
            NSLog(@" In doneBtnClicked with objUser reference and name is : %@",objUser.userName);
        }*/
        [self updateUserDataWithObject:objUser];
        //[self getUserData];
    }
}
- (UserDataTable*)getCurrentUser
{
    NSLog(@" Name in getCurrentUser is %@", objUser.userName);
    return objUser;
}

// ## storing user data in the database

-(UserDataTable*)addUserInfoToCoreData : (NSMutableArray *) usrDataArray
{
    
    NSLog(@" in addUserInfoToCoreData ");
    NSLog(@" userDataArray size is %li",[userDataArray count]);
    NSDictionary * dict;
    objUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserDataTable" inManagedObjectContext:appDel.managedObjectContext];
    
    
    dict = [usrDataArray objectAtIndex:0];
    objUser.userName = [dict objectForKey:@"userNme"];
    objUser.userImageData = [dict objectForKey:@"usrImgData"];
    objUser.userEmail = [dict objectForKey:@"usrEmail"];
    objUser.userId = [dict objectForKey:@"usrId"];
    objUser.userMobileNo = [dict objectForKey:@"usrMobileNo"];
//    NSLog(@" Name is %@", [dict objectForKey:@"userNme"]);
//    NSLog(@" user id  is %@",[dict objectForKey:@"usrId"]);
//    NSLog(@" Email is %@",[dict objectForKey:@"usrEmail"]);
    NSError * error;
    [appDel.managedObjectContext save:&error];
        
    if (error == nil) {
        NSLog(@"Success in storing the data");
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
        if (objUser.userName != nil) {
            NSLog(@" In getUserData with objUser reference and name is : %@",objUser.userName);
            self.usrNameLabel.text = [NSString stringWithFormat:@" Hello : %@",objUser.userName];
            self.usrImgView.image = [UIImage imageWithData:objUser.userImageData];
            self.usrEmailLabel.text = [NSString stringWithFormat:@" Email : %@",objUser.userEmail];
            self.userMobileNoLabel.text = [NSString stringWithFormat:@" Mobile No : %@",objUser.userMobileNo];
        }
        else
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             //NSLog(@"fetched user:");
                 NSString * usrId = [result objectForKey:@"id"];
                 NSString * usrMobileNo = [NSString stringWithFormat:@"9999999999"];
                 
                 // ## Fetching User data from core data
                 NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"UserDataTable"];
                 NSError * errorDatabase;
                 NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&errorDatabase];
                 usrDataSource = [[NSMutableArray alloc] init];
                 [usrDataSource addObjectsFromArray:results];
             
                 
                 if (!error && errorDatabase == nil && [results count] == 1) {
                     NSLog(@" [results count] == 1 ");
                     objUser = [usrDataSource objectAtIndex:0];
                     [self updateUserDataWithObject:objUser];

                     //[self deleteMethod:@"UserDataTable"];
                 }
                 else if(!error)
                 {
                     NSLog(@"fetched user:%@", result);
                     NSString *userNme = [result objectForKey:@"name"];
                     NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                     NSURL *picUrl = [NSURL URLWithString:userImageURL];
                     NSData * usrImgData = [NSData dataWithContentsOfURL:picUrl];
                     NSMutableString * usrEmail = [NSMutableString stringWithString:@"email"];
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
        NSLog(@"Login");
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

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
