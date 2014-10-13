//
//  UIDynamicMoreViewController.h
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIDynamicTabViewController;

@interface UIDynamicMoreViewController : UITableViewController
@property (readonly) UIDynamicTabViewController *parentTabBarController;
- (void)reloadAnimated:(BOOL)animated;
- (IBAction)editTabBar:(id)sender;
@end
