//
//  DateStringValueTransformer.m
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import "DateStringValueTransformer.h"
#import "NSDate+Extras.h"

@implementation DateStringValueTransformer
+ (Class)transformedValueClass {
	return [NSString class];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
- (id)transformedValue:(id)value {
	id retVal = nil;
	if([value isKindOfClass:[NSDate class]]) {
		retVal = [value timeString];
	} else if ([value isKindOfClass:[NSArray class]]) {
		NSArray *ary = [value valueForKey:@"timeString"];
		retVal = ary;
	}
	return retVal;
}
@end
