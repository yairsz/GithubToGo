//
//  YSRepoSearchResultVCViewController.m
//  GithubToGo
//
//  Created by Yair Szarf on 1/28/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSRepoSearchResultVCViewController.h"
#import "YSDetailViewController.h"
#import "YSGithubNetworkController.h"

@interface YSRepoSearchResultVCViewController ()

@property (strong, nonatomic) NSArray * searchResultsArray;
@property (strong, nonatomic) YSGithubNetworkController * sharedNetworkController;
@property BOOL menuIsOut;
@property (weak, nonatomic) IBOutlet UISearchBar * searchBar;

@end

@implementation YSRepoSearchResultVCViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.detailViewController = (YSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.sharedNetworkController = [YSGithubNetworkController sharedNetworkController];
    [self searchReposForString:@"bavarian"];

}

- (void) viewWillAppear:(BOOL)animated {
    if (self.clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchReposForString:(NSString *) string {
    self.searchResultsArray = [self.sharedNetworkController searchReposForString:string];
    [self.tableView reloadData];

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary * repo = self.searchResultsArray[indexPath.row];
    cell.textLabel.text = repo[@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    NSDictionary * repo = self.searchResultsArray[indexPath.row];
    self.detailViewController.detailItem = repo;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    //    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary * repo = self.searchResultsArray[indexPath.row];
        [[segue destinationViewController] setDetailItem:repo];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchReposForString:searchBar.text];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchReposForString:searchBar.text];
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

@end
