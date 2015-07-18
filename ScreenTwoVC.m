//
//  ScreeTwoVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/17/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ScreenTwoVC.h"
#import "MySingleton.h"

@interface ScreenTwoVC ()

@end

@implementation ScreenTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ## done Button Action
- (IBAction)boneBtnClicked:(id)sender {
    NSLog(@"doneButtonClicked");
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
