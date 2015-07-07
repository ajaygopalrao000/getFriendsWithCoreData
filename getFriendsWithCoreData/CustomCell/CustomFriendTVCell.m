//
//  CustomFriendTVCell.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/6/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "CustomFriendTVCell.h"

@implementation CustomFriendTVCell

//UpdateImageMethod { set image to imageview }

-(void)setCurrentFriend:(FriendsTable *)currentFriend {
    self.currentFriend = currentFriend;
    //upadate label
    //if friendobject.data {  use image }
    //else {friendobject fetchimage , Notification addobserverwithName"UseFriendObjectID" and selector "UpdateImageMethod"}
    //}
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
