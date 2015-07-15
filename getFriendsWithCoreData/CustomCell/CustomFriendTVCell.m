//
//  CustomFriendTVCell.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/6/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "CustomFriendTVCell.h"

@implementation CustomFriendTVCell

-(void)updateImageMethod: (NSNotification*)note {
    //NSLog(@" Friend object is Downloaded and Updated");
    self.userFriendImgView.image = [UIImage imageWithData:_currentFriend.data];
}

-(void)updateCurrentFriend:(FriendsTable *)currentFriend {
    self.currentFriend = currentFriend;
    self.userFriendNameLabel.text = _currentFriend.name;
    self.userFriendIdLabel.text = _currentFriend.uId;
    //NSLog( @" name is %@",_currentFriend.name);
    
    if (self.currentFriend.data != nil) {
        //NSLog(@" image data is already available in Core Data ");
        self.userFriendImgView.image = [UIImage imageWithData:_currentFriend.data];
    } else {
        //NSLog(@" image data is Fetching for %@",_currentFriend.name);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageMethod:) name:self.currentFriend.uId object:nil];
        //self.userFriendImgView.image = [UIImage imageNamed:@"profile_Pic"];
        [self.currentFriend getImageForThisFriend];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
