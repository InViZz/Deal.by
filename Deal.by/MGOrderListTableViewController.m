//
//  MGOrderListTableViewController.m
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "MGOrderListTableViewController.h"
#import "MGDetailOrderViewController.h"
#import "MGOrderListCell.h"
#import "MGOrder.h"

@interface MGOrderListTableViewController ()

@property (strong, nonatomic) NSArray *ordersContent;

@end

@implementation MGOrderListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MGOrderAPI sharedClient] getOrdersWithBlock:^(NSArray *results, NSError *error) {
        if (results) {
            NSLog(@"ORDERS: %@", results);
            self.ordersContent = results;
            [self.tableView reloadData];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.ordersContent count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    MGOrder *currentOrder = [self.ordersContent objectAtIndex:indexPath.row];
    
    cell.orderIDLabel.text = [NSString stringWithFormat:@"№ %@", currentOrder.orderID];
    cell.orderDateLabel.text = [NSDate getDayFromDate:currentOrder.orderDate];
    cell.customerNameLabel.text = currentOrder.customerName;
    cell.orderPriceLabel.text = currentOrder.orderSummaryPrice;
    cell.itemNameLabel.text = currentOrder.itemName;
    if ([currentOrder.orderState isEqualToString:@"new"]) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.orderDateLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
    MGOrder *selectedOrder = [self.ordersContent objectAtIndex:selectedIndexPath.row];
    
    MGDetailOrderViewController *detailViewController = [segue destinationViewController];
    [detailViewController setDetailedContent:selectedOrder];
}


@end
