//
//  YSHomeVC.m
//  GithubToGo
//
//  Created by Yair Szarf on 2/12/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSHomeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "Repo.h"
#import "YSGithubUser.h"


@interface YSHomeVC ()

@property (strong, nonatomic) YSGithubNetworkController * sharedNetworkController;
@property (weak, nonatomic) YSAppDelegate * appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *loginBUtton;
@property (strong,nonatomic) NSArray * userRepos;
@property BOOL menuIsOut;


@end

@implementation YSHomeVC


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
    
	// Do any additional setup after loading the view.
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.sharedNetworkController = self.appDelegate.networkController;
    self.sharedNetworkController.delegate = self;
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    
    self.detailViewController = (YSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

- (void) viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
//    [self clearSearchResults];
    if (self.clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
    
    if (self.sharedNetworkController.oAuthToken) {
        [self.loginBUtton setTitle:@"logged in" forState:UIControlStateNormal] ;
    } else {
        [self.loginBUtton setTitle:@"log in" forState:UIControlStateNormal];
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


- (IBAction)loginButtonPressed:(UIButton *)sender {
    if (self.sharedNetworkController.oAuthToken) {
        [self showAlertWithMessage:@"Do you want to log off of github"];
    } else {
        [self authenticate];
        [self.loginBUtton setTitle:@"logging in" forState:UIControlStateNormal];
    }
}

- (void)authenticate
{
	// Do any additional setup after loading the view, typically from a nib.
    

    [self.sharedNetworkController performSelector:@selector(beginOAuthAccess) withObject:nil afterDelay:0.1];
}

- (void) didAuthenticate
{
    [self.loginBUtton setTitle:@"logged in" forState:UIControlStateNormal];
    AudioServicesPlaySystemSound (1022);
    
    [self parseReposArrayToMObjects:[self.sharedNetworkController fetchUserRepos]];
}

- (void) didCreateRepo:(NSDictionary *)JSONDict
{
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    Repo * repo = [[Repo alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext withJSONDict:JSONDict];
    [self.fetchedRestultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void) showAlertWithMessage: (NSString *) message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Logout",nil];
    alert.tag = 0;
    [alert show];
}

//- (void) sh

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0){
        if (buttonIndex == 1) {
            self.sharedNetworkController.oAuthToken = nil;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:GITHUB_TOKEN_KEY];
            [self.loginBUtton setTitle:@"log in" forState:UIControlStateNormal];
        }
    } else if (alertView.tag == 1 ) {
        if (buttonIndex == 1 ) {
            UITextField *repoName = [alertView textFieldAtIndex:0];
            //call make repo!!!
            [self.sharedNetworkController createRepo:repoName.text];
        }
    }
}


-  (void)parseReposArrayToMObjects:(NSArray *) repos {
    for (NSDictionary * repoDict in repos) {
        NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
        Repo * repo = [[Repo alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext withJSONDict:repoDict];
        
        [repo.managedObjectContext save:nil];
    }
    [self.tableView reloadData];
}

- (NSFetchedResultsController *) fetchedRestultsController
{
    if (_fetchedRestultsController != nil) {
        return _fetchedRestultsController;
    }
    NSFetchRequest * fetchRequest = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    fetchRequest.fetchBatchSize = 25;
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    self.fetchedRestultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Repo"];
    [self.fetchedRestultsController performFetch:nil];
    return _fetchedRestultsController;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedRestultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Repo * repo = [self.fetchedRestultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.html_url;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Repo * repo = [self.fetchedRestultsController objectAtIndexPath:indexPath];
    self.detailViewController.detailItem = repo;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Repo * repo = [self.fetchedRestultsController objectAtIndexPath:indexPath];
        NSLog(@"%@",repo.name);
        [[segue destinationViewController] setDetailItem:repo];
    }
}

- (IBAction)addRepoButtonPressed:(UIButton *)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Repo"
                                                     message:@"Enter the name of your new repo:"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Create",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
}


- (void) clearSearchResults
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedRestultsController sections][0];
    NSInteger  forCount = [sectionInfo numberOfObjects];
    for (NSInteger i = 0; i < forCount; i ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        Repo * repo = [self.fetchedRestultsController objectAtIndexPath:indexPath];
        NSLog(@"%@",repo);
        [self.managedObjectContext deleteObject:repo];
        
    }
}


    


@end
