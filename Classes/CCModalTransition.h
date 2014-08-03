//
//  CCModalTransition.h
//  CCModalTransition
//
//  Created by Cyril Chandelier on 24/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

@interface CCModalTransition : NSObject <UIViewControllerAnimatedTransitioning>

// Compute rotation angle to apply
+ (float)rotationAngle;

// Subclasses must implement these method to control presentation/dismiss
- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated;
- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated;

// View controllers
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, weak) UIViewController *presentedViewController;

@end
