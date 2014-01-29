//
//  YSUserSearchResultsVC.m
//  GithubToGo
//
//  Created by Yair Szarf on 1/28/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSUserSearchResultsVC.h"
#import "YSGithubNetworkController.h"
#import "YSCustomCell.h"

@interface YSUserSearchResultsVC ()

@property (strong, nonatomic) NSArray * searchResultsArray;
@property (strong, nonatomic) YSGithubNetworkController * sharedNetworkController;
@property BOOL menuIsOut;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;

@end

@implementation YSUserSearchResultsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.detailViewController = (YSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.sharedNetworkController = [YSGithubNetworkController sharedNetworkController];
    [self searchUsersForString:@"bavarian"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSCustomCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary * user = self.searchResultsArray[indexPath.row];
    cell.userLabel.text= user[@"login"];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    NSDictionary * user = self.searchResultsArray[indexPath.row];
    self.detailViewController.detailItem = user;
    [self performSegueWithIdentifier:@"showUser" sender:self];
    //    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUser"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        NSDictionary * repo = self.searchResultsArray[indexPath.row];
        [[segue destinationViewController] setDetailItem:repo];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchUsersForString:searchBar.text];
    [self.collectionView reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchUsersForString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //This is a gist by @johnnyclem https://gist.github.com/johnnyclem/8215415 well done!
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UISearchBar class]]) {
            [control resignFirstResponder];
        }
    }
}

- (void) searchUsersForString:(NSString *) string {
    self.searchResultsArray = [self.sharedNetworkController searchUsersForString:string];
    NSLog(@"%@", self.searchResultsArray);
}


@end
