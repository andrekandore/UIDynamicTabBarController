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

const void *systemItemKey = @"__item=x_Type";

- (UIDynamicTabBarSystemItem)dynamicItemType {
    return [objc_getAssociatedObject(self, systemItemKey) integerValue];
}

- (void)setDynamicItemType:(UIDynamicTabBarSystemItem)dynamicItemType {
    objc_setAssociatedObject(self, systemItemKey, @(dynamicItemType), OBJC_ASSOCIATION_RETAIN);
}

@end
