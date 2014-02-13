//
//  Repo.m
//  GithubToGo
//
//  Created by Yair Szarf on 2/11/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "Repo.h"


@implementation Repo

@dynamic html_url;
@dynamic name;

- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJSONDict:(NSDictionary*)jsonDict
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        [self parseJSONDictionary:jsonDict];
    }
    return self;
}

- (void) parseJSONDictionary: (NSDictionary *) json
{
    self.name = [json objectForKey:@"name"];
    self.html_url  = [json objectForKey:@"html_url"];
    
    [self.managedObjectContext save:nil];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"%@\n%@",self.name,self.html_url];
}

@end
