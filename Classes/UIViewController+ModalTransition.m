//
//  UIViewController+ModalTransition.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 25/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "UIViewController+ModalTransition.h"
#import "CCModalTransition.h"
#import "CCModalTransitionController.h"
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

#pragma mark - Modal transition hook
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
    
    // Build transition
    CCModalTransition *transition = [[NSClassFromString(transitionClassName) alloc] init];
    self.transitionController = [[CCModalTransitionController alloc] initWithModalTransition:transition];
    
    // Set self as transitioning delegate
    viewControllerToPresent.transitioningDelegate = self.transitionController;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    // Call super
    [self customPresentViewController:viewControllerToPresent animated:animated completion:completion];
}

#pragma mark - Private getters and setters

static void * transitionControllerKey = &transitionControllerKey;
static void * registeredTransitionTypesKey = &registeredTransitionTypesKey;

- (CCModalTransitionController *)transitionController
{
    return objc_getAssociatedObject(self, &transitionControllerKey);
}

- (void)setTransitionController:(CCModalTransitionController *)transitionController
{
    objc_setAssociatedObject(self, &transitionControllerKey, transitionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
