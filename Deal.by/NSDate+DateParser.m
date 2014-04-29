//
//  NSDate+DateParser.m
//  Deal.by
//
//  Created by Morion Black on 4/26/14.
//  Copyright (c) 2014 Morion Black. All rights reserved.
//

#import "NSDate+DateParser.h"

@implementation NSDate (DateParser)

+ (NSDate *)getDateFromString:(NSString *)date
{
    return [self getDateFromString:date withFormat:@"dd.MM.yy HH:mm"];
}

+ (NSDate *)getDateFromString:(NSString *)date withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:date];
}

+ (NSString *)getTimeFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString *)getDayFromDate:(NSDate *)date
{
    NSString *currentWeekday = [self checkForNearDay:date];
    
    if (!currentWeekday) {
        currentWeekday = [NSString string];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"dd MMM"];
        currentWeekday = [formatter stringFromDate:date];
    }
    
    return currentWeekday;
}

+ (NSString *)checkForNearDay:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yy"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSString *yesterday = [formatter stringFromDate:[NSDate dateWithTimeInterval:-(60 * 60 * 24) sinceDate:[NSDate date]]];
//    NSDate *weekAgo = [NSDate dateWithTimeInterval:-(60 * 60 * 24 * 7) sinceDate:[NSDate date]];
    NSString *needDate = [formatter stringFromDate:date];
    if ([needDate isEqualToString:now]) {
        return [self getTimeFromDate:date];
    } else if ([needDate isEqualToString:yesterday]) {
        return @"вчера";
    }
//    else if ([date compare:weekAgo] == NSOrderedAscending) {
//        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
//        [dayFormatter setLocale:[NSLocale currentLocale]];
//        [dayFormatter setDateFormat:@"dd MMMM"];
//        return [dayFormatter stringFromDate:date];
//    }
    
    return nil;
}

@end
