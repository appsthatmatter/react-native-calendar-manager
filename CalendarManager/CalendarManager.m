//
//  CalendarManager.m
//  CalendarManager
//
//  Created by Vladimir Adamic on 12/05/16.
//  Copyright © 2016 ShoutEm. All rights reserved.
//

#import "CalendarManager.h"

#import <Foundation/Foundation.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>

#import "AppDelegate.h"
@implementation CalendarManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSDictionary *)details)
{
    if (!self.eventStore)
    {
        [self initEventStoreWithCalendarCapabilities:details];
        return;
    }
    
    // Empty string is converted to uknown file path URL
    // We want to treat it as invalid url
    NSString *rsvpLink = details[@"rsvpLink"];
    NSURL *URL = rsvpLink.length > 0 ?  [RCTConvert NSURL:rsvpLink] : nil;

    NSString *name = [RCTConvert NSString:details[@"name"]];
    NSString *location = [RCTConvert NSString:details[@"location"]];
    NSDate *startTime = [RCTConvert NSDate:details[@"startTime"]];
    NSDate *endTime = [RCTConvert NSDate:details[@"endTime"]];

    EKEvent *event = nil;

    event = [EKEvent eventWithEventStore:self.eventStore];
    event.startDate = startTime;
    event.endDate = endTime;
    event.title = name;
    event.URL = URL;
    event.location = location;
    
    EKEventEditViewController *editEventController = [[EKEventEditViewController alloc] init];
    editEventController.event = event;
    editEventController.eventStore = self.eventStore;
    editEventController.editViewDelegate = self;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [delegate.window.rootViewController presentViewController:editEventController animated:YES completion:nil];
}

#pragma mark - EventView delegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initEventStoreWithCalendarCapabilities:(NSDictionary *)details
{
    
    EKEventStore *localEventStore = [[EKEventStore alloc] init];
    [localEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.eventStore = localEventStore;
                 [self addEvent:details];
             });
         else
             NSLog(@"User denied calendar access");
     }];
}

@end

