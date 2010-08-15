//
//  CalendarViewController.m
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import "CalendarViewController.h"
#import "AppointmentView.h"
#import "AppointmentCell.h"
#import "NSDate+Extras.h"

#define kStartHour 8
#define kEndHour 21

@interface CalendarViewController(Private)
- (void)constructHours;
@end


@implementation CalendarViewController
@synthesize managedObjectContext;
@synthesize dayMatrix, hours, hoursArrayController;
@synthesize selectedHours;

- (void)loadView {
	[super loadView];
	[self constructHours];
	
	[self.dayMatrix setCellClass:[AppointmentCell class]];
	[self.dayMatrix removeRow:0];
	[self.dayMatrix setAutosizesCells:NO];
	[self.dayMatrix setBackgroundColor:[NSColor yellowColor]];
	[self.hoursArrayController addObserver:self forKeyPath:@"selectedObjects" options:0 context:NULL];
	[self loadAppointments];
}

- (void)constructHours {
	NSMutableArray *tempAry = [NSMutableArray array];
	//starting 15 minutes earlier than what we want because of dateWithAddedMinutes.
	NSDate *theDate = [[NSDate date] timeWithHour:kStartHour-1 andMinute:45]; 
	int totalNumberOfCells = (kEndHour-(kStartHour)) * 4;//because we are in 15 minute increments
	NSSize cellSize = [self.dayMatrix cellSize];
	for(int i=0;i<totalNumberOfCells;i++) {
		float cellX = (cellSize.height * i) - cellSize.height;
		NSDictionary *cellDict = [NSDictionary dictionaryWithObjectsAndKeys:
								  theDate, @"date",
								  [NSNumber numberWithFloat:cellX], @"xvalue",
								  [NSNumber numberWithInt:i], @"index",
								  nil];
		[tempAry addObject:cellDict];
		theDate = [theDate dateWithAddedMinutes:15];
	}
	self.hours = tempAry;
}

#pragma mark  Appointments
- (void)loadAppointments {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sd]];
	[sd release];
	
	NSError *error = nil;
	NSArray *appts = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	
	for(NSManagedObject *a in appts) {
		[self drawAppointment:a];
	}
}
- (void)drawAppointment:(NSManagedObject *)appt {
	CGSize cellSize = [dayMatrix cellSize];
	NSDate *date = [appt valueForKey:@"date"];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"date=%@", date];
	NSArray *dates = [self.hours filteredArrayUsingPredicate:pred];
	
	float x = [[[dates valueForKey:@"xvalue"] lastObject] floatValue];

	float y = cellSize.height * [[appt valueForKey:@"blockCount"] floatValue];
	NSRect r = NSMakeRect(50, x , cellSize.width-50, y);
	AppointmentView *v = [[[AppointmentView alloc] initWithFrame:r] autorelease];
	v.appointment = appt;
	[v setAutoresizingMask:NSViewWidthSizable|NSViewMaxXMargin];
	v.eventDelegate = self;
	[dayMatrix addSubview:v];
	[v setNeedsDisplay:YES];
}

#pragma mark Selection
/*
 Think of this as the mouse handler for a new appointment.
 */
- (void)setSelectedHours:(NSMutableArray *)someHours {
	if(![selectedHours isEqualToArray:someHours]) {
		[selectedHours release];
		selectedHours = [someHours retain];
	}

	NSArray *matrixSelectedCells = [self.dayMatrix selectedCells];
	[self.dayMatrix deselectAllCells];
	
	int firstIndex = [[self.dayMatrix cells] indexOfObject:[matrixSelectedCells objectAtIndex:0]];
	int lastIndex = [[self.dayMatrix cells] indexOfObject:[matrixSelectedCells lastObject]];
	/* we don't want just a single selection */
	if(firstIndex == lastIndex) return;
	
	float appointmentPadding = 50.0f;
	
	NSRect appointmentRect = [self.dayMatrix frame];
	float cellHeight = [self.dayMatrix cellSize].height;
	float appointmentY = (firstIndex * cellHeight);
	float appointmentHeight = [matrixSelectedCells count] * cellHeight;
	appointmentRect.origin.y = appointmentY;
	appointmentRect.size.height = appointmentHeight;
	appointmentRect.origin.x = appointmentPadding;
	appointmentRect.size.width -= appointmentPadding;
	
	AppointmentView *appointmentView = [[[AppointmentView alloc] initWithFrame:appointmentRect] autorelease];
	[appointmentView setAutoresizingMask:NSViewWidthSizable|NSViewMaxXMargin];
	appointmentView.eventDelegate = self;
	
	// create the appointment
	NSManagedObject *appointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:self.managedObjectContext];
	NSDictionary *selectedDate = [[self.hours objectAtIndex:firstIndex+1] objectForKey:@"date"];
	[appointment setValue:selectedDate forKey:@"date"];
	[appointment setValue:[NSNumber numberWithInt:lastIndex-(firstIndex-1)] forKey:@"blockCount"];
	appointmentView.appointment = appointment;
	
	[self.dayMatrix addSubview:appointmentView];
}


