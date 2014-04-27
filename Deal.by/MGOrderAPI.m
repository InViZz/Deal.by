//
//  MGOrderAPI.m
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "MGOrderAPI.h"
#import "XMLDictionary.h"
#import "MGOrder.h"

@implementation MGOrderAPI

static NSString *kBaseURL = @"http://my.deal.by/";

+ (MGOrderAPI *)sharedClient {
    static MGOrderAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kBaseURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        
        _sharedClient = [[MGOrderAPI alloc] initWithBaseURL:baseURL
                                        sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFXMLParserResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)getOrdersWithBlock:( void (^)(NSArray *results, NSError *error) )completion
{
    NSURLSessionDataTask *task = [self GET:@"cabinet/export_orders/xml/31036"
                                parameters:@{@"hash_tag": @"0ecc3ed1de227f51bf44ca80ae7abf6b"}
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSDictionary *orderDictionary = [NSDictionary dictionaryWithXMLParser:responseObject];
                                               NSArray *parsedResults = [self parseOrders:orderDictionary];
                                               completion(parsedResults, nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP: %ld", (long)httpResponse.statusCode);
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    
    return task;
}

- (NSArray *)parseOrders:(NSDictionary *)orders
{
    NSMutableArray *parsedOrders = [NSMutableArray array];
    NSArray *arrayOfOrders = orders[@"order"];
    
    [arrayOfOrders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MGOrder *newOrder = [[MGOrder alloc] init];
        NSMutableArray *searchKeys = [NSMutableArray array];
        newOrder.orderID = obj[@"_id"];
        newOrder.orderState = obj[@"_state"];
        newOrder.customerName = obj[@"name"];
        newOrder.orderDate = [NSDate getDateFromString:obj[@"date"]];
        newOrder.orderSummaryPrice = obj[@"priceUAH"];
        newOrder.customerPhone = obj[@"phone"];
        newOrder.customerAddress = obj[@"address"];
        newOrder.customerEmail = obj[@"email"];
        [searchKeys addObject:newOrder.orderID];
        [searchKeys addObject:newOrder.customerName];
        [searchKeys addObject:newOrder.customerPhone];
        if ([obj[@"items"][@"item"] isKindOfClass:[NSArray class]]) {
            newOrder.items = obj[@"items"][@"item"];
            newOrder.itemName = obj[@"items"][@"item"][0][@"name"];
            [newOrder.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [searchKeys addObject:obj[@"_id"]];
                [searchKeys addObject:obj[@"name"]];
            }];
        } else {
            newOrder.items = [NSArray arrayWithObject:obj[@"items"][@"item"]];
            newOrder.itemName = obj[@"items"][@"item"][@"name"];
            [searchKeys addObject:obj[@"items"][@"item"][@"_id"]];
            [searchKeys addObject:newOrder.itemName];
        }
        newOrder.searchKeys = [searchKeys componentsJoinedByString:@" "];
        
        [parsedOrders addObject:newOrder];
    }];
    
    return parsedOrders;
}

@end
