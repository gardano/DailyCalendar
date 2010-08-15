//
//  AppointmentView.h
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright 2010 MVSICHA•COM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppointmentEventDelegate.h"

@interface AppointmentView : NSView {
	id<AppointmentEventDelegate>eventDelegate;
	NSManagedObject *appointment;
	NSTextField *titleField;
	BOOL selected;
}
@property (nonatomic, assign) id<AppointmentEventDelegate>eventDelegate;
@property (nonatomic, retain) NSManagedObject *appointment;
@property (nonatomic, retain) NSTextField *titleField;
@property (nonatomic, assign) BOOL selected;

- (void)toggleSelected;
@end
