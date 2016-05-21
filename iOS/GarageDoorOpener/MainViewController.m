//
//  ViewController.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/15/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "MainViewController.h"
#import "GarageDoorDevice.h"
#import "Spark-SDK.h"
#import "SegueDefinations.h"

#define GARAGE_DOOR_STATE_UPDATE_TIMER_INTERVAL 1.0

@interface MainViewController ()
@property (nonatomic, strong) GarageDoorDevice* garageDoorDevice;
@property (weak, nonatomic) IBOutlet UILabel *garageDoorStateLabel;
@property (strong, nonatomic) NSTimer *garageStateUpdateTimer;

@end


@implementation MainViewController 


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![SparkCloud sharedInstance].isAuthenticated)
    {
        [self performSegueWithIdentifier:PARTICLE_LOGIN_SEGUE sender:self];
    }
    self.garageDoorDevice = [[GarageDoorDevice alloc] init];
    if (!self.garageStateUpdateTimer || !self.garageStateUpdateTimer.valid)
    {
        self.garageStateUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:GARAGE_DOOR_STATE_UPDATE_TIMER_INTERVAL
                                                                       target:self
                                                                     selector:@selector(updateGarageDeviceState)
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

- (void)updateGarageDeviceState;
{
    [self.garageDoorDevice getDeviceStateWithCompletion:^(NSString * _Nullable deviceState, NSError * _Nullable error) {
        self.garageDoorStateLabel.text = deviceState;
    }];
}

- (IBAction)toggleLeds:(id)sender {

    [(UIButton *)sender setEnabled:NO];
    [self.garageDoorDevice toggleGarageLedsWithCompletion:^(NSError * _Nullable error) {
        [(UIButton *)sender setEnabled:YES];
    }];
}

- (IBAction)garageDoorClicked:(id)sender {
    [(UIButton *)sender setEnabled:NO];
    [self.garageDoorDevice toggleGarageDoorWithCompletion:^(NSError * _Nullable error) {
        [(UIButton *)sender setEnabled:YES];
    }];
}



@end

