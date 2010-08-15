//
//  DailyCalendar_AppDelegate.h
//  DailyCalendar
//
//  Created by Tom Ryan on 14/08/10.
//  Copyright MVSICHA•COM 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CalendarViewController;

@interface DailyCalendar_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	CalendarViewController *calendarViewController;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet CalendarViewController *calendarViewController;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
