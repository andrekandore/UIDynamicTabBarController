//
//  UIDynamicMoreViewController.m
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import "UIDynamicMoreViewController.h"
#import "UIDynamicTabViewController.h"

@implementation UIDynamicMoreViewController
- (IBAction)editTabBar:(id)sender {
    UIViewController *viewController = self;
    UIViewController *parentViewController = nil;
    while ((parentViewController = viewController.parentViewController)) {
        if ([parentViewController isKindOfClass:UIDynamicTabViewController.class]) {
            UIDynamicTabViewController *tabBarController = (UIDynamicTabViewController *)parentViewController;
            UITabBar *tabBar = tabBarController.viewedTabBar;
            if (nil != tabBar) {
                [tabBar beginCustomizingItems:tabBar.items];
                return;
            }
        } else {
            viewController = parentViewController;
        }
    }
}
@end
