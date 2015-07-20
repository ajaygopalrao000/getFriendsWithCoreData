//
//  ParentVC.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/16/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

// like it should have an array, title, iboutlets like label and buttons,

#import <UIKit/UIKit.h>

@interface ParentVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSArray * mutArray;
@property (nonatomic, weak) IBOutlet UILabel * welcomeLabel;
@property (nonatomic, weak) IBOutlet UIButton * getMyFriendsBtn;
@property (nonatomic, weak) IBOutlet UIButton * deleteDataBtn;

// ##

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * emailLabel;

@property (nonatomic, weak) IBOutlet UITextField * nameTextField;
@property (nonatomic, weak) IBOutlet UITextField * emailTextField;

// ## KVC, KVO

@property (nonatomic, weak) NSString * username;
@property (nonatomic, weak) NSString * email;

//-(void) observeValues;

- (IBAction)navigationAction:(id)sender;

@end
