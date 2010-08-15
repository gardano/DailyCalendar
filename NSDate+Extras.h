//
//  NSDate+Extras.h
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDate (Extras)
- (NSDate *)dateWithAddedHours:(int)hours;
- (NSDate *)dateWithAddedMinutes:(int)minutes;
- (NSDate *)dateWithAddedDays:(int)days;
- (NSDate *)dateWithAddedMonths:(int)months;
- (NSDate *)timeWithHour:(int)hour andMinute:(int)minute;
- (NSDate *)cleanedDate;
- (NSString *)dateString;
- (NSString *)timeString;
- (NSString *)dateWithTimeString;
@end
