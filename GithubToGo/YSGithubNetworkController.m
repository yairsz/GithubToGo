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

- (NSArray *) searchReposForString: (NSString *) searchString
{
    
//    @try {
        searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=start&order=desc",searchString];
        
        NSURL * searchURL = [NSURL URLWithString:searchString];
        NSData * URLData = [NSData dataWithContentsOfURL:searchURL];
        NSError * error;
        NSDictionary * searchDictionary = [NSJSONSerialization JSONObjectWithData:URLData options:NSJSONReadingMutableContainers error:&error];
        
        return [searchDictionary objectForKey:@"items"];
//    }
//    @catch (NSException *exception) {
//        NSString * message = @"Github data could not be loaded";
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Data not loaded" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alertView show];
//
//    }
}

- (NSArray *) searchUsersForString: (NSString *) searchString
{
    
    //    @try {
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&sort=start&order=desc",searchString];
    
    NSURL * searchURL = [NSURL URLWithString:searchString];
    NSData * URLData = [NSData dataWithContentsOfURL:searchURL];
    NSError * error;
    NSDictionary * searchDictionary;
    if (URLData) {
         searchDictionary = [NSJSONSerialization JSONObjectWithData:URLData options:NSJSONReadingMutableContainers error:&error];
        
    }
    NSLog(@"%@",searchDictionary);
    
    return [searchDictionary objectForKey:@"items"];
    //    }
    //    @catch (NSException *exception) {
    //        NSString * message = @"Github data could not be loaded";
    //        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Data not loaded" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    //        [alertView show];
    //
    //    }
}

@end
