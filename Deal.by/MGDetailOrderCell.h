//
//  MGDetailOrderCell.h
//  Deal.by
//
//  Created by Morion Black on 4/27/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGDetailOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerAddressLabel;

@end
