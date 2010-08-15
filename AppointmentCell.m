//
//  AppointmentCell.m
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AppointmentCell.h"


@implementation AppointmentCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[super drawWithFrame:cellFrame inView:controlView];
	
	if([self tag] % 4 == 1) {
		CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		CGContextSetLineWidth(context, 0.2);
		CGContextMoveToPoint(context, cellFrame.origin.x, cellFrame.origin.y);
		CGContextAddLineToPoint(context, cellFrame.size.width, cellFrame.origin.y);
		CGContextStrokePath(context);
	}
	
}

@end
