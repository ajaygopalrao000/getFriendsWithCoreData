//
//  ExampleStoryBoardVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/1/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ExampleStoryBoardVC.h"

@interface ExampleStoryBoardVC ()

@end

@implementation ExampleStoryBoardVC

//@synthesize title;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.exampleLabel.text = self.titleString;
    
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
