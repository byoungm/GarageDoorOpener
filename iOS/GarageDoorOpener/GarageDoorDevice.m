//
//  GarageDoorDevice.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/21/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "GarageDoorDevice.h"
#import "Spark-SDK.h"

#define PARTICLE_GARAGE_DOOR_DEVICE_NAME @"RB Duo 1"

#define WEB_API_MAIN_FUNCTION @"webapi"
#define WEB_API_ARG_GET_GARAGE_DOOR_STATE @"GARAGE_DOOR_GET_STATE"
#define WEB_API_ARG_GARAGE_DOOR_CLICK_BUTTON @"GARAGE_DOOR_CLICK_BUTTON"

#define LED_OFF FALSE
#define LED_ON  TRUE

@interface GarageDoorDevice()
@property (nonatomic, strong) SparkDevice* device;
@property (nonatomic) BOOL currentLedState;

- (void)attemptToConnectToGarageDoorDevice;
- (NSString *)decodeGarageDoorStateString:(int)stateEnum;

@end


@implementation GarageDoorDevice

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.device = nil;
        self.currentLedState = LED_OFF;
        [self attemptToConnectToGarageDoorDevice];
    }
    return self;
}

- (void)attemptToConnectToGarageDoorDevice
{
    if ([SparkCloud sharedInstance].isAuthenticated){
        [[SparkCloud sharedInstance] getDevices:^(NSArray *sparkDevices, NSError *error) {
            NSLog(@"%@",sparkDevices.description); // print all devices claimed to user
            
            // search for a specific device by name
            for (SparkDevice *device in sparkDevices)
            {
                if ([device.name isEqualToString:PARTICLE_GARAGE_DOOR_DEVICE_NAME])
                {
                    self.device = device;
                    break;
                }
            }
        }];
    }

}

- (NSString *)decodeGarageDoorStateString:(int)stateEnum
{
    const NSArray *GarageDoorStateStrings = @[GARAGE_DOOR_OPEN_STR, GARAGE_DOOR_CLOSED_STR, GARAGE_DOOR_STATE_UNKNOWN_STR];
    return GarageDoorStateStrings[stateEnum];
}

- (void)getDeviceStateWithCompletion:(nullable void (^)(NSString * _Nullable deviceState, NSError * _Nullable error))completion
{
    if (self.device)
    {
        [self.device callFunction:WEB_API_MAIN_FUNCTION withArguments:@[WEB_API_ARG_GET_GARAGE_DOOR_STATE] completion:^(NSNumber *resultCode, NSError *error) {
            NSString *garageStateStr = GARAGE_DOOR_STATE_UNKNOWN_STR;
            if (!error)
            {
                int res = [resultCode intValue];
                NSLog(@"Garage state :%d", res);
                garageStateStr = [self decodeGarageDoorStateString:res];
            }
            else
            {
                NSLog(@"Garage state error: %@", error);
            }
            completion(garageStateStr, error);
        }];
    }
    else
    {
        [self attemptToConnectToGarageDoorDevice];
        NSError *err = [NSError errorWithDomain:@"Device not connected or initalized" code:1000 userInfo:nil];
        completion(GARAGE_DOOR_STATE_UNABLE_TO_CONNECT_STR, err);
    }

}

- (void)toggleGarageDoorWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;
{
    if (self.device)
    {
        [self.device callFunction:@"webapi" withArguments:@[@"GARAGE_DOOR_CLICK_BUTTON"] completion:^(NSNumber *resultCode, NSError *error) {
            if (!error)
            {
                NSLog(@"Garage button pushed - Result Code:%d", [resultCode intValue]);
            }
            else
            {
                NSLog(@"Garage door error: %@", error);
            }
            completion(error);
        }];
    }
    else
    {
        NSError *err = [NSError errorWithDomain:@"Device not connected or initalized" code:1000 userInfo:nil];
        completion(err);
    }
}

- (void)toggleGarageLedsWithCompletion:(nullable void (^)(NSError * _Nullable error))completion
{
    const NSArray* LedCommands = @[@"LED_OFF",@"LED_ON"];
    if (self.device)
    {
        self.currentLedState = !self.currentLedState;
        [self.device callFunction:WEB_API_MAIN_FUNCTION withArguments:@[LedCommands[(int)self.currentLedState]] completion:^(NSNumber *resultCode, NSError *error) {
            if (!error)
            {
                NSLog(@"LED was tured on - Result Code:%d", [resultCode intValue]);
            }
            completion(error);
        }];
    }
    else
    {
        NSError *err = [NSError errorWithDomain:@"Device not connected or initalized" code:1000 userInfo:nil];
        completion(err);
    }
}

@end
