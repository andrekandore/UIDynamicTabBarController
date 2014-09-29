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
#import <objc/NSObjCRuntime.h>
#import "tgmath.h"

@interface UIDynamicTabViewController ()
@end

@implementation UIDynamicTabViewController

-(NSUInteger)widthOfSingleTab {
    NSUInteger widthOfSingleTab = 48;
    return widthOfSingleTab;
}

-(NSUInteger)maxNumberOfVisibleViewControllersForBoundsSize:(CGSize)boundsSize {
    NSUInteger widthOfSingleTab = self.widthOfSingleTab;
    
    if (CGSizeEqualToSize(CGSizeZero, boundsSize)) {
        boundsSize = self.view.bounds.size;
    }
    
    NSUInteger maxNumberOfViewControllers = ABS((NSUInteger)floor(boundsSize.width/widthOfSingleTab));
    return maxNumberOfViewControllers;
}

-(NSUInteger)maxNumberOfVisibleViewControllers {
    return [self maxNumberOfVisibleViewControllersForBoundsSize:CGSizeZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITabBar *tabBar = self.viewedTabBar;
    if (nil != tabBar && ![self.view.subviews containsObject:self.viewedTabBar]) {
        [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
        [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
        [self updateLayoutOfTabBar:tabBar];
        [self.view addSubview:tabBar];
    }
    
    [tabBar setItems:[self.viewControllers valueForKey:@"tabBarItem"] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateLayoutOfTabBar:self.viewedTabBar];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
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
    [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([tabBar isEqual:self.viewedTabBar]) {
        [self setSelectedViewController:self.viewControllers[[tabBar.items indexOfObject:item]]];
        [self.viewedTabBar setItems:[self.viewControllers valueForKey:@"tabBarItem"] animated:NO];
        [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
        [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:YES withFrameSize:size];
}


- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:YES withFrameSize:CGSizeZero];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
    if (!UITraitCollection.class) {
        [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
        [self updateDisplayableViewControllers:YES withFrameSize:CGSizeZero];
    }
}

- (void)updateDisplayableViewControllers:(BOOL)animated withFrameSize:(CGSize)size {

    NSArray *displayableViewControllers = [self displayableViewControllersForBoundsSize:size];
    if (nil != displayableViewControllers) {

        UITabBar *tabBar = self.viewedTabBar;
        if (nil != tabBar) {
            NSArray *topTabBarItems = [displayableViewControllers valueForKey:@"tabBarItem"];
            [tabBar setItems:topTabBarItems animated:animated];
        }
    }
}

- (NSArray *)displayableViewControllers {
    return [self displayableViewControllersForBoundsSize:CGSizeZero];
}

- (NSArray *)displayableViewControllersForBoundsSize:(CGSize)boundsSize {
    NSArray *displayableViewControllers = nil;
    
    NSUInteger maximumNumberOfViewControllersDisplayable = [self maxNumberOfVisibleViewControllersForBoundsSize:boundsSize];
    if (maximumNumberOfViewControllersDisplayable > 0) {
        
        NSArray *viewControllers = self.viewControllers;
        if (viewControllers.count > maximumNumberOfViewControllersDisplayable) {
            displayableViewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, maximumNumberOfViewControllersDisplayable-1)];
            UIViewController *moreViewController = self.moreViewController;
            if (nil != moreViewController) {
                displayableViewControllers = [displayableViewControllers arrayByAddingObject:moreViewController];
            }
        } else {
            displayableViewControllers = viewControllers;
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
