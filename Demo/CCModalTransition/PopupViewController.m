//
//  PopupViewController.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 24/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "PopupViewController.h"



@interface PopupViewController ()

// Outlets
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@end



@implementation PopupViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"PopupViewController" bundle:nil])
    {
        /**
         * Here, you just need to use a CCModalTransition type
         * to be used when the view controller is displayed 
         * modally, cmd+click on ModalTransitionTypePopup to
         * see available transition types
         */
        self.modalTransitionStyle = ModalTransitionTypePopup;
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Customize self
    self.view.layer.cornerRadius = 4.0f;
    
    // Customize close button
    _closeButton.layer.cornerRadius = 20.0f;
}

#pragma mark - UI Actions
- (IBAction)closePopup
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end