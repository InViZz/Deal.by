//
//  MGItemCell.h
//  Deal.by
//
//  Created by Morion Black on 4/27/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemCountAndPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceSummaryLabel;

@end
