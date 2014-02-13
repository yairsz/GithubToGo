//
//  YSDetailViewController.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repo.h"

@interface YSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Repo * detailItem;

@end
