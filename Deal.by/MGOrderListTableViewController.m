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
#import "MGSearchOrderCell.h"
#import "MGOrder.h"

@interface MGOrderListTableViewController () <UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *ordersContent;
@property (strong, nonatomic) NSArray *searchResults;

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
            self.ordersContent = results;
            [self.tableView reloadData];
        } else {
            NSLog(@"ERROR: %@", [error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:[error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [self.ordersContent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [tableView registerNib:[UINib nibWithNibName:@"MGSearchOrderCell" bundle:nil] forCellReuseIdentifier:@"SearchOrderCell"];
        MGSearchOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOrderCell" forIndexPath:indexPath];
        NSDictionary *currentItem = [self.searchResults objectAtIndex:indexPath.row];
        
        [cell.itemImageView setImageWithURL:[NSURL URLWithString:currentItem[@"image"]]];
        cell.itemNameLabel.text = currentItem[@"name"];
        cell.itemPriceLabel.text = [NSString stringWithFormat:@"%@ грн.", currentItem[@"price"]];
        
        return cell;
    } else {
        MGOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
        MGOrder *currentOrder = [self.ordersContent objectAtIndex:indexPath.row];
        
        cell.orderIDLabel.text = [NSString stringWithFormat:@"№ %@", currentOrder.orderID];
        cell.orderDateLabel.text = [NSDate getDayFromDate:currentOrder.orderDate];
        cell.customerNameLabel.text = currentOrder.customerName;
        cell.orderPriceLabel.text = [NSString stringWithFormat:@"%@ грн.", currentOrder.orderSummaryPrice];
        cell.itemNameLabel.text = currentOrder.itemName;
        if ([currentOrder.orderState isEqualToString:@"new"]) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.orderDateLabel.textColor = [UIColor colorWithRed:43.0/255.0 green:187.0/255.0 blue:232.0/255.0 alpha:1.0];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
            cell.orderDateLabel.textColor = [UIColor blackColor];
        }
        
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 57.0;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        height = 100.0;
    }
    
    return height;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"searchKeys CONTAINS[c] %@", searchText];
    NSArray *searchOrderResults = [self.ordersContent filteredArrayUsingPredicate:resultPredicate];
    NSMutableArray *searchItemResults = [NSMutableArray array];
    [searchOrderResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MGOrder *order = obj;
        [searchItemResults addObjectsFromArray:order.items];
    }];
    
    self.searchResults = searchItemResults;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
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
