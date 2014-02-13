//
//  Repo.h
//  GithubToGo
//
//  Created by Yair Szarf on 2/11/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Repo : NSManagedObject

@property (nonatomic, retain) NSString * html_url;
@property (nonatomic, retain) NSString * name;

- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJSONDict:(NSDictionary*)jsonDict;

@end
