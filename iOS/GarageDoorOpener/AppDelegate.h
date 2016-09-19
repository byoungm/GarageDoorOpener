//
//  AppDelegate.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/15/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@import WatchConnectivity;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

