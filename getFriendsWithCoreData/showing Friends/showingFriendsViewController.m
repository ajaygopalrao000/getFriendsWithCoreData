//
//  showingFriendsViewController.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/29/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "showingFriendsViewController.h"
#import "FriendsTable.h"
#import "AppDelegate.h"

@interface showingFriendsViewController ()
{
    AppDelegate * appDel;
}
@end

@implementation showingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Core Data
    
    self.title = @" Friends List ";
    self.view.backgroundColor = [UIColor whiteColor];
    appDel = [[UIApplication sharedApplication] delegate];
    dataSource = [[NSMutableArray alloc] init];
    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self getEmployeeDataFromCoreData];
    
    //selectedIndex = -1;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    //NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    //    return [dataSource count];
    //NSLog(@"numberOfRowsInSection with count is %li ",[friendsArray count]);
    //return [friendsArray count];
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSLog(@" in cellForRowAtIndexPath start ");
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //NSLog(@"friendsArray size is %li",[friendsArray count]);
//    NSDictionary * dict = [friendsArray objectAtIndex:indexPath.row];
//    UIImage *image;
//    //Get the image from the url received
//    NSURL *picUrl = [NSURL URLWithString:[dict objectForKey:@"picURL"]];
//    
//    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picUrl]];
//    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    //Hide the activity indicator
//    [cell.imageView setNeedsLayout];
//    cell.imageView.image = image;
//    
//    cell.textLabel.text = [dict objectForKey:@"username"];
//    cell.detailTextLabel.text = [dict objectForKey:@"uId"];
//    //cell.imageView.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
//    
//    
    UIImage * image;
    
    FriendsTable * objEmployee = [dataSource objectAtIndex:indexPath.row];
    NSURL *picUrl = [NSURL URLWithString:objEmployee.url];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picUrl]];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        //Hide the activity indicator
    [cell.imageView setNeedsLayout];
    cell.imageView.image = image;
    
    cell.textLabel.text = objEmployee.name;
    //cell.detailTextLabel.text = objEmployee.empId;
    return cell;
    
}

-(void)getEmployeeDataFromCoreData
{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"FriendsTable"];
    
    NSError * error;
    
    NSArray * results = [appDel.managedObjectContext executeFetchRequest:fetch error:&error];
    NSLog(@" results count in showingFriendsViewController is %li",[results count]);
    
    if (error == nil) {
        NSLog(@"error == nil");
        [dataSource removeAllObjects];
        [dataSource addObjectsFromArray:results];
        [table reloadData];
        
    }
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
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
