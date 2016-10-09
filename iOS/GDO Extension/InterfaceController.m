//
//  InterfaceController.m
//  GDO Extension
//
//  Created by Benjamin Young on 9/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "InterfaceController.h"
#import "GDOWCDefines.h"

@import WatchConnectivity;

@interface InterfaceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *garageDoorButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *garageLightButton;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *garageDoorStatus;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *garageLightStatus;

- (void)sendWCiOSActionRequest:(GdoWcActionCode_t)actionCode withCompletion:(nullable void (^)(void))completion;
- (void)displayErrorForWCReturn:(NSString *)err;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context
 {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
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

- (void)sendWCiOSActionRequest:(GdoWcActionCode_t)actionCode withCompletion:(void (^)(void))completion
{
    if ([[WCSession defaultSession] isReachable])
    {
        [[WCSession defaultSession] sendMessage:@{GDO_WC_ACTION_REQUEST_KEY: [NSNumber numberWithInteger:actionCode]}
                                    replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                        NSLog(@"GDO WC DataBack: %@", replyMessage);
                                        NSString *valStr = [replyMessage objectForKey:GDO_WC_ERROR_OCCURED_KEY];
                                        if (valStr != nil)
                                        {
                                            [self displayErrorForWCReturn:valStr];
                                            completion();
                                        }
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



