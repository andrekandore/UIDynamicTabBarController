//
//  UIDynamicTabBarItem.h
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIDynamicTabBarSystemItem) {
    UIDynamicTabBarSystemItemMore = -1,
    UIDynamicTabBarSystemItemFavorites = 1,
    UIDynamicTabBarSystemItemFeatured = 2,
    UIDynamicTabBarSystemItemTopRated = 3,
    UIDynamicTabBarSystemItemRecents = 4,
    UIDynamicTabBarSystemItemContacts = 5,
    UIDynamicTabBarSystemItemHistory = 6,
    UIDynamicTabBarSystemItemBookmarks = 7,
    UIDynamicTabBarSystemItemSearch = 8,
    UIDynamicTabBarSystemItemDownloads = 9,
    UIDynamicTabBarSystemItemMostRecent = 10,
    UIDynamicTabBarSystemItemMostViewed = 11,
};

@interface UITabBarItem (UIDynamicTabBarItem)
+ (NSString *)titleForDynamicTabBarSystemItem:(UIDynamicTabBarSystemItem)dynamicTabBarSystemItem;
@property (readonly) UIDynamicTabBarSystemItem dynamicItemType;
@end
