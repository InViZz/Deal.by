//
//  MGOrderAPI.h
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface MGOrderAPI : AFHTTPSessionManager

+ (MGOrderAPI *)sharedClient;

- (NSURLSessionDataTask *)getOrdersWithBlock:( void (^)(NSArray *results, NSError *error) )completion;

@end
