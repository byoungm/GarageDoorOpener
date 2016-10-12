//
//  GDOWKStatusLabels.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 10/9/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "GDOWKStatusLabel.h"
#import "GDODeviceDefines.h"

@interface GDOWKStatusLabel()

@property (unsafe_unretained, nonatomic) WKInterfaceLabel *label;

@end

@implementation GDOWKStatusLabel

- (id)initWithWKLabel:(WKInterfaceLabel *)label
{
    if (self = [super init])
    {
        self.label = label;
        [self resetStatus];
    }
    return self;
}

- (void)resetStatus
{
    [self setStatus:GARAGE_STATE_UNKNOWN_STR];
}

- (void)setStatus:(NSString *)status
{
    self.label.text = status;
}

@end

@implementation GDOWKLightStatusLabel

- (void)setStatus:(NSString *)status
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
    self.label.textColor = color;
    self.label.text = [NSString stringWithFormat:@"Light: %@", status];
}


@end

@implementation GDOWKDoorStatusLabel

- (void)setStatus:(NSString *)status
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
    self.label.textColor = color;
    self.label.text = [NSString stringWithFormat:@"Door: %@", status];
}

@end
