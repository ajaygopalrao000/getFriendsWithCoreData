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
    NSMutableArray * dataSource;
    AppDelegate * appDel;
    
    NSMutableArray *friendsArray;
    NSDictionary *friendCollection;
}
@end

@implementation ViewController

//@synthesize loginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDel = [[UIApplication sharedApplication] delegate];
    
    self.title = @" List of Friends ";
    self.view.backgroundColor = [UIColor whiteColor];
    //[self showFriends];
    
    dataSource = [[NSMutableArray alloc] init];
    //[self addMethod];
    [self deleteMethod];
    
    //REMOVED IT AND ADDED IT AS IBOUTLET
    //IBOUTLETS ARE INITILIAZED BY DEFAULT
    // facebook login
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
   loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    
    UIButton * getFriends = [[UIButton alloc] initWithFrame:CGRectMake(80, 400, 200, 45)];
    [getFriends setTitle:@"Get My Friends List" forState:UIControlStateNormal];
    [getFriends setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [getFriends addTarget:self action:@selector(showFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getFriends];
    
//    UIButton * deleteData = [[UIButton alloc] initWithFrame:CGRectMake(150, 600, 200, 45)];
//    [getFriends setTitle:@"Delete Data" forState:UIControlStateNormal];
//    [getFriends setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [getFriends addTarget:self action:@selector(deleteMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:deleteData];
    
    // NSLog(@" END ");
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
}

- (void)onProfileUpdated:(NSNotification*)notification {
    
}

// Getting facebook data

-(void) showFriends:(UIButton *) btn;
{
    //NSLog(@"showFriends");
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    NSLog(@" results count is %li",[results count]);
    
    if (error == nil && [results count] == 25) {
        NSLog(@" [results count] == 25 ");
        showingFriendsViewController * showNavCont = [[showingFriendsViewController alloc] init];
        [self.navigationController pushViewController:showNavCont animated:YES];
    }
    else
    {
        NSLog(@" [results count] != 25 ");
        [self fetchFacebookFriends:^(NSArray *successArray) {
            self.theFriendsArray = successArray;
            
            
            //COREDATA
            //Prepare the array that we will send
            friendsArray = [[NSMutableArray alloc]init];
            for (NSDictionary *userInfo in successArray)
            {
                
                NSString *userName = [userInfo objectForKey:@"name"];
                NSString *userID = [userInfo objectForKey:@"id"];
                
                NSDictionary *pictureData = [[userInfo objectForKey:@"picture"] objectForKey:@"data"];
                NSString *imageUrl = [pictureData objectForKey:@"url"];
                //Save all the user information in a dictionary that will contain the basic info that we need
                friendCollection = [[NSDictionary alloc]initWithObjects:@[userName, imageUrl, userID] forKeys:@[@"username", @"picURL", @"uId"]];
                //Store each dictionary inside the array that we created
                [friendsArray addObject:friendCollection];
                
            }
            [self addMethod];
            //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                showingFriendsViewController * showNavCont = [[showingFriendsViewController alloc] init];
                [self.navigationController pushViewController:showNavCont animated:YES];
                //[table reloadData];
            });
            
        }error:^(NSString *errorString) {
            
        }];
    }
    
}

-(void)fetchFacebookFriends:(FriendsCallbackSuccess)success error:(FriendsCallbackError)inError {
    
    FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/taggable_friends", [[FBSDKProfile currentProfile] userID]] parameters:Nil HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error == nil) {
            NSArray *allFriends = [result objectForKey:@"data"];
            success(allFriends);
        } else {
            inError(error.description);
        }
    }];
}


