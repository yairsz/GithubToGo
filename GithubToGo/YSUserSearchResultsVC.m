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
@property (strong,nonatomic) NSMutableArray * usersArray;
@property (strong, nonatomic) NSOperationQueue * downloadQueue;

@end

@implementation YSUserSearchResultsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.detailViewController = (YSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.downloadQueue = [NSOperationQueue new];
    self.sharedNetworkController = [YSGithubNetworkController sharedNetworkController];
    [self searchUsersForString:@"adam"];
    self.collectionView.allowsMultipleSelection = NO;
    
    
}

-( void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (NSIndexPath * ip in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:ip animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    self.view.frame = self.parentViewController.view.frame;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//        self.view.frame = self.parentViewController.view.frame;

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
    
    YSGithubUser * user = self.usersArray[indexPath.row];
    cell.userLabel.text= user.login;
    if (user.avatar) {
        cell.userImage.image = user.avatar;
    } else {
        if (!user.isDownloading) {
            [user downloadAvatarOnQueue:self.downloadQueue];
        }
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    Repo * repo = self.fetch [indexPath.row];
//    self.detailViewController.detailItem = repo;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self performSegueWithIdentifier:@"showUser" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUser"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        NSDictionary * user = self.searchResultsArray[indexPath.row];
//        [[segue destinationViewController] setDetailItem:user];
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
    [self.collectionView reloadData];
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    
//}


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
    self.usersArray = [NSMutableArray new];
    
    for (int i = 0; i < self.searchResultsArray.count; i++) {
        NSDictionary * userDict = self.searchResultsArray[i];
        YSGithubUser * user = [[YSGithubUser alloc] init];
        user.login = userDict[@"login"];
        user.pathToAvatar = userDict[@"avatar_url"];
        user.delegate = self;
        [self.usersArray addObject:user];
    }
    [self.collectionView reloadData];
}

- (void) didFinishDownloadingAvatarForUser: (YSGithubUser *) gitUser{
    
    
    NSInteger index = [self.usersArray indexOfObject:gitUser];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    YSCustomCell * cell =(YSCustomCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    cell.userImage.image = gitUser.avatar;
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}



@end
