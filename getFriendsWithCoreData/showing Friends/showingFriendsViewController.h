//
//  showingFriendsViewController.h
//  getFriendsWithCoreData
//
//  Created by Gopal Rao on 6/29/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showingFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * table;
    NSMutableArray * dataSource;
}
@end
