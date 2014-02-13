//
//  YSNetworkController.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSGitHubControllerDelegate <NSObject>

- (void) didAuthenticate;
- (void) didCreateRepo: (NSDictionary *) JSONDict;

@end


@interface YSGithubNetworkController : NSObject

@property (strong, nonatomic) NSString * oAuthToken;

+(YSGithubNetworkController *) sharedNetworkController;

- (NSArray *) searchReposForString: (NSString *) searchString;
- (NSArray *) searchUsersForString: (NSString *) searchString;
- (NSArray *) fetchUserRepos;

- (void) createRepo:(NSString *) repoName;

- (void) beginOAuthAccess;
- (void) handleCallbackUrl: (NSURL *) url;



@property (unsafe_unretained) id <YSGitHubControllerDelegate> delegate;
@end
