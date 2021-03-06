//
//  MGDetailOrderViewController.m
//  Deal.by
//
//  Created by Morion Black on 4/27/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "MGDetailOrderViewController.h"
#import "MGOrderListTableViewController.h"
#import "MGDetailOrderCell.h"
#import "MGItemCell.h"
#import "MGItem.h"

#define ANIMATION_DURATION 0.75
#define FOOTER_HEIGHT 50.0

@interface MGDetailOrderViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehaviour;
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;

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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(dismissOrders)];
    [backButton setImage:[UIImage imageNamed:@"back_button"]];
     self.navigationItem.leftBarButtonItem = backButton;
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextOrder)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevOrder)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupDynamicKit];
}

- (void)setupDynamicKit
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.navigationController.view];
    
    self.collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.view]];
    [self.collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, -280.0)];
    [self.animator addBehavior:self.collisionBehaviour];
    
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.view]];
    self.gravityBehaviour.gravityDirection = CGVectorMake(-1, 0);
    [self.animator addBehavior:self.gravityBehaviour];
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.view] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 0.0f;
    self.pushBehavior.angle = 0.0f;
    [self.animator addBehavior:self.pushBehavior];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
    itemBehaviour.elasticity = 0.65f;
    [self.animator addBehavior:itemBehaviour];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextOrder
{
    if (self.detailedContentIndex != [self.ordersContent count] - 1) {
        MGOrder *nextOrder = [self.ordersContent objectAtIndex:self.detailedContentIndex + 1];
        MGDetailOrderViewController *nextViewController = [[MGDetailOrderViewController alloc] init];
        [nextViewController setDetailedContent:nextOrder];
        [nextViewController setOrdersContent:self.ordersContent];
        [nextViewController setDetailedContentIndex:self.detailedContentIndex + 1];
        
        [UIView animateWithDuration:ANIMATION_DURATION
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [self.navigationController pushViewController:nextViewController animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
                         }];

    } else {
        // new collision and gravity for last order 
        [self.animator removeBehavior:self.collisionBehaviour];
        self.collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.view]];
        [self.collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, -280.0, 0, 0)];
        [self.animator addBehavior:self.collisionBehaviour];
        
        [self.animator removeBehavior:self.gravityBehaviour];
        self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.view]];
        self.gravityBehaviour.gravityDirection = CGVectorMake(1, 0);
        [self.animator addBehavior:self.gravityBehaviour];
        
        self.pushBehavior.pushDirection = CGVectorMake(35.0f, 0.0f);
        self.pushBehavior.active = YES;
    }
}

- (void)prevOrder
{
    if (self.detailedContentIndex > 0) {
        MGOrder *nextOrder = [self.ordersContent objectAtIndex:self.detailedContentIndex - 1];
        MGDetailOrderViewController *nextViewController = [[MGDetailOrderViewController alloc] init];
        [nextViewController setDetailedContent:nextOrder];
        [nextViewController setOrdersContent:self.ordersContent];
        [nextViewController setDetailedContentIndex:self.detailedContentIndex - 1];
        
        [UIView animateWithDuration:ANIMATION_DURATION
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [self.navigationController pushViewController:nextViewController animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
                         }];
    } else {
        self.pushBehavior.pushDirection = CGVectorMake(35.0f, 0.0f);
        self.pushBehavior.active = YES;
    }
}

- (void)dismissOrders
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [tableView registerNib:[UINib nibWithNibName:@"MGDetailOrderCell" bundle:nil] forCellReuseIdentifier:@"DetailOrderCell"];
    [tableView registerNib:[UINib nibWithNibName:@"MGItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    
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
        MGItem *item = [[self.detailedContent items] objectAtIndex:row - 1];
        cell.itemNameLabel.text = item.itemName;
        cell.itemCountAndPriceLabel.text = [NSString stringWithFormat:@"%@ грн. | %@ шт.", item.itemPrice, item.itemQuantity];
        cell.itemPriceSummaryLabel.text = [NSString stringWithFormat:@"%.2f грн.", [item.itemPrice floatValue] * [item.itemQuantity floatValue]];
        [cell.itemImageView setImageWithURL:[NSURL URLWithString:item.itemImage] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
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
    return FOOTER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat labelWidth = 280.0;
    CGFloat labelHeight = 30.0;
    CGRect footerFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, FOOTER_HEIGHT);
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
