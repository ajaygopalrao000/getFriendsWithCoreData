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
    
//    [self addListenerMethod:@"secondScreenData"];
    
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
        destVC.delegate = self;
        
//        // ## KVO
        [destVC addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [destVC addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

//// ## Implementing delegate methods of ScreenTwoVC
//-(void) doneBtnClicked : (NSDictionary *) dict;
//{
//    NSLog(@" Recvd doneButtonClicked Delegate");
//    self.nameLabel.text = [dict objectForKey:@"username"];
//    self.emailLabel.text = [dict objectForKey:@"email"];
//}
//
//-------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //UILabel* label = nil;
    switch ( indexPath.row ) {
        case 0: {
            
//            self.nameLabel = [self makeLabel:[[MySingleton globalInstance] userName]];
//            self.nameLabel.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
//            self.nameLabel.text = self.usernameValue;
//            [cell addSubview:self.nameLabel];
            cell.textLabel.text = self.usernameValue;
            break ;
        }
        case 1: {
//            self.emailLabel = [self makeLabel:[[MySingleton globalInstance] userEmail]];
//            self.emailLabel.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
//            self.emailLabel.text = self.emailValue;
//            [cell addSubview:self.emailLabel];
            cell.textLabel.text = self.emailValue;
            break ;
        }
    }
    
    // Textfield dimensions
   // label.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
    
    // We want to handle textFieldDidEndEditing
    //tf.delegate = self ;
    
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
//- (void)notificationTriggerMethod:(NSNotification*)notification {
//    NSLog(@"Notification Recvd");
//    NSDictionary *dict = [notification userInfo];
//    if (dict != nil) {
//            self.nameLabel.text = [dict objectForKey:@"username"];
//            self.emailLabel.text = [dict objectForKey:@"email"];
//              [self removeListenerMethod:@"secondScreenData"];
//    }
//
//}


//// ## KVC, KVO
//
//-(void) observeValues;
//{
//    NSLog(@"observeValues");
//    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//}
//

- (void)navigationAction:(id)sender {
    [self performSegueWithIdentifier:@"GoNextScreen" sender:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    // ## KVO
    NSLog(@"viewWillAppear - ScreenOne");
    [self.myTable reloadData];
//    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
//
//
////------------------------------------------------------------------------------------------------------//
////------------------------------------ ## Using KVO ----------------------------------------------------//
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"observeValueForKeyPath");
    if ([keyPath isEqualToString:@"username"]) {
        NSLog(@"The name of the child was changed, username : %@",[change valueForKey:@"new"]);
        //self.nameLabel.text = [change valueForKey:@"new"];
        self.usernameValue = [change valueForKey:@"new"];
    }
    
    if ([keyPath isEqualToString:@"email"]) {
        NSLog(@"The email of the child was changed, email : %@",[change valueForKey:@"new"]);
        //self.emailLabel.text = [change valueForKey:@"new"];
        self.emailValue = [change valueForKey:@"new"];
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
