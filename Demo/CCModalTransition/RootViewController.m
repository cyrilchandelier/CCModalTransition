//
//  RootViewController.m
//  CCModalTransition
//
//  Created by Cyril Chandelier on 24/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "RootViewController.h"
#import "PopupViewController.h"



@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

// Outlets
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// Data
@property (nonatomic, strong) NSArray *data;

@end



@implementation RootViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"RootViewController" bundle:nil])
    {
        // Load list of available view controllers from plist
        self.data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"plist"]];
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    self.title = @"Available modal transitions";
    
    // Reload data
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cellId";
    
    // Dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // If no cell has been dequeued, create one
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve item
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    
    // Configure cell label
    cell.textLabel.text = [dic objectForKey:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect selected row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Retrieve item
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    
    // Create view controller to be displayed
    UIViewController *viewController = [[NSClassFromString([dic objectForKey:@"viewController"]) alloc] init];
    
    /**
     * The important thing to see is here : in fact, you
     * just have to present your view controller normally
     * has if it was a modal presentation
     */
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

@end