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
#import "CustomFriendTVCell.h"
#import <Social/Social.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface showingFriendsViewController ()
{
    AppDelegate * appDel;
    
    
    NSMutableArray *friendsArray, * contactList;
    NSDictionary *friendCollection;
    int count, iterationCount;
    
    FriendsTable *objEmployee;
}
@end


@implementation showingFriendsViewController

@synthesize colorString;

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    iterationCount = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    dataSource = [[NSMutableArray alloc] init];
    
    if (self.index == 0) {
        self.title = @" Friends List ";
        appDel = [[UIApplication sharedApplication] delegate];
        [self showFriends];
    }
    else
    {
        [self getPersonOutOfAddressBook];
        self.title = @"Contacts List";
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    //NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSLog(@" in cellForRowAtIndexPath start ");
    
    
    // ## logic for fb friends
    if (self.index == 0) {
        // Custom Cell
        static NSString *simpleTableIdentifier = @"CustomFriendTVCell";
        
        CustomFriendTVCell *cell = (CustomFriendTVCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
            
        {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomFriendTVCell" owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        
        objEmployee = [dataSource objectAtIndex:indexPath.row];
        [cell updateCurrentFriend:objEmployee];
        return cell;
    }
    
    else if (self.index == 1)
    {
        UITableViewCell * cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        NSDictionary * dict = [dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:@"name"];
        if ([dict objectForKey:@"number"] != nil) {
            cell.detailTextLabel.text = [dict objectForKey:@"number"];
        }
        else
            cell.detailTextLabel.text = @"NO NUMBER";
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString * name;
    if (self.index == 0) {
        objEmployee = [dataSource objectAtIndex:indexPath.row];
        name = objEmployee.name;
    }
    else
    {
        NSDictionary * dict = [dataSource objectAtIndex:indexPath.row];
        name = [dict objectForKey:@"name"];
    }
    [self composeMailMethod : name];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}


// retrieving friends list

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
        [_table reloadData];
        
    }
}


-(void) showFriends
{
    //NSLog(@"showFriends");
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    //NSLog(@" results count is %li",[results count]);
    
    if (error == nil && [results count] == 25) {
        NSLog(@" [results count] == 25 ");
        
        [dataSource removeAllObjects];
        [dataSource addObjectsFromArray:results];
        [_table reloadData];
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
    for (int i = 0; i<[friendsArray count]; i++) {
        FriendsTable * objFriend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTable" inManagedObjectContext:appDel.managedObjectContext];
        dict = [friendsArray objectAtIndex:i];
        
        objFriend.name = [dict objectForKey:@"username"];
        objFriend.uId = [dict objectForKey:@"uId"];
        objFriend.url = [dict objectForKey:@"picURL"];
        NSError * error;
        [appDel.managedObjectContext save:&error];
        
        if (error == nil) {
        }
    }
    [self getEmployeeDataFromCoreData];    
    
}


// ## Logic For Contact List

// ## new method for getting contacts

- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
    }
    if (addressBook != nil) {
        NSLog(@"Succesful.");
        
        //2
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //3
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            //4
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,
                                                                                  kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            // ## phoneNumber
            ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            NSMutableDictionary * objDict = [[NSMutableDictionary alloc]init];
            for (CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
            {
                NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones,i));
                //NSLog(@"ShowingFriendsVC, phone is %@",phone);
                [objDict setObject:phone forKey:@"number"];
            }
            
            //NSLog(@"ShowingFriendsVC, person full name is %@",fullName);
            
            
            [objDict setObject:fullName forKey:@"name"];
            [dataSource addObject:objDict];
            
            //NSLog(@"ShowingFriendsVC, getPersonOutOfAddressBook, datasource count : %li",[dataSource count]);
            
            [_table reloadData];
        }
    } else {
        //9
        NSLog(@"Error reading Address Book");
    } 
}


// ## Compose Mail

-(void)composeMailMethod : (NSString * )name;
{
//    NSLog(@"trimmed : %@",trimmed);
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Composing Mail"];
    [mailComposer setMessageBody:[NSString stringWithFormat:@" Hello %@, How r u ?",name] isHTML:NO];
//    [mailComposer setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@@gmail.com",[name stringByReplacingOccurrencesOfString:@" " withString:@"."]], nil]];
//    dispatch_queue_t mailQueue = dispatch_queue_create("Mail Queue",NULL);
//    dispatch_async(mailQueue, ^{
//        NSString *trimmed = [name stringByReplacingOccurrencesOfString:@" " withString:@"."];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [mailComposer setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@@gmail.com",trimmed], nil]];
//        });
//        
//    });
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
