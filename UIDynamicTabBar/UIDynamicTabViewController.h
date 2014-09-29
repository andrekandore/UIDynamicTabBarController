//
//  UIExtensableTabViewController.h
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDynamicTabViewController : UITabBarController
@property (readonly) NSUInteger maxNumberOfVisibleViewControllers;
@property (readonly) NSArray *displayableViewControllers;
@property (readonly) NSArray *overflowedViewControllers;
@property (readonly) NSUInteger widthOfSingleTab;
@property IBOutlet UITabBar *viewedTabBar;
@end
