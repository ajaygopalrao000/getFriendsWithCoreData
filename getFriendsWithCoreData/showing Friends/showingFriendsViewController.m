//
//  showingFriendsViewController.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/29/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "showingFriendsViewController.h"
#import "FriendsTable.h"
#import "AppDelegate.h"
#import "ExampleStoryBoardVC.h"
#import "CustomFriendTVCell.h"
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface showingFriendsViewController ()
{
    AppDelegate * appDel;
    
    
    NSMutableArray *friendsArray;
    NSDictionary *friendCollection;
    int count;
}
@end


@implementation showingFriendsViewController

@synthesize colorString;

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    
    self.title = @" Friends List ";
    self.view.backgroundColor = [UIColor whiteColor];
    appDel = [[UIApplication sharedApplication] delegate];
    dataSource = [[NSMutableArray alloc] init];
    
    [self showFriends];
    
    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self getEmployeeDataFromCoreData];
    
}

//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showStoryBoard"]) {
//        ExampleStoryBoardVC * destinationViewController = (ExampleStoryBoardVC *)segue.destinationViewController;
//        destinationViewController.titleString = @"purple";
//    }
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    //NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [dataSource count];
    //return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSLog(@" in cellForRowAtIndexPath start ");
    
    // Custom Cell
    
    static NSString *simpleTableIdentifier = @"CustomFriendTVCell";
    
    CustomFriendTVCell *cell = (CustomFriendTVCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        
    {
        
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomFriendTVCell" owner:self options:nil];
        
        cell = [nibArray objectAtIndex:0];
        
    }
    
    UIImage * image;
    
    //FriendsTable * objEmployee = [[FriendsTable alloc] init];
    
    FriendsTable * objEmployee = [dataSource objectAtIndex:indexPath.row];
    
    // retrieved stored data of the image from core data
    
    
    // Setting the friend object
//    if (count++<1) {
//        NSLog(@" before setting the Friend object ");
//    }
    
    //cell.currentFriend = objEmployee;
    [cell updateCurrentFriend:objEmployee];
    /*
    // ## Checking data in friend object
    if (objEmployee.data != nil) {
        NSLog(@"objEmployee.data != nil");
        image = [UIImage imageWithData:objEmployee.data];
        cell.userFriendImgView.image = image;
    }
    else
    {
        NSLog(@"objEmployee.data == nil");
    }
    
    cell.userFriendNameLabel.text = objEmployee.name;
    
    cell.userFriendIdLabel.text = objEmployee.uId;
    */
    
    return cell;
    
}

-(void)getEmployeeDataFromCoreData
{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    //NSLog(@" results count in showingFriendsViewController is %li",[results count]);
    
    if (error == nil) {
        //NSLog(@"error == nil");
        [dataSource removeAllObjects];
        [dataSource addObjectsFromArray:results];
        [table reloadData];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}


// retrieving friends list

-(void) showFriends
{
    //NSLog(@"showFriends");
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    //NSLog(@" results count is %li",[results count]);
    
    if (error == nil && [results count] == 25) {
        NSLog(@" [results count] == 25 ");
        return;
    }
    else
    {
        NSLog(@" [results count] != 25 ");
        [self fetchFacebookFriends:^(NSArray *successArray) {
            self.theFriendsArray = successArray;
            //COREDATA
            //vPrepare the array that we will send
            friendsArray = [[NSMutableArray alloc]init];
            for (NSDictionary *userInfo in successArray)
            {
                
                NSString *userName = [userInfo objectForKey:@"name"];
                NSString *userID = [userInfo objectForKey:@"id"];
                
                NSDictionary *pictureData = [[userInfo objectForKey:@"picture"] objectForKey:@"data"];
                //NSLog(@"Picture data is %@",pictureData);
                NSString *imageUrl = [pictureData objectForKey:@"url"];
                //Save all the user information in a dictionary that will contain the basic info that we need
                friendCollection = [[NSDictionary alloc]initWithObjects:@[userName, imageUrl, userID] forKeys:@[@"username", @"picURL", @"uId"]];
                //Store each dictionary inside the array that we created
                [friendsArray addObject:friendCollection];
                
            }
            [self addMethod];
            //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
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
            NSLog(@"Error in fetchFacebookFriends");
            return ;
        }
    }];
}


-(void)addMethod
{
    
    //NSLog(@" in addMethod ");
    //NSLog(@" Friends array size is %li",[friendsArray count]);
    NSDictionary * dict;
    int lCount = 0;
    for (int i = 0; i<[friendsArray count]; i++) {
        FriendsTable * objFriend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTable" inManagedObjectContext:appDel.managedObjectContext];
        dict = [friendsArray objectAtIndex:i];
        
        //        NSURL *picUrl = [NSURL URLWithString:[dict objectForKey:@"picURL"]];
        //        //You are saving it ahead of time, but I want you to get it when it is showed to user, You need to do lazy loading, Think about 1000 friends lets say, You cannot get all of them at once
        //You need to do it in cell for row //USE NSURLConnection sendAsynchronousRequest
        //I have added a class for FriendsTable(NSManagedobject) that links to coredata entity you created before, Add a method under that class for fetching image
        //To add a class for enity , select that entity under xcdatamodel and Editor -> create new NSManagedObjectModel
        //Show loading if it is fetching
        //Get rid of other friendsTable class
        
//        NSURL *picUrl = [NSURL URLWithString:[dict objectForKey:@"picURL"]];
//        NSData * data = [NSData dataWithContentsOfURL:picUrl];
        
        objFriend.name = [dict objectForKey:@"username"];
        objFriend.uId = [dict objectForKey:@"uId"];
        objFriend.url = [dict objectForKey:@"picURL"];
//        objFriend.data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"picURL"]]]
//        ;
        
        // Continue doing other stuff while images load.
        
        
        //NSLog(@" i is %i",i);
        NSError * error;
        [appDel.managedObjectContext save:&error];
        
        if (error == nil) {
        }
    }
    [self getEmployeeDataFromCoreData];    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
