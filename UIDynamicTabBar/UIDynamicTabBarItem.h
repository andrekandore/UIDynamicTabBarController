//
//  UIDynamicTabBarItem.h
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIDynamicTabBarSystemItem) {
    UIDynamicTabBarSystemItemMore = -1
};

@interface UITabBarItem (UIDynamicTabBarItem)
@property (readonly) UIDynamicTabBarSystemItem dynamicItemType;
@end
