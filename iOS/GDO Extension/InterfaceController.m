//
//  InterfaceController.m
//  GDO Extension
//
//  Created by Benjamin Young on 9/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "InterfaceController.h"
#import "GDOWCDefines.h"
#import "GDOWKStatusLabel.h"

@import WatchConnectivity;

@interface InterfaceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *garageDoorButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *garageLightButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *garageDoorLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *garageLightLabel;

@property (strong, nonatomic) GDOWKDoorStatusLabel *garageDoorStatus;
@property (strong, nonatomic) GDOWKLightStatusLabel *garageLightStatus;
@property (strong, nonatomic) NSTimer *garageStateUpdateTimer;


- (void)sendWCiOSActionRequest:(NSString *)action withCompletion:(void (^)(void))completion;
- (void)displayErrorForWCReturn:(NSString *)err;
- (void)updateGarageDeviceState;

@end

#define GARAGE_DOOR_STATE_UPDATE_TIMER_INTERVAL_WATCH 1.0

@implementation InterfaceController

- (void)awakeWithContext:(id)context
 {
    [super awakeWithContext:context];

    // Configure interface objects here.
     self.garageDoorStatus = [[GDOWKDoorStatusLabel alloc] initWithWKLabel:self.garageDoorLabel];
     self.garageLightStatus = [[GDOWKLightStatusLabel alloc] initWithWKLabel:self.garageLightLabel];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if (!self.garageStateUpdateTimer || !self.garageStateUpdateTimer.valid)
    {
        self.garageStateUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:GARAGE_DOOR_STATE_UPDATE_TIMER_INTERVAL_WATCH
                                                                       target:self
                                                                     selector:@selector(updateGarageDeviceState)
                                                                     userInfo:nil
                                                                      repeats:YES];
    }
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [self.garageStateUpdateTimer invalidate];
    [super didDeactivate];
}

- (void)updateGarageDeviceState
{
    [self sendWCiOSActionRequest:GDO_WC_ACTION_GARAGE_GET_STATUS withCompletion:^{}];
}

- (IBAction)toggleLeds
{
    
    [self.garageLightButton setEnabled:NO];
    [self sendWCiOSActionRequest:GDO_WC_ACTION_GARAGE_LIGHT_TOGGLE withCompletion:^{
        [self.garageLightButton setEnabled:YES];
    }];
}

- (IBAction)garageDoorClicked
{
    [self.garageDoorButton setEnabled:NO];
    [self sendWCiOSActionRequest:GDO_WC_ACTION_GARAGE_DOOR_TOGGLE withCompletion:^{
        [self.garageDoorButton setEnabled:YES];
    }];
}

- (void)sendWCiOSActionRequest:(NSString *)action withCompletion:(void (^)(void))completion
{
    if ([[WCSession defaultSession] isReachable])
    {
        [[WCSession defaultSession] sendMessage:@{GDO_WC_KEY_ACTION_REQUEST: action}
                                    replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                        NSLog(@"GDO WC DataBack: %@", replyMessage);
                                        NSString *valStr = [replyMessage objectForKey:GDO_WC_KEY_ERROR_OCCURED];
                                        if (valStr != nil)
                                        {
                                            // TODO: Reenable this error display when we can give errors the user needs to know about.
                                            //[self displayErrorForWCReturn:valStr];
                                        }
                                        else
                                        {
                                            valStr = [replyMessage objectForKey:GDO_WC_KEY_LIGHT_STATUS];
                                            if (valStr != nil)
                                            {
                                                [self.garageLightStatus setStatus:valStr];
                                            }
                                            valStr = [replyMessage objectForKey:GDO_WC_KEY_DOOR_STATUS];
                                            if (valStr != nil)
                                            {
                                                [self.garageDoorStatus setStatus:valStr];
                                            }
                                        }
                                        completion();
                                    }
                                    errorHandler:^(NSError * _Nonnull error) {
                                        NSLog(@"GDO WC Error Occured: %@", error);
                                        completion();
                                    }];
    }
    else
    {
        [self displayErrorForWCReturn:GDO_WC_ERROR_COULD_NOT_CONNECT_TO_PHONE];
    }
}

- (void)displayErrorForWCReturn:(NSString *)err
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WKAlertAction *alert = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleDefault handler:^{
                                    NSLog(@"Error Alert: %@", err);
                                }];
        [self presentAlertControllerWithTitle:nil
                                      message:err
                               preferredStyle:WKAlertControllerStyleAlert
                                      actions:@[alert]];
    });
}

@end



