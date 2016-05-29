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

typedef enum
{
    GARAGE_DOOR_OPEN = 0,
    GARAGE_DOOR_CLOSED = 1,
    GARAGE_DOOR_STATE_UNKNOWN = 0xFF,
} GarageDoorState_t;

typedef enum
{
    GARAGE_LIGHT_ON = 0,
    GARAGE_LIGHT_OFF = 1,
    GARAGE_LIGHT_STATE_UNKNOWN = 0xFF,
} GarageLightState_t;


@interface GarageDoorDevice()
@property (nonatomic, strong) SparkDevice* device;
@property (nonatomic) BOOL currentLedState;

- (void)attemptToConnectToGarageDoorDevice;
- (NSString *)decodeGarageDoorState:(int)stateEnum;
- (NSString *)decodeGarageLightState:(int)stateEnum;

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
                    if (device.connected)
                    {
                        self.device = device;
                    }
                    break;
                }
            }
        }];
    }

}

- (NSString *)decodeGarageDoorState:(int)stateEnum
{
    NSString *str;
    switch (stateEnum) {
        case GARAGE_DOOR_OPEN:
            str = GARAGE_DOOR_OPEN_STR;
            break;
        case GARAGE_DOOR_CLOSED:
            str = GARAGE_DOOR_CLOSED_STR;
            break;
        default:
            str = GARAGE_STATE_UNKNOWN_STR;
            break;
    }
    return str;
}

- (NSString *)decodeGarageLightState:(int)stateEnum
{
    NSString *str;
    switch (stateEnum) {
        case GARAGE_LIGHT_ON:
            str = GARAGE_LIGHT_ON_STR;
            break;
        case GARAGE_LIGHT_OFF:
            str = GARAGE_LIGHT_OFF_STR;
            break;
        default:
            str = GARAGE_STATE_UNKNOWN_STR;
            break;
    }
    return str;
}

- (void)getDeviceStateWithCompletion:(void (^)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))completion
{
    if (self.device)
    {
        [self.device callFunction:WEB_API_MAIN_FUNCTION withArguments:@[WEB_API_ARG_GET_GARAGE_DOOR_STATE] completion:^(NSNumber *resultCode, NSError *error) {
            NSString *doorStateStr = GARAGE_STATE_UNKNOWN_STR;
            NSString *lightStateStr = GARAGE_STATE_UNKNOWN_STR;
            if (!error)
            {
                int res = [resultCode intValue];
                NSLog(@"Garage State: %d", res);
                int doorEnum = res & 0xFF;
                int lightEnum = (res & 0xFF00) >> 8;
                doorStateStr = [self decodeGarageDoorState:doorEnum];
                lightStateStr = [self decodeGarageLightState:lightEnum];
            }
            else
            {
                NSLog(@"Garage state error: %@", error);
            }
            completion(doorStateStr, lightStateStr, error);
        }];
    }
    else
    {
        [self attemptToConnectToGarageDoorDevice];
        NSError *err = [NSError errorWithDomain:@"Device not connected or initalized" code:1000 userInfo:nil];
        completion(GARAGE_STATE_UNABLE_TO_CONNECT_STR,GARAGE_STATE_UNABLE_TO_CONNECT_STR, err);
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
