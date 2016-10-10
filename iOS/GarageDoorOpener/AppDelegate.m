//
//  AppDelegate.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/15/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "AppDelegate.h"
#import "Spark-SDK.h"
#import "CredentialManager.h"
#import "GarageDoorDevice.h"
#import "GDOWCDefines.h"

@interface AppDelegate ()
@property (strong, nonatomic) GarageDoorDevice *garageDoorDevice;
- (void)authParticleCloud;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        self.garageDoorDevice = [[GarageDoorDevice alloc] init];
    }
    [self authParticleCloud];
    return YES;;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)authParticleCloud
{
    dispatch_async(dispatch_queue_create("Initial Partice Cloud Auth Queue", DISPATCH_QUEUE_SERIAL), ^{
        if (![SparkCloud sharedInstance].isAuthenticated)
        {
            CredentialManager *cm = [[CredentialManager alloc] init];
            NSDictionary *dict = [cm getUsernameAndPassword];
            NSString *username = dict[@"username"];
            NSString *password = dict[@"password"];
            [[SparkCloud sharedInstance] loginWithUser:username password:password completion:^(NSError *error){
                if (!error)
                {
                    NSLog(@"Logged in to cloud\nAccess Token: %@", [SparkCloud sharedInstance].accessToken);
                }
                else
                    NSLog(@"Wrong credentials or no internet connectivity, please try again");
            }];
        }
    });
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
    NSLog(@"Recieved Request for WC Action on iOS");
    if ([SparkCloud sharedInstance].isAuthenticated)
    {
        NSString *actionCmd = message[GDO_WC_KEY_ACTION_REQUEST];
        NSLog(@"Trying to process request: %@", actionCmd);
        if ([actionCmd isEqualToString:GDO_WC_ACTION_GARAGE_DOOR_TOGGLE])
        {
            [self.garageDoorDevice toggleGarageDoorWithCompletion:^(NSError * _Nullable error) {
                NSDictionary *dict = @{GDO_WC_KEY_SUCCESS_OCCURED: GDO_WC_NO_ERROR};
                if (error) dict = @{GDO_WC_KEY_ERROR_OCCURED: [error description]};
                replyHandler(dict);
            }];
        }
        else if ([actionCmd isEqualToString:GDO_WC_ACTION_GARAGE_LIGHT_TOGGLE])
        {
            [self.garageDoorDevice toggleGarageLedsWithCompletion:^(NSError * _Nullable error) {
                NSDictionary *dict = @{GDO_WC_KEY_SUCCESS_OCCURED: GDO_WC_NO_ERROR};
                if (error) dict = @{GDO_WC_KEY_ERROR_OCCURED: [error description]};
                replyHandler(dict);
            }];
        }
        else if ([actionCmd isEqualToString:GDO_WC_ACTION_GARAGE_GET_STATUS])
        {
            [self.garageDoorDevice getDeviceStateWithCompletion:^(NSString * _Nullable doorState,
                                                                  NSString * _Nullable lightState,
                                                                  NSError * _Nullable error) {
                NSDictionary *dict = @{GDO_WC_KEY_LIGHT_STATUS    : lightState,
                                       GDO_WC_KEY_DOOR_STATUS     : doorState};
                if (error) dict = @{GDO_WC_KEY_ERROR_OCCURED: [error description]};
                replyHandler(dict);
            }];
        }
        else
        {
            replyHandler(@{GDO_WC_KEY_ERROR_OCCURED: GDO_WC_ERROR_UNKNOWN_ACTION_CODE});
        }
    }
    else
    {
        replyHandler(@{GDO_WC_KEY_ERROR_OCCURED: GDO_WC_ERROR_NOT_AUTHENCATED});
    }
}

@end
