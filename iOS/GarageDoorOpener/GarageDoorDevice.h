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
#define GARAGE_DOOR_STATE_UNKNOWN_STR @"State Unknown"

@interface GarageDoorDevice : NSObject

- (void)getDeviceStateWithCompletion:(nullable void (^)(NSString * _Nullable deviceState, NSError * _Nullable error))completion;
- (void)toggleGarageDoorWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;
- (void)toggleGarageLedsWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end
