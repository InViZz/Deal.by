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
#import "MGItem.h"

#define newOrderDateColor [UIColor colorWithRed:43.0/255.0 green:187.0/255.0 blue:232.0/255.0 alpha:1.0]
#define otherOrderCellBackgroundColor [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]

@interface MGOrderListTableViewController () <UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *searchItemResults;
// @property (strong, nonatomic) NSMutableDictionary *searchOrderResults;

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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [[MGOrderAPI sharedClient] getOrdersWithBlock:^(NSArray *results, NSError *error) {
        if (results) {
            self.ordersContent = results;
            [self.tableView reloadData];
        } else {
            NSLog(@"ERROR: %@", [error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:@"Произошла ошибка при получении данных. Попробуйте повторить позже"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchItemResults count];
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
        MGItem *currentItem = [self.searchItemResults objectAtIndex:indexPath.row];
        
        [cell.itemImageView setImageWithURL:[NSURL URLWithString:currentItem.itemImage] placeholderImage:[UIImage imageNamed:@"noimage"]];
        cell.itemNameLabel.text = currentItem.itemName;
        cell.itemPriceLabel.text = [NSString stringWithFormat:@"%@ грн.", currentItem.itemPrice];
        
        return cell;
    } else {
        MGOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
        MGOrder *currentOrder = [self.ordersContent objectAtIndex:indexPath.row];
        
        cell.orderDateLabel.text = [NSDate getDayFromDate:currentOrder.orderDate];
        cell.orderPriceLabel.text = [NSString stringWithFormat:@"%@ грн.", currentOrder.orderSummaryPrice];
        cell.itemNameLabel.text = currentOrder.itemName;
        if ([currentOrder.orderState isEqualToString:@"new"]) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.orderIDLabel.text = [NSString stringWithFormat:@"№ %@", currentOrder.orderID];
            cell.customerNameLabel.text = currentOrder.customerName;
            cell.orderDateLabel.textColor = newOrderDateColor;
        } else {
            cell.backgroundColor = otherOrderCellBackgroundColor;
            cell.orderDateLabel.textColor = [UIColor blackColor];
            cell.customerNameLabel.text = [NSString stringWithFormat:@"№ %@", currentOrder.orderID];
            if ([currentOrder.orderState isEqualToString:@"accepted"]) {
                cell.orderIDLabel.text = @"ПРИНЯТ";
            } else if ([currentOrder.orderState isEqualToString:@"declined"]) {
                cell.orderIDLabel.text = @"ОТМЕНЕН";
            } else if ([currentOrder.orderState isEqualToString:@"draft"]) {
                cell.orderIDLabel.text = @"ЧЕРНОВИК";
            } else if ([currentOrder.orderState isEqualToString:@"closed"]) {
                cell.orderIDLabel.text = @"ЗАКРЫТ";
            } else {
                cell.orderIDLabel.text = @"НЕИЗВЕСТНЫЙ";
            }
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        MGItem *selectedItem = [self.searchItemResults objectAtIndex:indexPath.row];
        NSPredicate *orderPredicate = [NSPredicate predicateWithFormat:@"orderID == %@", selectedItem.orderID];
        NSArray *filteredArray = [self.ordersContent filteredArrayUsingPredicate:orderPredicate];
        if ([filteredArray count] > 0) {
            MGOrder *selectedOrder = [filteredArray objectAtIndex:0];
            NSUInteger selectedIndexPath = [self.ordersContent indexOfObject:selectedOrder];
            MGDetailOrderViewController *detailViewController = [[MGDetailOrderViewController alloc] init];
            [detailViewController setDetailedContent:selectedOrder];
            [detailViewController setOrdersContent:self.ordersContent];
            [detailViewController setDetailedContentIndex:selectedIndexPath];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"searchKeys CONTAINS[c] %@", searchText];
    NSArray *searchResults = [self.ordersContent filteredArrayUsingPredicate:resultPredicate];
    NSMutableArray *searchItemResults = [NSMutableArray array];
    [searchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MGOrder *order = obj;
        [searchItemResults addObjectsFromArray:order.items];
    }];
    
    self.searchItemResults = searchItemResults;
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
    [detailViewController setOrdersContent:self.ordersContent];
    [detailViewController setDetailedContentIndex:selectedIndexPath.row];
}


@end
