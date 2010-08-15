//
//  AppointmentEventDelegate.h
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppointmentView;
typedef enum {
	MVResizingUnknown,
	MVResizingUp,
	MVResizingDown
} MVResizing;

@protocol AppointmentEventDelegate<NSObject>
- (void)moveAppointment:(AppointmentView *)apptView withEvent:(NSEvent *)anEvent;
- (void)resizeAppointment:(AppointmentView *)apptView withEvent:(NSEvent *)event resizing:(MVResizing)resizing;
- (void)mouseDown:(NSEvent *)anEvent withEventView:(AppointmentView *)eventView;
//- (void)resize:(NSEvent *)anEvent withEventView:(AppointmentView *)eventView resizing:(MVResizing)resizing;
- (IBAction)saveEvent:(id)sender;
- (IBAction)deleteEvent:(id)sender;
@end
