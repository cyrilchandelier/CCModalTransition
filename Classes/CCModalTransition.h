//
//  CCModalTransition.h
//  CCModalTransition
//
//  Created by Cyril Chandelier on 24/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

@interface CCModalTransition : NSObject <UIViewControllerAnimatedTransitioning>

// View controllers
@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, strong) UIViewController *presentedViewController;

@end