-(void)getFacebookFriends: (FriendsCallbackSuccess)success error:(FriendsCallbackError)inError
{
    //NSLog(@"getFacebookFriends");
    ACAccountStore *store = [[ACAccountStore alloc]init];
    //Specify the account that we're going to use, in this case Facebook
    ACAccountType *facebookAccount = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    //Give the app ID (the one we copied before in our FB application at developer's site), permission keys and the audience that can see what we do (in case we do a POST)
    NSDictionary *FacebookOptions = @{ACFacebookAppIdKey: @"872717522798477", ACFacebookPermissionsKey: @[@"public_profile",@"email",@"user_friends"],ACFacebookAudienceKey:ACFacebookAudienceFriends};
    //Request access to the account with the options that we established before
    /*[store requestAccessToAccountsWithType:facebookAccount options:FacebookOptions completion:^(BOOL granted, NSError *error) {
        //Check if everything inside our app that we created at facebook developer is valid
        //if (granted)
        {*/
            NSArray *accounts = [store accountsWithAccountType:facebookAccount];
            //Get the accounts linked to facebook in the device
            if ([accounts count]>0) {
                ACAccount *facebookAccount = [accounts lastObject];
                
                //Set the parameters that we require for our friend list
                NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"picture.width(1000).height(1000),name,link",@"fields", nil];
                //Generate the facebook request to the graph api, we'll call the taggle friends api, that will give us the details from our list of friends
                SLRequest *facebookRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/v2.0/me/taggable_friends"] parameters:param];
                //Set the parameters and request to the FB account
                [facebookRequest setAccount:facebookAccount];
                
                [facebookRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    // Read the returned response
                    if(!error){
                        self.success = success;
                        //Read the response in a JSON format
                        id json =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                        //NSLog(@"Dictionary contains data: %@", json );
                        if([json objectForKey:@"error"]!=nil)
                        {
                        }
                        //Get the data inside of the json in an array
                        NSArray *allFriends = [json objectForKey:@"data"];
                        //Prepare the array that we will send
                        friendsArray = [[NSMutableArray alloc]init];
                        
                        for (NSDictionary *userInfo in allFriends)
                        {
                            
                            NSString *userName = [userInfo objectForKey:@"name"];
                            
                            NSString *userID = [userInfo objectForKey:@"id"];
                            
                            //NSLog(@"user_ID %@",userID);
                            
                            NSDictionary *pictureData = [[userInfo objectForKey:@"picture"] objectForKey:@"data"];
                            NSString *imageUrl = [pictureData objectForKey:@"url"];
                            //Save all the user information in a dictionary that will contain the basic info that we need
                            friendCollection = [[NSDictionary alloc]initWithObjects:@[userName, imageUrl, userID] forKeys:@[@"username", @"picURL", @"uId"]];
                            //Store each dictionary inside the array that we created
                            [friendsArray addObject:friendCollection];
                        }
                       // NSLog(@" The total no. of friends is : %li",[friendsArray count]);
                        [self addMethod];
                        //Send the array that we created to a success call
                        success(friendsArray);
                        
                    }
                }];
            }
        }else{
            //If there was an error, show in console the code number
            NSLog(@"ERROR: %@", error);
            self.error = inError;
        }
        
    }];*/
}

- (void) printArrayValues
{
    NSLog(@" Friends array count is %li",[friendsArray count]);
    for (int i =0; i<25; i++) {
        NSDictionary * dict = [friendsArray objectAtIndex:i];
        NSLog(@" Name %i is %@",i, [dict objectForKey:@"username"]);
        NSLog(@" image url is %@",[dict objectForKey:@"picURL"]);
    }
}




-(void)getEmployeeDataFromCoreData
{
    
    //NSLog(@"getEmployeeDataFromCoreData");
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    NSLog(@" results count is %li",[results count]);
    
    if (error == nil && [results count]>0) {
        
        //        [dataSource removeAllObjects];
        [dataSource addObjectsFromArray:results];
        //        [table reloadData];
        
        for (int i = 0; i<2; i++) {
            FriendsTable * objEmployee = [dataSource objectAtIndex:i];
            NSLog(@" Name %i is %@",i, objEmployee.name);
            NSLog(@" user id %i is %@",i,objEmployee.uId);
            NSLog(@" URl %i is %@",i, objEmployee.url);
        }
        
        
    }
    
}

-(void)addMethod
{
    
    //NSLog(@" in addMethod ");
    NSLog(@" Friends array size is %li",[friendsArray count]);
    NSDictionary * dict;
    for (int i = 0; i<[friendsArray count]; i++) {
    FriendsTable * objFriend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTable" inManagedObjectContext:appDel.managedObjectContext];
        dict = [friendsArray objectAtIndex:i];
        
        NSURL *picUrl = [NSURL URLWithString:[dict objectForKey:@"picURL"]];
        NSData * data = [NSData dataWithContentsOfURL:picUrl];
        objFriend.name = [dict objectForKey:@"username"];
        objFriend.uId = [dict objectForKey:@"uId"];
        objFriend.url = [dict objectForKey:@"picURL"];
        objFriend.data = data;
        
        NSError * error;
    [appDel.managedObjectContext save:&error];
    
    if (error == nil) {
    }
    }
    [self getEmployeeDataFromCoreData];    
    
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
    for (NSManagedObject * car in cars) {
        [appDel.managedObjectContext deleteObject:car];
    }
    NSError *saveError = nil;
    [appDel.managedObjectContext save:&saveError];
    [self getEmployeeDataFromCoreData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
