//
//  MGDetailOrderViewController.m
//  Deal.by
//
//  Created by Morion Black on 4/27/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "MGDetailOrderViewController.h"
#import "MGDetailOrderCell.h"
#import "MGItemCell.h"

@interface MGDetailOrderViewController ()

@end

@implementation MGDetailOrderViewController

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
    
    self.title = [NSString stringWithFormat:@"Заказ №%@", [self.detailedContent orderID]];
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
    return [[self.detailedContent items] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSUInteger row = [indexPath row];
    if (row == 0) {
        MGDetailOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailOrderCell" forIndexPath:indexPath];
        cell.orderIDLabel.text = [self.detailedContent orderID];
        cell.customerNameLabel.text = [self.detailedContent customerName];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yy HH:mm"];
        cell.orderDateLabel.text = [formatter stringFromDate:[self.detailedContent orderDate]];
        cell.customerPhoneLabel.text = [self.detailedContent customerPhone];
        cell.customerEmailLabel.text = [self.detailedContent customerEmail];
        cell.customerAddressLabel.text = [self.detailedContent customerAddress];
        
        return cell;
    } else {
        MGItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        NSDictionary *item = [[self.detailedContent items] objectAtIndex:row - 1];
        cell.itemNameLabel.text = item[@"name"];
        cell.itemCountAndPriceLabel.text = [NSString stringWithFormat:@"%@ грн. | %@ шт.", item[@"price"], item[@"quantity"]];
        cell.itemPriceSummaryLabel.text = [NSString stringWithFormat:@"%.2f грн.", [item[@"price"] floatValue] * [item[@"quantity"] floatValue]];
        [cell.itemImageView setImageWithURL:[NSURL URLWithString:item[@"image"]] placeholderImage:[UIImage imageNamed:@""]];
        
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 210.0;
    
    if (indexPath.row > 0) {
        height = 125.0; // Item Cell
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = 50.0;
    CGFloat labelWidth = 280.0;
    CGFloat labelHeight = 30.0;
    CGRect footerFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, footerHeight);
    UIView *footerTableView = [[UIView alloc] initWithFrame:footerFrame];
    
    CGRect labelFrame = CGRectMake((footerFrame.size.width - labelWidth) / 2.0,
                                   (footerFrame.size.height - labelHeight) / 2.0,
                                   labelWidth,
                                   labelHeight);
    UILabel *summaryOrderPriceLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [summaryOrderPriceLabel setFont:[UIFont systemFontOfSize:20.0]];
    [summaryOrderPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [summaryOrderPriceLabel setBackgroundColor:[UIColor lightGrayColor]];
    [summaryOrderPriceLabel setText:[NSString stringWithFormat:@"%@ грн.", [self.detailedContent orderSummaryPrice]]];
    [footerTableView addSubview:summaryOrderPriceLabel];
    
    return footerTableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
