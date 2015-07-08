//
//  CustomFriendTVCell.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/6/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTable.h"

@interface CustomFriendTVCell : UITableViewCell
{
    UIImage * image;
}

@property (weak, nonatomic) IBOutlet UIImageView *userFriendImgView;

@property (weak, nonatomic) IBOutlet UILabel *userFriendNameLabel;

@property (strong, nonatomic) FriendsTable* currentFriend;

@property (weak, nonatomic) IBOutlet UILabel *userFriendIdLabel;

//Friend property strong

@end
