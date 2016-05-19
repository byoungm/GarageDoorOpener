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
#define GARAGE_DOOR_STATE_UPDATE_TIMER_INTERVAL 1.0

@interface MainViewController ()
@property (nonatomic, strong) SparkDevice* garageDoorDevice;
@property (weak, nonatomic) IBOutlet UILabel *garageDoorStateLabel;
@property (strong, nonatomic) NSTimer *garageStateUpdateTimer;

- (NSString *)decodeGarageDoorStateString:(int)stateEnum;
- (void)loadGarageDoorDevice;
- (void)updateGarageStateLabel;
@end

@implementation MainViewController 

- (NSString *)decodeGarageDoorStateString:(int)stateEnum
{
    const NSArray *GarageDoorStateStrings = @[GARAGE_DOOR_OPEN_STR, GARAGE_DOOR_CLOSED_STR, GARAGE_DOOR_STATE_UNKNOWN_STR];
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
    if (!self.garageStateUpdateTimer || !self.garageStateUpdateTimer.valid)
    {
        self.garageStateUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:GARAGE_DOOR_STATE_UPDATE_TIMER_INTERVAL
                                                                       target:self
                                                                     selector:@selector(updateGarageStateLabel)
                                                                     userInfo:nil
                                                                      repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.garageStateUpdateTimer invalidate];
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

- (void)updateGarageStateLabel;
{
    [self.garageDoorDevice callFunction:@"webapi" withArguments:@[@"GARAGE_DOOR_GET_STATE"] completion:^(NSNumber *resultCode, NSError *error) {
        if (!error)
        {
            int res = [resultCode intValue];
            NSLog(@"Garage state :%d", res);
            self.garageDoorStateLabel.text = [self decodeGarageDoorStateString:res];
        }
        else
        {
            NSLog(@"Garage state error: %@", error);
        }
    }];
}

static int gToggleState = 0;

- (IBAction)toggleLeds:(id)sender {
    NSArray* LedCommands = @[@"LED_OFF",@"LED_ON"];
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
    [self.garageDoorDevice callFunction:@"webapi" withArguments:@[@"GARAGE_DOOR_CLICK_BUTTON"] completion:^(NSNumber *resultCode, NSError *error) {
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



@end

