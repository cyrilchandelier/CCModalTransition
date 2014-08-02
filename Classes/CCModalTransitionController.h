//
//  CCModalTransitionController.h
//  CCModalTransition
//
//  Created by Cyril Chandelier on 03/08/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "CCModalTransition.h"



@interface CCModalTransitionController : NSObject <UIViewControllerTransitioningDelegate>

// Constructor
- (instancetype)initWithModalTransition:(CCModalTransition *)modalTransition;

// Real-only properties
@property (nonatomic, strong, readonly) CCModalTransition *currentTransition;

@end
