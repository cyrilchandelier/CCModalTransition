//
//  UIViewController+ModalTransition.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 25/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "UIViewController+ModalTransition.h"
#import "CCModalTransition.h"
#import <objc/runtime.h>



@implementation UIViewController (ModalTransition)

#pragma mark - Object lifecyle
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // Swizzle implementation of presentViewController with a custom that detects custom transition types
        Method presentViewControllerMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
        Method customPresentViewControllerMethod = class_getInstanceMethod(self, @selector(customPresentViewController:animated:completion:));
        method_exchangeImplementations(presentViewControllerMethod, customPresentViewControllerMethod);
        
    });
}

#pragma mark - Transition types
- (void)registerClass:(Class)transitionClass forTransitionType:(NSInteger)transitionType
{
    [self.registeredTransitionTypes setObject:[transitionClass description] forKey:@(transitionType)];
}

- (void)unregisterClassForTransitionType:(NSInteger)transitionType
{
    [self.registeredTransitionTypes removeObjectForKey:@(transitionType)];
}

#pragma mark - UIViewControllerTransitioningDelegate methods
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.currentTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.currentTransition;
}

- (void)customPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
    // Retrieve transition from view controller modalTransitionStyle property
    NSString *transitionClassName = [self.registeredTransitionTypes objectForKey:@(viewControllerToPresent.modalTransitionStyle)];
    if (!transitionClassName)
    {
        // Undefined transition? Present modal view normally
        [self customPresentViewController:viewControllerToPresent animated:animated completion:completion];
        return;
    }
    
    // Set self as transitioning delegate
    viewControllerToPresent.transitioningDelegate = self;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    // Build transition
    self.currentTransition = [[NSClassFromString(transitionClassName) alloc] init];
    
    // Call super
    [self customPresentViewController:viewControllerToPresent animated:animated completion:completion];
}

#pragma mark - Private getters and setters

static void * currentTransitionKey = &currentTransitionKey;
static void * registeredTransitionTypesKey = &registeredTransitionTypesKey;

- (CCModalTransition *)currentTransition
{
    return objc_getAssociatedObject(self, &currentTransitionKey);
}

- (void)setCurrentTransition:(CCModalTransition *)transition
{
    objc_setAssociatedObject(self, &currentTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)registeredTransitionTypes
{
    NSMutableDictionary *registeredTransitionTypes = objc_getAssociatedObject(self, &registeredTransitionTypesKey);
    if (!registeredTransitionTypes)
    {
        // Initialize transition types
        registeredTransitionTypes = [NSMutableDictionary dictionary];
        
        // Built-in transitions
        [registeredTransitionTypes setObject:@"PopupModalTransition" forKey:@(ModalTransitionTypePopup)];
        [registeredTransitionTypes setObject:@"TopSlidingModalTransition" forKey:@(ModalTransitionTypeTopSliding)];
    }
    
    return registeredTransitionTypes;
}

- (void)setRegisteredTransitionTypes:(NSMutableDictionary *)dic
{
    objc_setAssociatedObject(self, &registeredTransitionTypesKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
