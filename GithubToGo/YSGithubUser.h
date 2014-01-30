//
//  YSGithubUser.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/29/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSGithubUser;
@protocol YSGitUserDelegate <NSObject>

- (void) didFinishDownloadingAvatarForUser: (YSGithubUser *) gitUser;

@end

@interface YSGithubUser : NSObject

@property (strong,nonatomic) NSString * login;
@property (strong,nonatomic) NSString * pathToAvatar;
@property (strong, nonatomic) UIImage * avatar;
@property (nonatomic) BOOL isDownloading;
@property (unsafe_unretained) id <YSGitUserDelegate> delegate;

- (void) downloadAvatarOnQueue: (NSOperationQueue *) queue;
@end


