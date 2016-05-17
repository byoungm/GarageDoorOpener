//
//  ViewController.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/15/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "MainViewController.h"
#import "Spark-SDK.h"
#import "SegueDefinations.h"

#define PARTICLE_GARAGE_DOOR_DEVICE_NAME @"RB Duo 1"

#define GARAGE_DOOR_OPEN_STR @"Open"
#define GARAGE_DOOR_CLOSED_STR @"Closed"
#define GARAGE_DOOR_STATE_UNKNOWN_STR @"State Unknown"

@interface MainViewController ()
@property (nonatomic, strong) SparkDevice* garageDoorDevice;
@property (weak, nonatomic) IBOutlet UILabel *garageDoorStateLabel;

- (void)loadGarageDoorDevice;
+ (NSString *)decodeGarageDoorStateString:(int)stateEnum;
@end

@implementation MainViewController 

+ (NSString *)decodeGarageDoorStateString:(int)stateEnum
{
    NSArray *GarageDoorStateStrings = @[GARAGE_DOOR_OPEN_STR, GARAGE_DOOR_CLOSED_STR, GARAGE_DOOR_STATE_UNKNOWN_STR];
    return GarageDoorStateStrings[stateEnum];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![SparkCloud sharedInstance].isAuthenticated)
    {
        [self performSegueWithIdentifier:PARTICLE_LOGIN_SEGUE sender:self];
    }
    [self loadGarageDoorDevice];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.garageDoorStateLabel.text = GARAGE_DOOR_STATE_UNKNOWN_STR;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGarageDoorDevice
{
    [[SparkCloud sharedInstance] getDevices:^(NSArray *sparkDevices, NSError *error) {
        NSLog(@"%@",sparkDevices.description); // print all devices claimed to user
        
        // search for a specific device by name
        for (SparkDevice *device in sparkDevices)
        {
            if ([device.name isEqualToString:PARTICLE_GARAGE_DOOR_DEVICE_NAME])
                self.garageDoorDevice = device;
        }
    }];
}

static int gToggleState = 0;

- (IBAction)toggleLeds:(id)sender {
    NSArray* LedCommands = @[@"off",@"on"];
    gToggleState++;
    if(gToggleState > 1)
    {
        gToggleState = 0;
    }
    [self.garageDoorDevice callFunction:@"webapi" withArguments:@[LedCommands[gToggleState]] completion:^(NSNumber *resultCode, NSError *error) {
        if (!error)
        {
            NSLog(@"LED was tured on - Result Code:%d", [resultCode intValue]);
        }
    }];
}

- (IBAction)garageDoorClicked:(id)sender {
    [self.garageDoorDevice callFunction:@"webapi" withArguments:@[@"GarageDoorButtonClicked"] completion:^(NSNumber *resultCode, NSError *error) {
        if (!error)
        {
            NSLog(@"Garage button pushed - Result Code:%d", [resultCode intValue]);
        }
        else
        {
            NSLog(@"Garage door error: %@", error);
        }
    }];
}

/*
 // reading a variable
 [self.garageDoorDevice getVariable:@"temprature" completion:^(id result, NSError *error) {
 if (!error)
 {
 NSNumber *tempratureReading = (NSNumber *)result;
 NSLog(@"Room temprature is %f degrees",tempratureReading.floatValue);
 }
 else
 {
 NSLog(@"Failed reading temprature from Photon device");
 }
 }];
 */





@end

