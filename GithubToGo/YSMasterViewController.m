//
//  YSMasterViewController.m
//  GithubToGo
//
//  Created by Yair Szarf on 1/27/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSMasterViewController.h"
#import "YSDetailViewController.h"
#import "YSGithubNetworkController.h"
#import "YSAppDelegate.h"

@interface YSMasterViewController () {
    NSMutableArray *_objects;
}

@property (strong, nonatomic) NSArray * searchResultsArray;
@property (strong, nonatomic) YSGithubNetworkController * sharedNetworkController;
@property BOOL menuIsOut;
@property (strong, nonatomic) UIViewController * topVC;
@property (strong, nonatomic) NSArray * VCs;
@property (nonatomic) CGRect closedMenuCGRect, offScreenCGRect, openMenuCGRect;
@property (weak, nonatomic) YSAppDelegate * appDelegate;


@end

@implementation YSMasterViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.sharedNetworkController = self.appDelegate.networkController;
    
    self.detailViewController = (YSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.closedMenuCGRect = self.view.frame;
    self.openMenuCGRect = CGRectMake(150, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.offScreenCGRect = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.menuIsOut = NO;

    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(slideView)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIViewController * repoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"repoSearchVC"];
    UIViewController * usersVC =[self.storyboard instantiateViewControllerWithIdentifier:@"userSearchVC"];
    UIViewController * homeVC =[self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
    
    
    self.VCs = [NSArray arrayWithObjects:homeVC,repoVC,usersVC, nil];

    [self setTopVC:self.VCs[0]];
    
    
}


- (CGRect) closedMenuCGRect {
    return self.view.frame;
}
- (CGRect) openMenuCGRect {
    return CGRectMake(150, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (CGRect) offScreenCGRect {
    return CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)menuButtonPressed:(UIButton *)sender {
    self.menuIsOut = YES;
    [UIView animateWithDuration:0.4 animations:^{
        self.topVC.view.frame = self.offScreenCGRect;
    } completion:^(BOOL finished) {
        [self setTopVC:self.VCs[sender.tag]];
            [self closeMenu];
    }];
    
}

-(BOOL) shouldAutomaticallyForwardRotationMethods {return  NO;};

- (void)setTopVC:(UIViewController *) topVC
{
    if (_topVC) {
        [_topVC.view removeFromSuperview];
        [_topVC removeFromParentViewController];
    }
    _topVC = topVC;

    [self addChildViewController:_topVC];
//    
    _topVC.view.frame = self.menuIsOut ? self.offScreenCGRect : self.closedMenuCGRect;
    
    [self.view addSubview:_topVC.view];
    
    [_topVC didMoveToParentViewController:self];
    
    [self setupPanGesture];
    self.menuIsOut = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//        [super ]
//    
//}

-(void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.topVC.view addGestureRecognizer:pan];
    
}


- (void) slideView {
    CGRect slideToRect = self.menuIsOut ? self.closedMenuCGRect : self.openMenuCGRect;
    [UIView animateWithDuration:0.4 animations:^{
        self.topVC.view.frame = slideToRect;
    }];
    self.menuIsOut = !self.menuIsOut;
}

-(void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint translation = [pan translationInView:self.view];
    
    //NSLog(@"%f", translation.x);
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.topVC.view.frame.origin.x+ translation.x > 0) {
            
            self.topVC.view.center = CGPointMake(self.topVC.view.center.x +translation.x, self.topVC.view.center.y);

            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.topVC.view.frame.origin.x > self.view.frame.size.width / 3)
        {
            [self openMenu];  
        }
        if (self.topVC.view.frame.origin.x < self.view.frame.size.width / 3)
        {
            [self closeMenu];
        }
    }
    
}

- (void) openMenu
{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:2.0 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.topVC.view.frame = self.openMenuCGRect;
    } completion:nil];
    
}

-(void) closeMenu
{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:2.0 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.topVC.view.frame = self.closedMenuCGRect;
    } completion:nil];
}

@end
