//
//  NotificationViewController.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 26/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "NotificationViewController.h"



@interface NotificationViewController ()

// Outlets
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@end



@implementation NotificationViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"NotificationViewController" bundle:nil])
    {
        /**
         * Here, you just need to use a CCModalTransition type
         * to be used when the view controller is displayed
         * modally, cmd+click on ModalTransitionTypeTopSliding to
         * see available transition types
         */
        self.modalTransitionStyle = ModalTransitionTypeTopSliding;
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Customize close button
    _closeButton.layer.cornerRadius = 20.0f;
}

#pragma mark - UI Actions
- (IBAction)closePopup
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end