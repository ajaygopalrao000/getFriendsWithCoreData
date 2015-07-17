//
//  ParentVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/16/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//


// like it should have an array, title, iboutlets like label and buttons,
#import "ParentVC.h"

@interface ParentVC ()

@end

@implementation ParentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationAction:(id)sender {
    if (self.navigationController.topViewController == self.navigationController.viewControllers.firstObject) {
        [self performSegueWithIdentifier:@"GoNextScreen" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"GoBack" sender:nil];
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
