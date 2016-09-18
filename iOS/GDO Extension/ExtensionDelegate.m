//
//  ExtensionDelegate.m
//  GDO Extension
//
//  Created by Benjamin Young on 9/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "ExtensionDelegate.h"

@import WatchConnectivity;

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    
    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        // TODO: See if we need this statement
        //session.delegate = self;
        [session activateSession];
    }
    
}


- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

@end
