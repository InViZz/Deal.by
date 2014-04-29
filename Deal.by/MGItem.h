//
//  MGItem.h
//  Deal.by
//
//  Created by Morion Black on 4/29/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGItem : NSObject

@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemPrice;
@property (strong, nonatomic) NSString *itemQuantity;
@property (strong, nonatomic) NSString *itemImage;

@end
