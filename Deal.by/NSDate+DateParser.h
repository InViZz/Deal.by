//
//  NSDate+DateParser.h
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateParser)

+ (NSDate *)getDateFromString:(NSString *)date;
+ (NSDate *)getDateFromString:(NSString *)date withFormat:(NSString *)format;
+ (NSString *)getTimeFromDate:(NSDate *)date;
+ (NSString *)getDayFromDate:(NSDate *)date;

@end
