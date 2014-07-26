//
//  PopupModalTransition.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 24/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "PopupModalTransition.h"



@interface PopupModalTransition ()

// Dimmed background
@property (nonatomic, strong) UIView *dimmedBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end



@implementation PopupModalTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}

- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    BOOL animated = transitionContext.isAnimated;
    UIView *container = transitionContext.containerView;
    
    // Add dimmed background
    self.dimmedBackgroundView = [[UIView alloc] initWithFrame:container.bounds];
    self.dimmedBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.dimmedBackgroundView.backgroundColor = [UIColor blackColor];
    
    // Tap gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmedBackgroundTapped:)];
    [self.dimmedBackgroundView addGestureRecognizer:tapGestureRecognizer];
    
    // Display centered
    self.presentedViewController.view.center = container.center;
    
    // Take orientation into account
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch ([[UIApplication sharedApplication] statusBarOrientation])
    {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            // Nothing to do in portrait mode
            break;
    }
    self.presentedViewController.view.transform = transform;
    
    // Animate
    if (animated)
    {
        NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
        
        // Prepare animation
        self.presentedViewController.view.transform = CGAffineTransformScale(transform, 0.0f, 0.0f);
        self.dimmedBackgroundView.alpha = 0.0f;
        
        // Add subviews to container
        [container addSubview:self.dimmedBackgroundView];
        [container addSubview:self.presentedViewController.view];
        
        // Dimmed background fading
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             
                             // Fade in
                             self.dimmedBackgroundView.alpha = 0.4f;
                             
                         }];
        
        // 1) The view will grow a bit bigger than its final size
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             
                             // Scale to normal size
                             self.presentedViewController.view.transform = CGAffineTransformScale(transform, 1.0f, 1.0f);
                             
                         }
                         completion:^(BOOL finished) {
                             
                             // Complete transition
                             [transitionContext completeTransition:YES];
                             
                         }];
    }
    else
    {
        // Prepare dimmed background
        self.dimmedBackgroundView.alpha = 0.4f;
        
        // Add subviews to container
        [container addSubview:self.dimmedBackgroundView];
        [container addSubview:self.presentedViewController.view];
        
        // Complete transition
        [transitionContext completeTransition:YES];
    }
}

- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    BOOL animated = transitionContext.isAnimated;
    
    // Dismiss view controller with or withour animation
    if (animated)
    {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             
                             // Scale to nothing
                             self.presentedViewController.view.transform = CGAffineTransformScale(self.presentedViewController.view.transform, 0.0f, 0.0f);
                             
                             // Fade out
                             self.dimmedBackgroundView.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self clearContext:transitionContext];
                             
                         }];
    }
    else
    {
        [self clearContext:transitionContext];
    }
}

- (void)clearContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // Remove dimmed background
    [self.dimmedBackgroundView removeFromSuperview];
    
    // Remove presented view controller
    [self.presentedViewController.view removeFromSuperview];
    
    [transitionContext completeTransition:YES];
}

#pragma mark - Gestures
- (void)dimmedBackgroundTapped:(UIGestureRecognizer *)gesture
{
    __block CCModalTransition *blockSelf = self;
    [blockSelf.presentedViewController dismissViewControllerAnimated:YES completion:^{
        blockSelf.presentedViewController = nil;
    }];
}

- (float)rotationAngleForOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            return M_PI;
            
        case UIInterfaceOrientationLandscapeLeft:
            return -M_PI_2;
            
        case UIInterfaceOrientationLandscapeRight:
            return M_PI_2;
            
        default:
        case UIInterfaceOrientationPortrait:
            return 0.0;
    }
}

@end
