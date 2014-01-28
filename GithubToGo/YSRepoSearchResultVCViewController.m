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
    
//    self.sharedNetworkController = [YSGithubNetworkController sharedNetworkController];
//    self.searchResultsArray = [self.sharedNetworkController reposForSearchingString:@"SoundCloud"];
//
//    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(slideView)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self setupPanGesture];
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


- (void) slideView {
    float slideNumber = self.menuIsOut ? 0 : -200;
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.bounds = CGRectMake(slideNumber, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    }];
    self.menuIsOut = !self.menuIsOut;
}

-(void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.tableView addGestureRecognizer:pan];
    
}

-(void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint translation = [pan translationInView:self.view];
    
    //NSLog(@"%f", translation.x);
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.tableView.frame.origin.x+ translation.x > 0) {
            
            self.tableView.center = CGPointMake(self.tableView.center.x +translation.x, self.tableView.center.y);
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.tableView.frame.origin.x > self.view.frame.size.width / 2)
        {
            //            [self openMenu];
        }
        if (self.tableView.frame.origin.x < self.view.frame.size.width / 2 )
        {
            [UIView animateWithDuration:.4 animations:^{
                self.tableView.frame = self.view.frame;
            } completion:^(BOOL finished) {
                //                [self closeMenu];
            }];
        }
    }
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
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



@end
