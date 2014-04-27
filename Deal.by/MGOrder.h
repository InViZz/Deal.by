//
//  MGOrder.h
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGOrder : NSObject

@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *orderState;
@property (strong, nonatomic) NSString *customerName;
@property (strong, nonatomic) NSDate *orderDate;
@property (strong, nonatomic) NSString *orderSummaryPrice;
@property (strong, nonatomic) NSString *customerPhone;
@property (strong, nonatomic) NSString *customerAddress;
@property (strong, nonatomic) NSString *customerEmail;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *searchKeys;

@end
