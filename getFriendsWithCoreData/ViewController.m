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
    
    // ## for camera
    UIActionSheet * objAction;
    UIBarButtonItem * add;
    UIAlertView * objAlert;
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
    add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addButtonClicked:)];
    self.navigationItem.rightBarButtonItem = add;
    
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


// ## Camera

- (void) addButtonClicked:(id ) addLocal;
{
    objAction = [[UIActionSheet alloc] initWithTitle:@"Select..." delegate:self cancelButtonTitle:@" Cancel " destructiveButtonTitle:Nil otherButtonTitles:@"Camera",@" Photo Library ", nil];
    [objAction showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    UIImagePickerController * objIMGPicker = [[UIImagePickerController alloc] init];
    objAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:@" The Emulator Doesn't Support Camera" delegate:self cancelButtonTitle:@" OK " otherButtonTitles:nil];
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            objIMGPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
        {
            [objAlert show];
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
        return;
    }
    else if (buttonIndex == 1)
    {
        objIMGPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        objIMGPicker.delegate = self;
        objIMGPicker.allowsEditing = YES;
        [self presentViewController:objIMGPicker animated:YES completion:NULL];
        
    }
    else
    {
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
        return;
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage * selImg = [info objectForKey:UIImagePickerControllerEditedImage];
    self.usrImgView.image = [self adjustImageSizeWhenCropping:selImg];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(UIImage *)adjustImageSizeWhenCropping:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float ratio=300/actualWidth;
    actualHeight = actualHeight*ratio;
    CGRect rect = CGRectMake(0.0, 0.0, 300, actualHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
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
        //NSLog(@"Login");
        [self getUserData];
    } else {
        //Logged out
        //NSLog(@"LogOut");
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
