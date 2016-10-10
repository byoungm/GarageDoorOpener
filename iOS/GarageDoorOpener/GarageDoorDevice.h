//
//  GarageDoorDevice.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/21/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDODeviceDefines.h"

@interface GarageDoorDevice : NSObject

- (void)getDeviceStateWithCompletion:(nullable void (^)(NSString * _Nullable doorState,
                                                        NSString * _Nullable lightState,
                                                        NSError * _Nullable error))completion;
- (void)toggleGarageDoorWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;
- (void)toggleGarageLedsWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end
