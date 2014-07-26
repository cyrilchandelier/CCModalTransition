//
//  CCModalTransition.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 24/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "CCModalTransition.h"



@interface CCModalTransition ()

@end



@implementation CCModalTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    @throw @"To be implemented in subclasses";
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Present or dismiss
    if (toViewController.isBeingPresented)
    {
        // Hold view controllers
        self.presentingViewController = fromViewController;
        self.presentedViewController = toViewController;
        
        // Present view controller
        [self presentViewControllerWithContext:transitionContext];
    }
    else
    {
        // Dismiss view contorller
        [self dismissViewControllerWithContext:transitionContext];
    }
}

- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    @throw @"To be implemented in subclasses";
}

- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    @throw @"To be implemented in subclasses";
}

@end
