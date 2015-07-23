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

//@synthesize blockMethod = _blockMethod;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"ScreenTwoVC, index value : %d",self.index);
    
    // ## Block method
    
    //THIS IS THE MISTAKE
    /*
    self.blockMethod =
    
    _blockMethod = ^(NSString * name, NSString * email)
    {
        
    };*/

}

// Store block so you can call it later
//- (void)doMathWithBlock:(void (^)(NSString *, NSString *))blockMethod {
//    self.blockMethod = blockMethod;
//}


// ## tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField* tf = nil;
    switch ( indexPath.row ) {
        case 0: {
            
            tf = self.nameTextField = [self makeTextField:@""];
            tf.keyboardType = UIKeyboardTypeAlphabet;
            tf.returnKeyType = UIReturnKeyNext;
            [cell addSubview:self.nameTextField];
            break ;
        }
        case 1: {
            tf = self.emailTextField = [self makeTextField:@""];
            tf.keyboardType = UIKeyboardTypeEmailAddress;
            tf.returnKeyType = UIReturnKeyNext;
            [cell addSubview:self.emailTextField];
            break ;
        }
    }
    
    // Textfield dimensions
    tf.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 50);
    
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

- (void)viewWillDisappear:(BOOL)animated {
    if (self.index == KVO || self.index == KVC) {
        [self removeObserver:self.delegate forKeyPath:@"username"];
        [self removeObserver:self.delegate forKeyPath:@"email"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ## done Button Action
- (IBAction)boneBtnClicked:(id)sender {
    NSLog(@"doneButtonClicked");
    
    NSDictionary * dict = [[NSDictionary alloc]initWithObjects:@[self.nameTextField.text, self.emailTextField.text] forKeys:@[@"username", @"email"]];
    
    // ## enum
    
    switch (self.index) {
        case KVC:
            // ## KVC
            [self setValue:self.nameTextField.text forKey:@"username"];
            [self setValue:self.emailTextField.text forKey:@"email"];
            NSLog(@"KVC");
            break;
        case KVO:
            [self setValue:self.nameTextField.text forKey:@"username"];
            [self setValue:self.emailTextField.text forKey:@"email"];
            NSLog(@"KVO");
            break;
        case Categories:
            NSLog(@"Categories");
            break;
        case Subclassing:
            NSLog(@"Subclassing");
            break;
        case Delegation:
            //## Delegates
            NSLog(@"ScreenTwoVC.m, Delegation, username : %@",[dict objectForKey:@"username"]);
            [self.delegate doneBtnClicked:dict];
            NSLog(@"Delegation");
            break;
        case Notification:
            // ## Notification
            [self postNotification:@"secondScreenData" withData:dict];
            NSLog(@"Notification");
            break;
        case Blocks:
            NSLog(@" ScreenTwo, Blocks");
            _blockMethod(self.nameTextField.text, self.emailTextField.text);
            break;
        default:
            NSLog(@"default");
            break;
    }
    
    [self navigationAction:sender];
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
