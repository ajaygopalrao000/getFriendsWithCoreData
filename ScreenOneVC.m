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

@interface ScreenOneVC ()

@end

@implementation ScreenOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        destVC.delegate = self;
    }
}

// ## Implementing delegate methods of ScreenTwoVC
-(void) doneBtnClicked : (NSDictionary *) dict;
{
    NSLog(@" Recvd doneButtonClicked Delegate");
    self.nameLabel.text = [dict objectForKey:@"username"];
    self.emailLabel.text = [dict objectForKey:@"email"];
}

//-------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel* label = nil;
    switch ( indexPath.row ) {
        case 0: {
            
            label = self.nameLabel = [self makeLabel:[[MySingleton globalInstance] userName]];
            [cell addSubview:self.nameLabel];
            break ;
        }
        case 1: {
            label = self.emailLabel = [self makeLabel:[[MySingleton globalInstance] userEmail]];
            [cell addSubview:self.emailLabel];
            break ;
        }
    }
    
    // Textfield dimensions
    label.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 40);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
