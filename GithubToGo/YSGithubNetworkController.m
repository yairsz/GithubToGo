//
//  YSNetworkController.m
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSGithubNetworkController.h"

@implementation YSGithubNetworkController

+(YSGithubNetworkController *) sharedNetworkController{
    static dispatch_once_t pred;
    static YSGithubNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[YSGithubNetworkController alloc] init];
    });
    return shared;
}

- (NSArray *) reposForSearchingString: (NSString *) searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=start&order=desc",searchString];
    
    NSURL * searchURL = [NSURL URLWithString:searchString];
    NSData * URLData = [NSData dataWithContentsOfURL:searchURL];
    NSError * error;
    NSDictionary * searchDictionary = [NSJSONSerialization JSONObjectWithData:URLData options:NSJSONReadingMutableContainers error:&error];
    
    return [searchDictionary objectForKey:@"items"];
    
}

@end
