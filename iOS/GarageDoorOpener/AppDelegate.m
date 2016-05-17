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

@interface AppDelegate ()
- (void)authParticleCloud;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
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
}

@end
