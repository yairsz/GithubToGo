//
//  YSMasterViewController.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDetailViewController;

@interface YSMasterViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) YSDetailViewController *detailViewController;


@end
