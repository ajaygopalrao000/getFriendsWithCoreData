//
//  editUserInfoVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/8/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "editUserInfoVC.h"
#import "UserDataTable.h"
#import "ViewController.h"
#import "AppDelegate.h"

#define NUMBERS_ONLY @"1234567890"
#define NUMBER_LIMIT 10

#define LETTERS_ONLY @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define LETTER_LIMIT 25


@interface editUserInfoVC ()
{
    UIBarButtonItem * done, * cancel;
    
    AppDelegate * appDel;
    UserDataTable *objUserDataRef;
    
    BOOL didEdit;
}

@end

@implementation editUserInfoVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    appDel = [[UIApplication sharedApplication] delegate];
    
    
    // ## creating reference for UserDataTable table
    
    objUserDataRef = [NSEntityDescription insertNewObjectForEntityForName:@"UserDataTable" inManagedObjectContext:appDel.managedObjectContext];
    if ([self.delegate respondsToSelector:@selector(getCurrentUser)]) {
        objUserDataRef = [self.delegate getCurrentUser];
    }
    
    // ## Table View
//    tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, self.view.frame.size.height) style:UITableViewStyleGrouped];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
    
    // ## alert View
    objAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:@" Default " delegate:self cancelButtonTitle:@" OK " otherButtonTitles:nil];
    
    // ## didEdit => flag to check whether the data has been updated or not
    didEdit = NO;
    
}


//## deleting previous data
-(void)deleteMethod : (NSString *) tableName;
{
    //NSLog(@"deleteMethod for %@",tableName);
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

// ## storing user data in the database

-(void)addUserInfoToCoreData
{
    
        //NSLog(@" in addUserInfoToCoreData ");
        [self deleteMethod:@"UserDataTable"];
        objUserDataRef = [NSEntityDescription insertNewObjectForEntityForName:@"UserDataTable" inManagedObjectContext:appDel.managedObjectContext];
        objUserDataRef.userName = nameTextField.text;
        objUserDataRef.userEmail = emailTextField.text;
        objUserDataRef.userMobileNo = mobileNoTextField.text;
        if (usrImgData != nil) {
            objUserDataRef.userImageData = usrImgData;
        }
        else if (objUserDataRef.userImageData == nil)
        {
            UIImage * img = [UIImage imageNamed:@"profile_Pic_Default 128*128"];
            usrImgData = [NSData dataWithData:UIImagePNGRepresentation(img)];
            objUserDataRef.userImageData = usrImgData;
        }
        
        NSError * error;
        [appDel.managedObjectContext save:&error];
        
        if (error == nil) {
            //NSLog(@"Success in storing the data");
            NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"UserDataTable"];
            NSError * error;
            NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
            NSMutableArray *usrDataSource = [[NSMutableArray alloc] init];
            [usrDataSource addObjectsFromArray:results];
            
            //NSLog(@" results count is %li",[results count]);
            
            if (error == nil && [results count] == 1) {
                //            NSLog(@" [results count] == 1 ");
            }
        }
    
    
}


// ## Done Button Clicked
- (IBAction)doneButtonClicked:(id)sender {
    NSLog(@"doneButtonClicked");
    if(nameTextField.text.length>0 && emailTextField.text.length>0 && mobileNoTextField.text.length == 10)
    {
        if ([self validateEmail:emailTextField.text]) {
            NSLog(@"Success");
            NSLog(@"doneButtonClicked didEdit : %d",didEdit);
            if (didEdit)
                [self addUserInfoToCoreData];
            //Add check if responds to selctor
            [self.delegate doneBtnClicked:self didChooseValue:didEdit withUpdateddataRef:objUserDataRef];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"Email wrong");
            objAlert.message = @"Wrong Email format";
            [objAlert show];
        }
        
    }
    else
    {
        NSLog(@" Failed ");
        if (nameTextField.text.length==0 && emailTextField.text.length == 0 && mobileNoTextField.text.length == 0)
            objAlert.message = @ " Follow the constraints and fill all the fields ";
        else if (nameTextField.text.length==0)
            objAlert.message = @ " Fill some thing in name TextField  ";
        else if (emailTextField.text.length==0)
            objAlert.message = @ " Fill some thing in Email TextField ";
        else if (mobileNoTextField.text.length == 0)
            objAlert.message = @ " Fill some thing in mobileNo TextField";
        else if (mobileNoTextField.text.length <= 10 || mobileNoTextField.text.length >= 10)
            objAlert.message = @" Mobile No should be of size exactly 10 numbers";
        [objAlert show];
        
    }
}

