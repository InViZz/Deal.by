//
//  MGSplashViewController.m
//  Deal.by
//
//  Created by Morion Black on 4/28/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "MGSplashViewController.h"
#import "MGOrderListTableViewController.h"

@interface MGSplashViewController ()

@property (strong, nonatomic) NSArray *ordersContent;

@end

@implementation MGSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.activityIndicator startAnimating];
    
    [[MGOrderAPI sharedClient] getOrdersWithBlock:^(NSArray *results, NSError *error) {
        if (results) {
            self.ordersContent = results;
            [self performSegueWithIdentifier:@"OrderList" sender:self];
        } else {
            NSLog(@"ERROR: %@", [error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:@"Произошла ошибка при получении данных. Попробуйте повторить попозже"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        [self.activityIndicator stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = [segue destinationViewController];
    MGOrderListTableViewController *orderListViewController = (MGOrderListTableViewController *)[[navigationController childViewControllers] objectAtIndex:0];
    [orderListViewController setOrdersContent:self.ordersContent];
}


@end
