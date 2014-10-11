//
//  UIDynamicMoreViewController.m
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import "UIDynamicMoreViewController.h"
#import "UIDynamicTabViewController.h"
#import "UIDynamicTabBarItem.h"

@implementation UIDynamicMoreViewController

#pragma mark - Editing
- (IBAction)editTabBar:(id)sender {
    UITabBar *tabBar = nil;
    
    UIDynamicTabViewController *parentTabBarController = self.parentTabBarController;
    if (nil != parentTabBarController) {
        if ((tabBar = parentTabBarController.viewedTabBar)) {
            [tabBar beginCustomizingItems:parentTabBarController.allTabBarItems];
        }
    }
}

- (UIDynamicTabViewController *)parentTabBarController {
    UIViewController *parentViewController = nil;
    UIViewController *viewController = self;
    
    while ((parentViewController = viewController.parentViewController)) {
        
        if ([parentViewController isKindOfClass:UIDynamicTabViewController.class]) {
            return (UIDynamicTabViewController *)parentViewController;
        } else {
            viewController = parentViewController;
        }
    }
    
    return nil;
}

#pragma mark - Tableview Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *moreViewControllerTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MoreViewControllerTableViewCell" forIndexPath:indexPath];
    if (nil != moreViewControllerTableViewCell) {
        
        UIDynamicTabViewController *parentTabViewController = self.parentTabBarController;
        if (nil != parentTabViewController) {
            
            NSArray *viewableViewControllers = parentTabViewController.overflowedViewControllers;
            UIViewController *overflowedViewController = (UIViewController *)viewableViewControllers[indexPath.row];
            
            moreViewControllerTableViewCell.textLabel.text = overflowedViewController.tabBarItem.title;
            if (nil == moreViewControllerTableViewCell.textLabel.text) {
                if (0 != overflowedViewController.tabBarItem.dynamicItemType) {
                    moreViewControllerTableViewCell.textLabel.text = [UITabBarItem titleForDynamicTabBarSystemItem:overflowedViewController.tabBarItem.dynamicItemType];
                }
            }
            
            moreViewControllerTableViewCell.imageView.image = overflowedViewController.tabBarItem.image;
        }
    }
    
    return moreViewControllerTableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfMoreViewControllers = 0;
    
    UIDynamicTabViewController *parentTabViewController = self.parentTabBarController;
    if (nil != parentTabViewController) {
        NSArray *viewableViewControllers = parentTabViewController.overflowedViewControllers;
        numberOfMoreViewControllers = viewableViewControllers.count;
    }
    
    return numberOfMoreViewControllers;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIDynamicTabViewController *parentTabViewController = self.parentTabBarController;
    if (nil != parentTabViewController) {
        
        NSArray *viewableViewControllers = parentTabViewController.overflowedViewControllers;
        if (viewableViewControllers.count > indexPath.row) {
            
            UIViewController *viewControllerAtIndex = viewableViewControllers[indexPath.row];
            [self.navigationController pushViewController:viewControllerAtIndex animated:YES];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.34 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

@end
