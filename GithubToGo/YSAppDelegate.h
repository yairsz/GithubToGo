//
//  YSAppDelegate.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSGithubNetworkController.h"


@interface YSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (strong, nonatomic) YSGithubNetworkController * networkController;

- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;


@end
