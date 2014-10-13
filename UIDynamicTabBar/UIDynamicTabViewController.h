//
//  UIExtensableTabViewController.h
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *TabBarItemAccessorKey;

@interface UIDynamicTabViewController : UITabBarController
@property (readonly) NSUInteger maxNumberOfVisibleViewControllers;

@property (weak) UIViewController *previouslySelectedViewController;
@property (weak) UITabBarItem *previouslySelectedTabBarItem;

@property (readonly) NSArray *displayableViewControllers;
@property (readonly) NSArray *overflowedViewControllers;

@property (readonly) NSArray *customizableTabBarItems;
@property (readonly) NSArray *displayableTabBarItems;
@property (readonly) NSArray *allTabBarItems;

@property (readonly) NSUInteger widthOfSingleTab;

@property IBOutlet UITabBar *viewedTabBar;
@end
