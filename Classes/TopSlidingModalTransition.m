//
//  TopSlidingModalTransition.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 26/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "TopSlidingModalTransition.h"



@interface TopSlidingModalTransition ()

// Dimmed background
@property (nonatomic, strong) UIView *dimmedBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end



@implementation TopSlidingModalTransition

#pragma mark - Constructor
- (instancetype)init
{
    if (self = [super init])
    {
        // Add dimmed background
        self.dimmedBackgroundView = [[UIView alloc] init];
        self.dimmedBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.dimmedBackgroundView.backgroundColor = [UIColor blackColor];
        
        // Tap gesture
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmedBackgroundTapped:)];
        [self.dimmedBackgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

#pragma mark - Transition methods
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated
{
    UIView *container = transitionContext.containerView;
    
    // Update dimmed background frame
    self.dimmedBackgroundView.frame = container.bounds;
    
    // Display centered
    self.presentedViewController.view.center = container.center;
    
    // Take orientation into account
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, [CCModalTransition rotationAngle]);
    self.presentedViewController.view.transform = transform;
    
    // Animate
    if (animated)
    {
        NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
        
        // Prepare animation
        CGRect frame = self.presentedViewController.view.frame;
        frame.origin.y = -frame.size.height;
        self.presentedViewController.view.frame = frame;
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
        
        // The view will come from top
        [UIView animateWithDuration:animationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             // Slide down
                             CGRect frame = self.presentedViewController.view.frame;
                             frame.origin.y = 0;
                             self.presentedViewController.view.frame = frame;
                             
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

- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated
{
    // Dismiss view controller with or withour animation
    if (animated)
    {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             
                             // Slide up
                             CGRect frame = self.presentedViewController.view.frame;
                             frame.origin.y = -frame.size.height;
                             self.presentedViewController.view.frame = frame;
                             
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

#pragma mark - Gestures
- (void)dimmedBackgroundTapped:(UIGestureRecognizer *)gesture
{
    __block CCModalTransition *blockSelf = self;
    [blockSelf.presentedViewController dismissViewControllerAnimated:YES completion:^{
        blockSelf.presentedViewController = nil;
    }];
}

#pragma mark - Utils
- (void)clearContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // Remove dimmed background
    [self.dimmedBackgroundView removeFromSuperview];
    
    // Remove presented view controller
    [self.presentedViewController.view removeFromSuperview];
    
    [transitionContext completeTransition:YES];
}

@end