#pragma mark AppointmentEventDelegate
- (void)mouseDown:(NSEvent *)anEvent withEventView:(AppointmentView *)eventView {
	// handle selection
	NSPredicate *apptPredicate = [NSPredicate predicateWithFormat:@"class=%@", [AppointmentView class]];
	NSArray *appts = [[self.dayMatrix subviews] filteredArrayUsingPredicate:apptPredicate];
	for(AppointmentView *a in appts) {
		if(![a isEqual:eventView])
			a.selected = NO;
	}
	[eventView toggleSelected];
}

- (void)moveAppointment:(AppointmentView *)apptView withEvent:(NSEvent *)anEvent {
	NSPoint newLocation;
	NSPoint dragLocation = [apptView convertPoint:[anEvent locationInWindow] fromView:nil];
	
	while(1) {
		anEvent = [[apptView window] nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
		newLocation = [self.dayMatrix convertPoint:[anEvent locationInWindow] fromView:nil];
		
		float y = newLocation.y-dragLocation.y;
		y = y < 0 ? 0 : y; // make sure we're >= 0
		
		CGRect appointmentFrame = apptView.frame;
		appointmentFrame.origin.y = y;
		
		apptView.frame = appointmentFrame;
		
		if([anEvent type] == NSLeftMouseUp) {
			float fy = appointmentFrame.origin.y;
			NSSize cellSize = [dayMatrix cellSize];
			for(int i=0;i<[self.hours count];i++) {
				NSDictionary *d = [self.hours objectAtIndex:i];
				float df = [[d objectForKey:@"xvalue"] floatValue];
				if(df >= fy && df <=fy+cellSize.height) {
					appointmentFrame.origin.y = df;
					apptView.frame = appointmentFrame;
					NSDictionary *d0 = [self.hours objectAtIndex:i];
					NSDate *cellDate = [d0 objectForKey:@"date"];
					[apptView.appointment setValue:cellDate forKey:@"date"];
					[self saveEvent:nil];
					break;
				}
			}
			break;
		}
	}
}

- (void)resizeAppointment:(AppointmentView *)apptView withEvent:(NSEvent *)event resizing:(MVResizing)resizing {
	NSPoint newLocation;

	while(1) {
		event = [[apptView window] nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
		newLocation = [apptView convertPoint:[event locationInWindow] fromView:nil];
		
		CGRect appointmentFrame = apptView.frame;
		if(resizing == MVResizingUp) {
			appointmentFrame.size.height = newLocation.y;
		} else if (resizing == MVResizingDown) {
			appointmentFrame.size.height -= newLocation.y;
			appointmentFrame.origin.y += newLocation.y;
		}
		
		apptView.frame = appointmentFrame;
		
		
		if([event type] == NSLeftMouseUp) {
			float fy = appointmentFrame.origin.y;
			float blockSize = ceil(appointmentFrame.size.height/20.0f);
			NSSize cellSize = [dayMatrix cellSize];
			for(int i=0;i<[self.hours count];i++) {
				NSDictionary *d = [self.hours objectAtIndex:i];
				float df = [[d objectForKey:@"xvalue"] floatValue];
				if(df >= fy && df <=fy+cellSize.height) {
					appointmentFrame.origin.y = df;
					apptView.frame = appointmentFrame;
					NSDictionary *d0 = [self.hours objectAtIndex:i];
					NSDate *cellDate = [d0 objectForKey:@"date"];
					[apptView.appointment setValue:cellDate forKey:@"date"];
					[apptView.appointment setValue:[NSNumber numberWithInt:blockSize] forKey:@"blockCount"];
					[apptView setNeedsDisplay:YES];
					break;
				}
			}
			break;
		}
	}
}

- (IBAction)saveEvent:(id)sender {
	NSError *error = nil;
	if(![self.managedObjectContext save:&error]) {
		NSLog(@"Could not save appointment!", error);
	}
}

- (IBAction)deleteEvent:(id)sender {
	AppointmentView *ev = (AppointmentView *)sender;
	[self.managedObjectContext deleteObject:ev.appointment];
	[ev removeFromSuperview];
	[self saveEvent:nil];
}

- (void)dealloc {
	[managedObjectContext release];
	[hoursArrayController release];
	[hours release];
	[dayMatrix release];
	
	[super dealloc];
}
@end
