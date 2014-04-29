//
//  MGOrderListCell.m
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "MGOrderListCell.h"

@implementation MGOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
