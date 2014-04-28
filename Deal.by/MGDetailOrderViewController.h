//
//  MGDetailOrderViewController.h
//  Deal.by
//
//  Created by Morion Black on 4/27/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGOrder.h"

@interface MGDetailOrderViewController : UITableViewController

@property NSUInteger detailedContentIndex;
@property (strong, nonatomic) MGOrder *detailedContent;
@property (strong, nonatomic) NSArray *ordersContent;

@end
