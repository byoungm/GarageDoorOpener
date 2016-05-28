//
//  GarageDoorStatusView.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/28/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "GarageDoorStatusView.h"
#import "GarageDoorDevice.h"


@interface GarageDoorStatusView()
@property (nonatomic, weak) IBOutlet UILabel* doorStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel* lightStatusLabel;

- (void)initView;
@end


@implementation GarageDoorStatusView

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    [self setLightStatus:GARAGE_STATE_UNKNOWN_STR];
    [self setDoorStatus:GARAGE_STATE_UNKNOWN_STR];
}


- (void)setLightStatus:(NSString *)status
{
    UIColor *color;
    if ([status isEqualToString:GARAGE_LIGHT_ON_STR])
    {
        color = [UIColor greenColor];
    }
    else if ([status isEqualToString:GARAGE_LIGHT_OFF_STR])
    {
        color = [UIColor whiteColor];
    }
    else
    {
        color = [UIColor redColor];
    }
    self.lightStatusLabel.textColor = color;
    self.lightStatusLabel.text = status;
}

- (void)setDoorStatus:(NSString *)status
{
    UIColor *color;
    if ([status isEqualToString:GARAGE_DOOR_OPEN_STR])
    {
        color = [UIColor greenColor];
    }
    else if ([status isEqualToString:GARAGE_DOOR_CLOSED_STR])
    {
        color = [UIColor whiteColor];
    }
    else
    {
        color = [UIColor redColor];
    }
    self.doorStatusLabel.textColor = color;
    self.doorStatusLabel.text = status;
}


@end
