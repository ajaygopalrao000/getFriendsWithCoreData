//
//  ScreenOneVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ScreenOneVC.h"
#import "MySingleton.h"
#import "UIColor+ColorCategory.h"
#import "UIViewController+VCCategory.h"

@interface ScreenOneVC ()
{
//    ScreenTwoVC * destVC;
}

@end

@implementation ScreenOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameValue = @"No-Name";
    self.emailValue = @"No-Email";
    
    // ## Calling Enum
    [self displayEnum:self.index];
    
}

//------------------------------------------------------------------------------------------------------//
//------------------------------ ## Using Delegates ----------------------------------------------------//
// ## Segue
// ## performing Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"GoNextScreen"])
    {
        ScreenTwoVC * destVC = (ScreenTwoVC *) segue.destinationViewController;
        NSLog(@"ScreenOne, prepareForSegue");
        destVC.index = self.index;
        
        // ## Delegation
        if (self.index == Delegation) {
            NSLog(@"ScreenOne, Delegation");
            destVC.delegate = self;
        }
        
//        // ## KVO
        if (self.index == KVC || self.index == KVO) {
            NSLog(@"ScreenOne, KVC, KVO");
            destVC.delegate = self;
            [destVC addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [destVC addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        
        // ## Blocks
        if (self.index == Blocks) {
            destVC.delegate = self;
            NSLog(@"ScreenOne, Blocks");
            destVC.blockMethod= ^(NSString * name, NSString * email)
            {
                NSLog(@"ScreenOne, blockMethod, username : %@",name);
                self.nameLabel.text = name;
                self.emailLabel.text= email;
            };
        }
    }
}

//// ## Implementing delegate methods of ScreenTwoVC
-(void) doneBtnClicked : (NSDictionary *) dict;
{
    NSLog(@" Recvd doneButtonClicked Delegate");
    NSLog(@"ScreenOneVC.m, Delegation, username : %@",[dict objectForKey:@"username"]);
    self.nameLabel.text = [dict objectForKey:@"username"];
    self.emailLabel.text= [dict objectForKey:@"email"];
}

//-------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //NSLog(@"ScreenOneVC.m, username value %@",self.usernameValue);
    
    UILabel * label;
    switch ( indexPath.row ) {
        case 0: {
            //cell.textLabel.text = self.usernameValue;
            label = self.nameLabel = [self makeLabel:self.usernameValue];
            [cell addSubview:self.nameLabel];
            break ;
        }
        case 1: {
            //cell.textLabel.text = self.emailValue;
            label = self.emailLabel = [self makeLabel:self.emailValue];
            [cell addSubview:self.emailLabel];
            break ;
        }
    }
    
    // Textfield dimensions
    label.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
    
    return cell;
}

// ## creating textfield
-(UILabel*) makeLabel: (NSString*)text{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor myAppDefaultTextColor];
    return label ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//------------------------------------------------------------------------------------------------------//
//------------------------------ ## Using Notification -------------------------------------------------//
// ## Notification
- (void)notificationTriggerMethod:(NSNotification*)notification {
    NSLog(@"Notification Recvd");
    NSDictionary *dict = [notification userInfo];
    if (dict != nil) {
            self.nameLabel.text = [dict objectForKey:@"username"];
            self.emailLabel.text = [dict objectForKey:@"email"];
              [self removeListenerMethod:@"secondScreenData"];
    }

}


- (void)navigationAction:(id)sender {
    [self performSegueWithIdentifier:@"GoNextScreen" sender:nil];
}


//
////------------------------------------------------------------------------------------------------------//
////------------------------------------ ## Using KVO ----------------------------------------------------//
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"observeValueForKeyPath");
    if ([keyPath isEqualToString:@"username"]) {
        NSLog(@"The name of the child was changed, username : %@",[change valueForKey:@"new"]);
        self.nameLabel.text = [change valueForKey:@"new"];
        //self.usernameValue = [change valueForKey:@"new"];
    }
    
    if ([keyPath isEqualToString:@"email"]) {
        NSLog(@"The email of the child was changed, email : %@",[change valueForKey:@"new"]);
        self.emailLabel.text = [change valueForKey:@"new"];
        //self.emailValue = [change valueForKey:@"new"];
    }
    
}

// ## enumMethod

- (void) displayEnum : (int) indexL;
{
    //NSLog(@"displayEnum, recvd index : %d",indexL);
    switch (indexL) {
        case KVC:
            NSLog(@"KVC");
            break;
        case KVO:
            NSLog(@"KVO");
            break;
        case Categories:
            NSLog(@"Categories");
            break;
        case Subclassing:
            NSLog(@"Subclassing");
            break;
        case Delegation:
            NSLog(@"Delegation");
            break;
        case Notification:
            [self addListenerMethod:@"secondScreenData"];
            NSLog(@"Notification");
            break;
        case Blocks:
            NSLog(@"Blocks");
            break;
        default:
            NSLog(@"default");
            break;
    }
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
