//
//  ParentVC.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/16/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

// like it should have an array, title, iboutlets like label and buttons,

#import <UIKit/UIKit.h>

@interface ParentVC : UIViewController

@property (nonatomic, weak) NSArray * mutArray;
@property (nonatomic, weak) IBOutlet UILabel * welcomeLabel;
@property (nonatomic, weak) IBOutlet UIButton * getMyFriendsBtn;
@property (nonatomic, weak) IBOutlet UIButton * deleteDataBtn;

- (IBAction)navigationAction:(id)sender;
+(id) setTitle:(NSString *)title;

@end
