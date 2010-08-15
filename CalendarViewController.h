//
//  CalendarViewController.h
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppointmentEventDelegate.h"

@interface CalendarViewController : NSViewController <AppointmentEventDelegate> {
	NSMatrix *dayMatrix;
	NSArray *hours;
	NSArrayController *hoursArrayController;
	NSMutableArray *selectedHours;
	NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, retain) IBOutlet NSMatrix *dayMatrix;
@property (nonatomic, retain) NSMutableArray *selectedHours;
@property (nonatomic, retain) IBOutlet NSArrayController *hoursArrayController;
@property (nonatomic, retain) NSArray *hours;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)loadAppointments;
- (void)drawAppointment:(NSManagedObject *)appt;

@end
