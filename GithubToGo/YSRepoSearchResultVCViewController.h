//
//  YSRepoSearchResultVCViewController.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/28/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSDetailViewController.h"
#import "YSGithubUser.h"

@interface YSRepoSearchResultVCViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) YSDetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property BOOL clearsSelectionOnViewWillAppear;

@end
