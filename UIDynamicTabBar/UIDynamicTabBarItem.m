//
//  UIDynamicTabBarItem.m
//  UIDynamicTabBar
//
//  Created by アンドレ on H26/09/28.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.

#import "UIDynamicTabBarItem.h"
#import <objc/runtime.h>

@interface UITabBarItem ()
@property UIDynamicTabBarSystemItem dynamicItemType;
@end

@implementation UITabBarItem (UIDynamicTabBarItem)

+ (NSString *)titleForDynamicTabBarSystemItem:(UIDynamicTabBarSystemItem)dynamicTabBarSystemItem {
    NSString *title = nil;
    
    switch (dynamicTabBarSystemItem) {
        case UIDynamicTabBarSystemItemMore:
            title = NSLocalizedString(@"More",nil);
            break;
            
        case UIDynamicTabBarSystemItemFavorites:
            title = NSLocalizedString(@"Favorites",nil);
            break;
            
        case UIDynamicTabBarSystemItemFeatured:
            title = NSLocalizedString(@"Featured",nil);
            break;
            
        case UIDynamicTabBarSystemItemTopRated:
            title = NSLocalizedString(@"TopRated",nil);
            break;
            
        case UIDynamicTabBarSystemItemRecents:
            title = NSLocalizedString(@"Recents",nil);
            break;
            
        case UIDynamicTabBarSystemItemContacts:
            title = NSLocalizedString(@"Contacts",nil);
            break;
            
        case UIDynamicTabBarSystemItemHistory:
            title = NSLocalizedString(@"History",nil);
            break;
            
        case UIDynamicTabBarSystemItemBookmarks:
            title = NSLocalizedString(@"Bookmarks",nil);
            break;
            
        case UIDynamicTabBarSystemItemSearch:
            title = NSLocalizedString(@"Search",nil);
            break;
            
        case UIDynamicTabBarSystemItemDownloads:
            title = NSLocalizedString(@"Downloads",nil);
            break;
            
        case UIDynamicTabBarSystemItemMostRecent:
            title = NSLocalizedString(@"Most Recent",nil);
            break;
            
        case UIDynamicTabBarSystemItemMostViewed:
            title = NSLocalizedString(@"Most Viewed",nil);
            break;
            
        default:
            break;
    }
    
    return title;
}

const void *systemItemKey = @"__item=x_Type";

- (UIDynamicTabBarSystemItem)dynamicItemType {
    return [objc_getAssociatedObject(self, systemItemKey) integerValue];
}

- (void)setDynamicItemType:(UIDynamicTabBarSystemItem)dynamicItemType {
    objc_setAssociatedObject(self, systemItemKey, @(dynamicItemType), OBJC_ASSOCIATION_RETAIN);
}

@end
