//
//  DesignPatternsVC.m
//  getFriendsWithCoreData
//
//  Created by Vemula, Manoj (Contractor) on 7/16/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "CustomFriendTVCell.h"
#import "DesignPatternsVC.h"
#import "ScreenOneVC.h"
#import "ParentVC.h"

@interface DesignPatternsVC () < UITableViewDelegate>
{
    NSArray *tableArray;
    
    int index;
}

@end

@implementation DesignPatternsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableArray = @[@"KVC", @"KVO", @"Categories",
                   @"Subclassing", @"Delegation", @"Notification",@"Blocks"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    //NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return tableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = tableArray[indexPath.row];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    index = (int)indexPath.row;
    [self performSegueWithIdentifier:@"DesignPatterntoScreenOne" sender:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"DesignPatterntoScreenOne"])
    {
        ScreenOneVC * destVC = (ScreenOneVC *) segue.destinationViewController;
        //destVC.delegate = self;
        destVC.index = index;
        //NSLog(@"DesignPatternsVC.m, after setting index : %d",index);
        
    }
}


@end
