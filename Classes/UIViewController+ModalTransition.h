//
//  UIViewController+ModalTransition.h
//  CCModalTransition
//
//  Created by Cyril Chandelier on 25/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, ModalTransitionType) {
    ModalTransitionTypeNone = 9999,
    ModalTransitionTypePopup,
    ModalTransitionTypeTopSliding
};



@interface UIViewController (ModalTransition)

// Register / Unregister a custom transition
- (void)registerClass:(Class)transitionClass forTransitionType:(NSInteger)transitionType;
- (void)unregisterClassForTransitionType:(NSInteger)transitionType;

@end
