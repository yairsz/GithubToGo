//
//  YSNetworkController.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSGithubNetworkController : NSObject

+(YSGithubNetworkController *) sharedNetworkController;

- (NSArray *) searchReposForString: (NSString *) searchString;
- (NSArray *) searchUsersForString: (NSString *) searchString;
@end
