//
//  ParentVC.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/16/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//


// like it should have an array, title, iboutlets like label and buttons,
#import "ParentVC.h"
#import "MySingleton.h"
#import "ScreenOneVC.h"

@interface ParentVC ()

@end

@implementation ParentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

// ## TableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationAction:(id)sender {
    if (self.navigationController.topViewController == self.navigationController.viewControllers.firstObject) {
        [self performSegueWithIdentifier:@"GoNextScreen" sender:nil];
    } else {
        //[self performSegueWithIdentifier:@"GoBack" sender:nil];
        [self.navigationController popViewControllerAnimated:true];
    }
}

// ## KVC, KVO

//-(void) observeValues;
//{
//    NSLog(@"observeValues");
//    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//}

//- (void) viewWillAppear:(BOOL)animated
//{
//    // ## KVO
//    NSLog(@"viewWillAppear");
//    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:@"email" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//}


//------------------------------------------------------------------------------------------------------//
//------------------------------------ ## Using KVO ----------------------------------------------------//
/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"observeValueForKeyPath");
    if ([keyPath isEqualToString:@"username"]) {
        NSLog(@"The name of the child was changed, username : %@",[change valueForKey:@"new"]);
        //self.nameLabel.text = [change valueForKey:@"new"];
    }
    
    if ([keyPath isEqualToString:@"email"]) {
        NSLog(@"The email of the child was changed, email : %@",[change valueForKey:@"new"]);
        //self.emailLabel.text = [change valueForKey:@"new"];
    }
    
}*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
