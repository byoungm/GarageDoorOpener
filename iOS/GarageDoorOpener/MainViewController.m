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

@interface MainViewController ()
@property (nonatomic, strong) SparkDevice* garageDoorDevice;

- (void)loadGarageDoorDevice;

@end

@implementation MainViewController 

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
    // Do any additional setup after loading the view, typically from a nib.

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
    [self.garageDoorDevice callFunction:@"ledToggle" withArguments:@[LedCommands[gToggleState]] completion:^(NSNumber *resultCode, NSError *error) {
        if (!error)
        {
            NSLog(@"LED was tured on - Result Code:%d", [resultCode intValue]);
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

