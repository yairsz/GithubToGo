//
//  YSHomeVC.h
//  GithubToGo
//
//  Created by Yair Szarf on 2/12/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSAppDelegate.h"
#import "YSGithubNetworkController.h"
#import "YSDetailViewController.h"

@interface YSHomeVC : UIViewController <YSGitHubControllerDelegate, UIAlertViewDelegate ,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSFetchedResultsController * fetchedRestultsController;

@property (strong, nonatomic) YSDetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property BOOL clearsSelectionOnViewWillAppear;

@end
