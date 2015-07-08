//
//  FriendsTable.m
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 7/1/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "FriendsTable.h"


@implementation FriendsTable

@dynamic data;
@dynamic name;
@dynamic uId;
@dynamic url;


- (void)getImageForThisFriend {
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    
    dispatch_async(imageQueue, ^{
        //NSLog(@" imageQueue ");
        
        //NSURL *url = [NSURL URLWithString:self.url];
        //NSData *imageData = [NSData dataWithContentsOfURL:url] ;
        //UIImage *image = [UIImage imageWithData:imageData];
        //objFriend.data = imageData;
        //
            // Update the UI
            //NSLog(@" mainQueue ");
        self.data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:self.uId object:nil];
        });
        
    });
}

@end
