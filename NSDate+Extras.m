//
//  NSDate+Extras.m
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import "NSDate+Extras.h"


@implementation NSDate (Extras)
- (NSDate *)dateWithAddedHours:(int)hours {
	NSTimeInterval interval = 60 * 60 * hours;
	NSDate *d = [self dateByAddingTimeInterval:interval];
	return d;
}

- (NSDate *)dateWithAddedMinutes:(int)minutes {
	NSTimeInterval interval = 60 * minutes;
	NSDate *d = [self dateByAddingTimeInterval:interval];
	return d;
}

- (NSDate *)timeWithHour:(int)hour andMinute:(int)minute {
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *c = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit|NSYearCalendarUnit| NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
	[c setHour:hour];
	[c setMinute:minute];
	NSDate *d = [cal dateFromComponents:c];
	return d;
}

- (NSDate *)dateWithAddedDays:(int)days {
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setLocale:[NSLocale currentLocale]];
	NSDateComponents *dc = [cal components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit fromDate:self];
	
	int newDay= [dc day] + days;
	[dc setDay:newDay];
	
	NSDate *d = [cal dateFromComponents:dc];
	return d;
}
- (NSDate *)dateWithAddedMonths:(int)months {
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setLocale:[NSLocale currentLocale]];
	NSDateComponents *dc = [cal components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit fromDate:self];
	
	int newMonth = [dc month] + months;
	[dc setMonth:newMonth];
	[dc setDay:1];
	
	NSDate *d = [cal dateFromComponents:dc];
	return d;
}
- (NSDate *)cleanedDate {
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	[gregorian setLocale:[NSLocale currentLocale]];
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [gregorian components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:self];
	NSDate *d = [gregorian dateFromComponents:weekdayComponents];
	return d;
}

- (NSString *)dateString {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterNoStyle];
	NSString *d = [df stringFromDate:self];
	[df release];
	return d;
}
- (NSString *)timeString {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterNoStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];
	NSString *d = [df stringFromDate:self];
	[df release];
	return d;
}
- (NSString *)dateWithTimeString {
	NSString *ret = [NSString stringWithFormat:@"%@ - %@", [self dateString], [self timeString]];
	return ret;
}
@end
