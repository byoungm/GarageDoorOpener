//
//  GarageDoorDevice.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/21/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GARAGE_DOOR_OPEN_STR @"Open"
#define GARAGE_DOOR_CLOSED_STR @"Closed"
#define GARAGE_LIGHT_ON_STR @"On"
#define GARAGE_LIGHT_OFF_STR @"Off"
#define GARAGE_STATE_UNKNOWN_STR @"Unknown"
#define GARAGE_STATE_UNABLE_TO_CONNECT_STR @"No Connection"

@interface GarageDoorDevice : NSObject

- (void)getDeviceStateWithCompletion:(nullable void (^)(NSString * _Nullable doorState,
                                                        NSString * _Nullable lightState,
                                                        NSError * _Nullable error))completion;
- (void)toggleGarageDoorWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;
- (void)toggleGarageLedsWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end
