//
//  AppointmentView.m
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import "AppointmentView.h"
#import "NSDate+Extras.h"


@implementation AppointmentView
@synthesize eventDelegate, appointment, titleField, selected;

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {

		self.titleField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
		[self.titleField setBackgroundColor:[[NSColor blueColor] colorWithAlphaComponent:0.3]];
		[self.titleField setEditable:NO];
		[self.titleField setAutoresizingMask:NSViewWidthSizable|NSViewMaxXMargin];
		[self.titleField refusesFirstResponder];
		[self.titleField setTextColor:[NSColor whiteColor]];
		[self.titleField setBordered:NO];
		[self.titleField setBezeled:NO];
		[self.titleField setFont:[NSFont fontWithName:@"Lucida Grande" size:12.0f]];
		
		[self addSubview:self.titleField];
		
		if(frame.size.height < 20) {
			[self.titleField setHidden:YES];
		}

		NSTrackingArea *trackingArea = [[[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow|NSTrackingInVisibleRect owner:self userInfo:nil] autorelease];
		[self addTrackingArea:trackingArea];
	}
    return self;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)toggleSelected {
	self.selected = !self.selected;
}

- (void)setSelected:(BOOL)isSelected {
	selected = isSelected;
	[self setNeedsDisplay:YES];
}

- (void)keyDown:(NSEvent *)theEvent {
	if([[theEvent characters] characterAtIndex:0] == NSDeleteCharacter) {
		[self.eventDelegate deleteEvent:self];
	} else {
		[super keyDown:theEvent];
	}
}

- (void)drawRect:(NSRect)dirtyRect {
    if(dirtyRect.size.height > 19) {
		[self.titleField setHidden:NO];
		[self.titleField setStringValue:[[self.appointment valueForKey:@"date"] timeString]];
	}
	[NSGraphicsContext saveGraphicsState];
	// for the Appointment View as a whole
	
	NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:7.0f yRadius:7.0f];
	[borderPath setLineWidth:3.0f];
	[borderPath stroke];
	
	if(self.selected) {
		[[[NSColor blueColor] colorWithAlphaComponent:0.3] set];
	} else {
		[[[NSColor yellowColor] colorWithAlphaComponent:0.6] set];
	}
	
	[borderPath fill];
	if(self.selected) {
		[[NSColor redColor] set];
	} else {
		[[NSColor blackColor] set];
	}
	[borderPath closePath];
	
	[NSGraphicsContext restoreGraphicsState];
}
/*
 Cursor Stuff
 */
- (void)mouseMoved:(NSEvent *)theEvent {
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	float height = self.frame.size.height;
	
	if(point.y < 6 && point.x > 0) {
		[[NSCursor resizeDownCursor] push];
	} else if (point.y  > height-4 || point.y == height) {
		[[NSCursor resizeUpCursor] push];
	} else {
		if(![[NSCursor currentCursor] isEqual:[NSCursor arrowCursor]]) {
			[NSCursor pop];
		}
	}
}
- (void)mouseExited:(NSEvent *)theEvent {
	[NSCursor pop];
	[[NSCursor arrowCursor] push];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	if([[NSCursor currentCursor] isEqual:[NSCursor resizeUpCursor]]) {
		[self.eventDelegate resizeAppointment:self withEvent:theEvent resizing:MVResizingUp];
	} else if ([[NSCursor currentCursor] isEqual:[NSCursor resizeDownCursor]]) {
		[self.eventDelegate resizeAppointment:self withEvent:theEvent resizing:MVResizingDown];
	} else {
		[self.eventDelegate moveAppointment:self withEvent:theEvent];
	}
}

- (void)mouseDown:(NSEvent *)event {
	NSLog(@"Mouse down");
	[self becomeFirstResponder];
	[self.eventDelegate mouseDown:event withEventView:self];
}

- (BOOL)isFlipped {
	return YES;
}

- (void)dealloc {
	[titleField release];
	[appointment release];
	[super dealloc];
}
@end
