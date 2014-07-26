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
    ModalTransitionTypePopup
};



@interface UIViewController (ModalTransition) <UIViewControllerTransitioningDelegate>

@end
