//
//  MGOrderListCell.h
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;


@end
