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
    BOOL animated = transitionContext.isAnimated;
    
    // Present or dismiss
    if (toViewController.isBeingPresented)
    {
        // Hold view controllers
        self.presentingViewController = fromViewController;
        self.presentedViewController = toViewController;
        
        // Present view controller
        [self presentViewControllerWithContext:transitionContext animated:animated];
    }
    else
    {
        // Dismiss view contorller
        [self dismissViewControllerWithContext:transitionContext animated:animated];
    }
}

- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated
{
    @throw @"To be implemented in subclasses";
}

- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated
{
    @throw @"To be implemented in subclasses";
}

#pragma mark - Utils
+ (float)rotationAngle
{
    switch ([[UIApplication sharedApplication] statusBarOrientation])
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            return M_PI;
            
        case UIInterfaceOrientationLandscapeLeft:
            return -M_PI_2;
            
        case UIInterfaceOrientationLandscapeRight:
            return M_PI_2;
            
        default:
        case UIInterfaceOrientationPortrait:
            return 0.0f;
    }
}

@end
