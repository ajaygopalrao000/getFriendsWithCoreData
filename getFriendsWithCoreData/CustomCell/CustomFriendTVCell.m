//
//  CustomFriendTVCell.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/6/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "CustomFriendTVCell.h"

@implementation CustomFriendTVCell

-(void)UpdateImageMethod {
    NSLog(@" Friend object is Downloaded and Updated");
    self.userFriendImgView.image = [UIImage imageWithData:_currentFriend.data];
}

-(void)updateCurrentFriend:(FriendsTable *)currentFriend {
    self.currentFriend = currentFriend;
    self.userFriendNameLabel.text = _currentFriend.name;
    NSLog( @" name is %@",_currentFriend.name);
    
    if (self.currentFriend.data != nil) {
        NSLog(@" Friend object is SET ");
        self.userFriendImgView.image = [UIImage imageWithData:_currentFriend.data];
    } else {
        NSLog(@" Friend object is Fetching");
        self.userFriendImgView.image = [UIImage imageNamed:@"profile_Pic"];
        [self.currentFriend getImageForThisFriend];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateImageMethod) name:self.currentFriend.uId object:self];
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
