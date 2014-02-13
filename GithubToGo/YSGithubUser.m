//
//  YSGithubUser.m
//  GithubToGo
//
//  Created by Yair Szarf on 1/29/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSGithubUser.h"




@implementation YSGithubUser

@dynamic login;
@dynamic pathToAvatar;
@synthesize delegate,avatar,isDownloading;



- (void) downloadAvatarOnQueue: (NSOperationQueue *) queue
{
    self.isDownloading = YES;
    if (self.pathToAvatar)
    [queue addOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pathToAvatar]];
        self.avatar = [UIImage imageWithData:imageData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.isDownloading = NO;
            [self.delegate didFinishDownloadingAvatarForUser:self];
        }]; 
    }];
}

@end
