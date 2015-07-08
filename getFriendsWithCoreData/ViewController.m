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
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "showingFriendsViewController.h"

@interface ViewController ()
{
    AppDelegate * appDel;
    BOOL conn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDel = [[UIApplication sharedApplication] delegate];
    self.title = @" List of Friends ";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
                 self.usrNameLabel.text = [NSString stringWithFormat:@" Hello : %@",userNme];
                 self.usrImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picUrl]];
                 
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
        NSLog(@"Login");
        [self getUserData];
    } else {
        //Logged out
        NSLog(@"LogOut");
        [self.getMyFriendButton setEnabled:NO];
        [self.deleteDataButton setEnabled:NO];
    }
    [self getUserData];
}


-(void)deleteMethod
{
    NSLog(@"deleteMethod");
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"FriendsTable" inManagedObjectContext:appDel.managedObjectContext]];
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
    [self deleteMethod];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
