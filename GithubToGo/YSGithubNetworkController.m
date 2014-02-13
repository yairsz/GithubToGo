//
//  YSNetworkController.m
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSGithubNetworkController.h"

#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
#define GITHUB_CLIENT_ID @"c97eba3e4580e95f5d9c"
#define GITHUB_SECRET @"7ed504b432a591ca26a54e0e6de09282bae5cc34"
#define GITHUB_REDIRECT @"githhubtogo://oauthCallback"
#define GITHUB_POST_URL @"https://github.com/login/oauth/access_token"
#define GITHUB_BASE_URL @"https://api.github.com/"


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
    searchString = [NSString stringWithFormat:@"%@search/repositories?q=%@&sort=start&order=desc",GITHUB_BASE_URL, searchString];
    
    NSURL * searchURL = [NSURL URLWithString:searchString];
    NSData * URLData = [NSData dataWithContentsOfURL:searchURL];
    NSError * error;
    NSDictionary * searchDictionary;
    if (URLData) {
         searchDictionary = [NSJSONSerialization JSONObjectWithData:URLData options:NSJSONReadingMutableContainers error:&error];
    }
    if (searchDictionary) NSLog(@"got repos dictionary");
    
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
    searchString = [NSString stringWithFormat:@"%@search/users?q=%@&sort=start&order=desc", GITHUB_BASE_URL, searchString];
    
    NSURL * searchURL = [NSURL URLWithString:searchString];
    NSData * URLData = [NSData dataWithContentsOfURL:searchURL];
    NSError * error;
    NSDictionary * searchDictionary;
    if (URLData) {
         searchDictionary = [NSJSONSerialization JSONObjectWithData:URLData options:NSJSONReadingMutableContainers error:&error];
        
    }
    if (searchDictionary) NSLog(@"got user dictionary");
    
    return [searchDictionary objectForKey:@"items"];
    //    }
    //    @catch (NSException *exception) {
    //        NSString * message = @"Github data could not be loaded";
    //        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Data not loaded" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    //        [alertView show];
    //
    //    }
}

- (void) beginOAuthAccess
{
    self.oAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:GITHUB_TOKEN_KEY];
    if (!self.oAuthToken) {
        NSString * authURL = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_REDIRECT, @"user,repo"];
        NSLog(@"%@",authURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } else {
        [self.delegate didAuthenticate];
    }

}

- (void) handleCallbackUrl: (NSURL *) url
{
    NSString * code = [self convertUrlToCode:url];
    NSString * post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",GITHUB_CLIENT_ID,GITHUB_SECRET,code,GITHUB_REDIRECT];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:GITHUB_POST_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    NSError * error;
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    self.oAuthToken = [self convertResponseIntoToken:responseData];
    [[NSUserDefaults standardUserDefaults] setObject:self.oAuthToken forKey:GITHUB_TOKEN_KEY];
//    [self fetchUserRepos];
    [self.delegate didAuthenticate];
    
}



- (NSString *) convertResponseIntoToken : (NSData *) response
{
    NSString * tokenResponse = [[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding];
    
    NSArray * components = [tokenResponse componentsSeparatedByString:@"&"];
    NSString * access_token = [components firstObject];
    NSArray * components2 = [access_token componentsSeparatedByString:@"="];
    
    return [components2 lastObject];
    
}

-(void) createRepo:(NSString *)repoName
{
    NSDictionary * post = @{@"name":repoName};
    //NSLog(@"%@",post);
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:post options:kNilOptions error:nil];
    NSString * postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[JSONData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/repos",GITHUB_BASE_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"token %@",self.oAuthToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:JSONData];
    
    NSURLResponse * response;
    NSError * error;
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"error: %@",error);
    [self.delegate didCreateRepo:[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil]];
}

- (NSArray *) fetchUserRepos
{
    NSString * stringURL = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", self.oAuthToken];
    
    NSURL * url = [NSURL URLWithString:stringURL];
    NSData * responseData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSMutableArray * reposArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];

    return reposArray;
    
}

- (NSString *) convertUrlToCode:(NSURL *) url
{
    NSString * query = [url query];
    NSArray * components = [query componentsSeparatedByString:@"="];
    NSString * code = [components lastObject];
    return code;
}

@end