// ## table View delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 1 && indexPath.row == 1) {
            return 200;
    }
    return 40.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 3;
    }
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField* tf = nil;
    UIImageView * imgVw = nil;
    UIButton * selImgButton = nil;
    if (indexPath.section == 0) {
        switch ( indexPath.row ) {
            case 0: {
                cell.textLabel.text = @"Name" ;
                if ([objUserDataRef.userName length] == 0)
                    tf = nameTextField = [self makeTextField:self.name placeholder:@"User"];
                else
                    tf = nameTextField = [self makeTextField:self.name placeholder:objUserDataRef.userName];
                tf.returnKeyType = UIReturnKeyNext;
                [cell addSubview:nameTextField];
                break ;
            }
            case 1: {
                cell.textLabel.text = @"Email" ;
                if ([objUserDataRef.userName length] == 0)
                    tf = emailTextField = [self makeTextField:self.email placeholder:@"xyz@domain.com"];
                else
                    tf = emailTextField = [self makeTextField:self.email placeholder:objUserDataRef.userEmail];
                tf.keyboardType = UIKeyboardTypeEmailAddress;
                tf.returnKeyType = UIReturnKeyNext;
                [cell addSubview:emailTextField];
                break ;
            }
            case 2: {
                cell.textLabel.text = @"MobileNo" ;
                if ([objUserDataRef.userName length] == 0)
                    tf = mobileNoTextField = [self makeTextField:self.mobileNo placeholder:@"9999999999"];
                else
                    tf = mobileNoTextField = [self makeTextField:self.mobileNo placeholder:objUserDataRef.userMobileNo];
                tf.keyboardType = UIKeyboardTypeNumberPad;
                [cell addSubview:mobileNoTextField];
                break ;
            }
        }

    }
    else if(indexPath.section == 1)
    {
        switch ( indexPath.row ) {
            case 0: {
                //NSLog(@"indexPath.section == 1 && Case 0");
                cell.textLabel.text = @"Choose profile picture" ;
                selImgButton = choosePictureButton = [self makeButtonwithTitle:@"Choose"];
                [cell addSubview:choosePictureButton];
                break;
            }
            case 1: {
                //NSLog(@"indexPath.section == 1 && Case 1");
                if (objUserDataRef.userImageData == nil) {
                    imgVw = selectedImgView = [self makeImgViewwithImg:[UIImage imageNamed:@"profile_Pic_Default 128*128"]];
                }
                else
                {
                    imgVw = selectedImgView = [self makeImgViewwithImg:[UIImage imageWithData:objUserDataRef.userImageData]];
                    usrImgData = objUserDataRef.userImageData;
                }
                [cell addSubview:selectedImgView];
                break;
            }
        }
    }
    // Textfield dimensions
    tf.frame = CGRectMake(120, 5, self.view.frame.size.width-130, 30);
    
    // We want to handle textFieldDidEndEditing
    tf.delegate = self ;
    
    return cell;
}

// ## creating textfield
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    UITextField *tf = [[UITextField alloc] init];
    // ## NEW
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = placeholder;
    tf.textAlignment = NSTextAlignmentLeft;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return tf ;
}

-(UIButton*) makeButtonwithTitle: (NSString *)title
{
    UIButton * selImgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selImgButton setTitle:title forState:UIControlStateNormal];
    [selImgButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    selImgButton.frame = CGRectMake(220, 5, 100, 30);
    selImgButton.backgroundColor = [UIColor whiteColor];
    selImgButton.layer.cornerRadius = 5;
    selImgButton.layer.borderWidth = 1;
    selImgButton.layer.borderColor = [UIColor blueColor].CGColor;
    [selImgButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selImgButton addTarget:self action:@selector(selImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return selImgButton;
}

-(UIImageView*) makeImgViewwithImg: (UIImage *)img
{
    //NSLog(@"makeImgViewwithImg");
    UIImageView * imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(80, 20, 200, 160)];
    [imgVw setImage:img];
    return imgVw;
}

- (void) selImgBtnClicked : (UIButton *) btn
{
    //NSLog(@"selImgBtnClicked");
    objAction = [[UIActionSheet alloc] initWithTitle:@"Select..." delegate:self cancelButtonTitle:@" Cancel " destructiveButtonTitle:Nil otherButtonTitles:@"Camera",@" Photo Library ", nil];
    [objAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    UIImagePickerController * objIMGPicker = [[UIImagePickerController alloc] init];
    objAlert.message = @"The Emulator Doesn't Support Camera";
    
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
    selectedImgView.image = [self adjustImageSizeWhenCropping:selImg];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    didEdit = YES;
    NSLog(@"imagePickerController didEdit : %d",didEdit);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(UIImage *)adjustImageSizeWhenCropping:(UIImage *)image
{
    NSLog(@"adjustImageSizeWhenCropping");
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float ratio=300/actualWidth;
    actualHeight = actualHeight*ratio;
    CGRect rect = CGRectMake(0.0, 0.0, 200, actualHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    usrImgData = [NSData dataWithData:UIImagePNGRepresentation(img)];
    
    return img;
}

// ## textField delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    //NSLog(@" textFieldShouldChangeCharactersInRange " );
    didEdit = YES;
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == mobileNoTextField)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= NUMBER_LIMIT));
        
    }
    else if (textField == nameTextField)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LETTERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= LETTER_LIMIT));
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
{
    //done.enabled = NO;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    if (textField == nameTextField)
        [emailTextField becomeFirstResponder];
    else if (textField == emailTextField)
        [mobileNoTextField becomeFirstResponder];
    return YES;
}


// ## Validate Email ##
- (BOOL) validateEmail: (NSString *) email {
    //NSLog(@"Recvd email : %@",email);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
