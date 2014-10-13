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

@interface UIViewController (UIDynamicViewController)
- (UIDynamicMoreViewController *)dynamicViewSubViewControllerOfViewController:(UIViewController *)viewController;
- (UIDynamicMoreViewController *)dynamicMoreViewController;
@end

NSString *TabBarItemAccessorKey = @"tabBarItem";

@interface UIDynamicTabViewController ()
@property NSArray *viewControllersInternal;
@end

@implementation UIDynamicTabViewController

@synthesize viewControllersInternal = _viewControllersInternal;

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
    
    [tabBar setItems:self.displayableTabBarItems animated:animated];
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
    if (!UITraitCollection.class) {
        [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
        [self updateDisplayableViewControllers:YES withFrameSize:CGSizeZero];
    }
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
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.44 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [super setViewControllers:viewControllers animated:animated];
//    self.viewControllersInternal = viewControllers;
////    });
}

//- (void)setViewControllers:(NSArray *)viewControllers {
//    [super setViewControllers:viewControllers];
//}

- (NSArray *)viewControllersInternal {
    NSArray *internalViewControllersList = _viewControllersInternal;
    if (nil == internalViewControllersList) {
        internalViewControllersList = self.viewControllers;
    }
    return internalViewControllersList;
}

- (void)setViewControllersInternal:(NSArray *)viewControllersInternal {
    _viewControllersInternal = viewControllersInternal;
    [self.viewedTabBar setItems:self.displayableTabBarItems animated:NO];
    [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
    [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
}

- (NSArray *)viewControllers {
    if (nil != _viewControllersInternal) {
        return _viewControllersInternal;
    }
    return [super viewControllers];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if ([tabBar isEqual:self.viewedTabBar]) {
        
        NSArray *viewControllers = [self displayableViewControllersForBoundsSize:CGSizeZero];
        if (nil != viewControllers) {
            
            if (viewControllers.count > 0) {
                self.previouslySelectedViewController = self.selectedViewController;
                [self setSelectedViewController:viewControllers[[tabBar.items indexOfObject:item]]];
                [self ensureMoreNavigationControllerAndDefaultTabBarIsHidden];
                [self updateDisplayableViewControllers:NO withFrameSize:CGSizeZero];
            }
        }
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

- (void)updateDisplayableViewControllers:(BOOL)animated withFrameSize:(CGSize)size {
    
    NSArray *displayableViewControllers = [self displayableViewControllersForBoundsSize:size];
    if (nil != displayableViewControllers) {
        
        UITabBar *tabBar = self.viewedTabBar;
        if (nil != tabBar) {
        
            UIViewController *moreViewController = nil;
            if ((moreViewController = self.moreViewController)) {
                
                if (![displayableViewControllers containsObject:moreViewController]) {
                    
                    if ([self.selectedViewController isEqual:moreViewController]) {
                        
                        UIDynamicMoreViewController *dynamicMoreViewController = nil;
                        if ((dynamicMoreViewController = moreViewController.dynamicMoreViewController)) {
                            
                            UINavigationController *moreControllerNavigationController = nil;
                            if ((moreControllerNavigationController = dynamicMoreViewController.navigationController)) {
                                
                                UIViewController *topViewController = nil;
                                if ((topViewController = moreControllerNavigationController.topViewController)) {
                                    
                                    UIViewController *alternativeViewController = nil;
                                    if ([topViewController isKindOfClass:UIDynamicMoreViewController.class]) {
                                        
                                        if (!(alternativeViewController = self.previouslySelectedViewController)) {
                                            alternativeViewController = displayableViewControllers[0];
                                        }
                                        
                                    } else if ([displayableViewControllers containsObject:topViewController]) {
                                        alternativeViewController = topViewController;
                                    }
                                    
                                    if (nil != alternativeViewController) {
                                        [self setItems:[self tabBarItemsForViewControllers:displayableViewControllers] onTabBar:tabBar withSelectedItem:alternativeViewController.tabBarItem andSelectViewController:alternativeViewController withDelay:.55 animated:animated];
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            [tabBar setItems:[self tabBarItemsForViewControllers:displayableViewControllers] animated:animated];
        }
    }
}

- (void)setItems:(NSArray *)items onTabBar:(UITabBar *)tabBar withSelectedItem:(UITabBarItem *)item andSelectViewController:(UIViewController *)controller withDelay:(NSTimeInterval)delayInSeconds animated:(BOOL)animated {
    
    if (nil != tabBar) {
        if (nil != items) {
            if (nil != controller) {
                
                [tabBar setItems:items animated:animated];
                [tabBar setSelectedItem:controller.tabBarItem];

                void(^selectItem)(void) = ^(void) {
                    @try {
                        [self setSelectedViewController:controller];
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                    } @finally {}
                };
                
                if (delayInSeconds > 0) {
                    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(delay, dispatch_get_main_queue(), selectItem);
                } else {
                    selectItem();
                }
            }
        }
    }
}

- (NSArray *)allTabBarItems {
    return [self.viewControllersInternal valueForKey:TabBarItemAccessorKey];
}

- (NSArray *)customizableTabBarItems {
    NSArray *viewControllers = self.viewControllersInternal;
    
    UIViewController *moreViewController = self.moreViewController;
    if (nil != moreViewController && [viewControllers containsObject:self.moreViewController]) {
        NSMutableArray *mutableViewControllers = [NSMutableArray arrayWithArray:viewControllers];
        [mutableViewControllers removeObject:moreViewController];
        viewControllers = [NSArray arrayWithArray:mutableViewControllers];
    }
    
    return [viewControllers valueForKey:TabBarItemAccessorKey];
}

- (NSArray *)displayableTabBarItems {
    return [self.displayableViewControllers valueForKey:TabBarItemAccessorKey];
}

- (NSArray *)tabBarItemsForViewControllers:(NSArray *)viewControllers {
    return [viewControllers valueForKey:TabBarItemAccessorKey];
}

- (NSArray *)displayableViewControllers {
    return [self displayableViewControllersForBoundsSize:CGSizeZero];
}

- (NSArray *)displayableViewControllersForBoundsSize:(CGSize)boundsSize {
    NSArray *displayableViewControllers = nil;
    
    NSUInteger maximumNumberOfViewControllersDisplayable = [self maxNumberOfVisibleViewControllersForBoundsSize:boundsSize];
    if (maximumNumberOfViewControllersDisplayable > 0) {
        
        NSArray *viewControllers = self.viewControllersInternal;
        if (viewControllers.count > maximumNumberOfViewControllersDisplayable) {
            displayableViewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, maximumNumberOfViewControllersDisplayable-1)];
            UIViewController *moreViewController = self.moreViewController;
            if (nil != moreViewController && ![displayableViewControllers containsObject:moreViewController]) {
                displayableViewControllers = [displayableViewControllers arrayByAddingObject:moreViewController];
            }
        } else {
            UIViewController *moreViewController = self.moreViewController;
            if (nil != moreViewController && [viewControllers containsObject:moreViewController]) {
                NSMutableArray *allControllersButMoreController = viewControllers.mutableCopy;
                [allControllersButMoreController removeObject:moreViewController];
                displayableViewControllers = [NSArray arrayWithArray:allControllersButMoreController];
            } else {
                displayableViewControllers = viewControllers;
            }
        }
    }
    
    return displayableViewControllers;
}

- (NSArray *)overflowedViewControllers {
    NSArray *overflowedViewControllers = nil;
    
    NSArray *displayableViewControllers = [self displayableViewControllersForBoundsSize:CGSizeZero];
    if (displayableViewControllers.count > 0) {
        
        UIViewController *moreViewController = self.moreViewController;
        if (nil != moreViewController) {
            if ([displayableViewControllers containsObject:moreViewController]) {
                
                NSMutableArray *allViewControllers = self.viewControllersInternal.mutableCopy;
                if (allViewControllers.count > 0) {
                    
                    NSMutableArray *displayableArrayControllersMinusMoreViewController = [NSMutableArray arrayWithArray:displayableViewControllers];
                    [displayableArrayControllersMinusMoreViewController removeObject:moreViewController];
                    
                    [allViewControllers removeObjectsInArray:displayableViewControllers];
                    overflowedViewControllers = [NSArray arrayWithArray:allViewControllers];
                }
            }
        }
    }
    
    return overflowedViewControllers;
}


- (UIViewController *)moreViewController {
    
    UIViewController *moreViewController = nil;
    for (UIViewController *viewController in self.viewControllersInternal) {
        
        UITabBarItem *tabBarItem = viewController.tabBarItem;
        if (nil != tabBarItem) {
            if (UIDynamicTabBarSystemItemMore == tabBarItem.dynamicItemType) {
                moreViewController = viewController;
            }
        }
    }
    
    return moreViewController;
}

#pragma mark - UITabBarDelegate Overrrides
- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items {
}

- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items {
}

- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed {
}

- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed {
    self.viewControllersInternal = [self arrangedViewControllersForTabBarItems:items];
    [self.dynamicMoreViewController reloadAnimated:YES];
}

- (NSArray *)arrangedViewControllersForTabBarItems:(NSArray *)items {
    NSArray *arrangedViewControllersForTabBarItems = nil;
    
    if (nil != items) {
        
        NSMutableArray *newlyArrangedViewControllers = NSMutableArray.new;
        NSArray *currentViewControllers = self.viewControllersInternal;
        
        for (UITabBarItem *tabBarItem in items) {
            for (UIViewController *viewController in currentViewControllers) {
                if ([viewController.tabBarItem isEqual:tabBarItem]) {
                    [newlyArrangedViewControllers addObject:viewController];
                    break;
                }
            }
        }
        
        if (currentViewControllers.count > newlyArrangedViewControllers.count) {
            UIViewController *moreViewController = nil;
            
            NSMutableOrderedSet *currentViewControllersOrderedSet = [NSMutableOrderedSet orderedSetWithArray:currentViewControllers];
            NSMutableOrderedSet *newlyArrangedViewControllersOrderedSet = [NSMutableOrderedSet orderedSetWithArray:newlyArrangedViewControllers];
            [currentViewControllersOrderedSet minusOrderedSet:newlyArrangedViewControllersOrderedSet];
            [newlyArrangedViewControllers addObjectsFromArray:currentViewControllersOrderedSet.array];
            
            if ((moreViewController = self.moreViewController)) {
                if ([newlyArrangedViewControllers containsObject:moreViewController]) {
                    [newlyArrangedViewControllers removeObject:moreViewController];
                    [newlyArrangedViewControllers addObject:moreViewController];
                }
            }
        }
        
        if (newlyArrangedViewControllers.count > 0) {
            arrangedViewControllersForTabBarItems = [NSArray arrayWithArray:newlyArrangedViewControllers];
        }
    }
    
    return arrangedViewControllersForTabBarItems;
}

@end

@implementation UIViewController (UIDynamicViewController)

- (UIDynamicMoreViewController *)dynamicMoreViewController {
    return [self dynamicViewSubViewControllerOfViewController:self];
}

- (UIDynamicMoreViewController *)dynamicViewSubViewControllerOfViewController:(UIViewController *)viewController {
    UIDynamicMoreViewController *dynamicViewSubViewController = nil;
    
    if (nil != viewController) {
        
        for (UIViewController *aChildViewController in viewController.childViewControllers) {
            if (![aChildViewController isKindOfClass:UIDynamicMoreViewController.class]) {
                dynamicViewSubViewController = [aChildViewController dynamicViewSubViewControllerOfViewController:aChildViewController];
            } else {
                dynamicViewSubViewController = (UIDynamicMoreViewController *)aChildViewController;
                break;
            }
        }
    }
    
    return dynamicViewSubViewController;
}

@end
