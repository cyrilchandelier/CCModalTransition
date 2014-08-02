//
//  CCModalTransitionController.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 03/08/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "CCModalTransitionController.h"



@interface CCModalTransitionController ()

// Current transition
@property (nonatomic, strong) CCModalTransition *currentTransition;

@end



@implementation CCModalTransitionController

#pragma mark - Constructor
- (instancetype)initWithModalTransition:(CCModalTransition *)modalTransition
{
    if (self = [super init])
    {
        // Hold modal transition
        self.currentTransition = modalTransition;
    }
    
    return self;
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

@end
