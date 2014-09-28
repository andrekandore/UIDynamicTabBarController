//
//  UIExtensableTabViewController.m
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import "UIDynamicTabViewController.h"
#import "UIDynamicMoreViewController.h"
#import "UIDynamicTabBarItem.h"

@interface UIDynamicTabViewController ()
@end

@implementation UIDynamicTabViewController

-(NSUInteger)maxNumberOfVisibleViewControllers {
    NSUInteger maxNumberOfViewControllers = 8;
    return maxNumberOfViewControllers;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITabBar *tabBar = self.viewedTabBar;
    if (nil != tabBar && ![self.view.subviews containsObject:self.viewedTabBar]) {
        [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
        [self updateDisplayableViewControllers:NO];
        [self updateLayoutOfTabBar:tabBar];
        [self.view addSubview:tabBar];
    }
    
    [tabBar setItems:[self.viewControllers valueForKey:@"tabBarItem"] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:NO];
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateLayoutOfTabBar:self.viewedTabBar];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:NO];
}

- (void)updateLayoutOfTabBar:(UITabBar *)viewedTabBar {
    UITabBar *hiddenTabBar = self.tabBar;
    if (nil != viewedTabBar && nil != hiddenTabBar) {
        viewedTabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        viewedTabBar.bounds = hiddenTabBar.bounds;
        viewedTabBar.center = hiddenTabBar.center;
    }
}

- (void)ensureMoreNavigationControllerAndDefaultTabBarIsHidden {
    UINavigationController *moreViewController = self.moreNavigationController;
    if (nil != moreViewController) {
        [moreViewController setNavigationBarHidden:YES animated:NO];
        moreViewController.view.userInteractionEnabled = YES;
        moreViewController.view.alpha = 1.0;
        moreViewController.view.opaque = NO;
        [moreViewController.view.superview sendSubviewToBack:moreViewController.view];
    }
    self.tabBar.hidden = YES;
}


- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    [self.viewedTabBar setItems:[viewControllers valueForKey:@"tabBarItem"] animated:animated];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:NO];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([tabBar isEqual:self.viewedTabBar]) {
        [self setSelectedViewController:self.viewControllers[[tabBar.items indexOfObject:item]]];
        [self.viewedTabBar setItems:[self.viewControllers valueForKey:@"tabBarItem"] animated:NO];
        [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
        [self updateDisplayableViewControllers:NO];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateDisplayableViewControllers:YES];
}


//- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
//    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
//    [self updateDisplayableViewControllers];
//}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
    if (!UITraitCollection.class) {
        [self updateDisplayableViewControllers:YES];
    }
}

- (void)updateDisplayableViewControllers:(BOOL)animated {

    NSArray *displayableViewControllers = self.displayableViewControllers;
    if (nil != displayableViewControllers) {

        UITabBar *tabBar = self.viewedTabBar;
        if (nil != tabBar) {
            NSArray *topTabBarItems = [displayableViewControllers valueForKey:@"tabBarItem"];
            [tabBar setItems:topTabBarItems animated:animated];
        }
    }
}

- (NSArray *)displayableViewControllers {
    NSArray *displayableViewControllers = nil;
    
    NSUInteger maximumNumberOfViewControllersDisplayable = self.maxNumberOfVisibleViewControllers;
    if (maximumNumberOfViewControllersDisplayable > 0) {
        
        NSArray *viewControllers = self.viewControllers;
        if (viewControllers.count > maximumNumberOfViewControllersDisplayable) {
            displayableViewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, maximumNumberOfViewControllersDisplayable-1)];
            UIViewController *moreViewController = self.moreViewController;
            if (nil != moreViewController) {
                displayableViewControllers = [displayableViewControllers arrayByAddingObject:moreViewController];
            }
        }
    }
    
    return displayableViewControllers;
}

- (UIViewController *)moreViewController {

    UIViewController *moreViewController = nil;
    for (UIViewController *viewController in self.viewControllers) {

        UITabBarItem *tabBarItem = viewController.tabBarItem;
        if (nil != tabBarItem) {
            if (UIDynamicTabBarSystemItemMore == tabBarItem.dynamicItemType) {
                moreViewController = viewController;
            }
        }
    }
    
    return moreViewController;
}

@end
