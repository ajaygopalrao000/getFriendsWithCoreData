//
//  ScreeTwoVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ScreenTwoVC.h"
#import "MySingleton.h"
#import "UIViewController+VCCategory.h"


@interface ScreenTwoVC ()

@end

@implementation ScreenTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// ## tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField* tf = nil;
    switch ( indexPath.row ) {
        case 0: {
            
            tf = self.nameTextField = [self makeTextField:[[MySingleton globalInstance] userName]];
            tf.keyboardType = UIKeyboardTypeAlphabet;
            tf.returnKeyType = UIReturnKeyNext;
            [cell addSubview:self.nameTextField];
            break ;
        }
        case 1: {
            tf = self.emailTextField = [self makeTextField:[[MySingleton globalInstance] userEmail]];
            tf.keyboardType = UIKeyboardTypeEmailAddress;
            tf.returnKeyType = UIReturnKeyNext;
            [cell addSubview:self.emailTextField];
            break ;
        }
    }
    
    // Textfield dimensions
    tf.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
    
    // We want to handle textFieldDidEndEditing
    tf.delegate = self ;
    
    return cell;
}

// ## creating textfield
-(UITextField*) makeTextField: (NSString*)text{
    UITextField *tf = [[UITextField alloc] init];
    // ## NEW
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = text;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return tf ;
}


// ## Text Field Delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    NSLog(@" textFieldShouldChangeCharactersInRange, text field is %@, string is %@ ",textField.text,string );
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldChanged" object:nil];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ## done Button Action
- (IBAction)boneBtnClicked:(id)sender {
    NSLog(@"doneButtonClicked");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldChanged" object:nil];
    [self postNotification:@"secondScreenData"];
    NSDictionary * dict = [[NSDictionary alloc]initWithObjects:@[self.nameTextField.text, self.emailTextField.text] forKeys:@[@"username", @"email"]];
    [self.delegate doneBtnClicked:dict];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
