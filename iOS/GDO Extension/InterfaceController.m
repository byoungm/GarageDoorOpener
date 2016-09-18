//
//  InterfaceController.m
//  GDO Extension
//
//  Created by Benjamin Young on 9/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (IBAction)toggleLeds:(id)sender {
    
    [(WKInterfaceButton *)sender setEnabled:NO];
    
    // Ask iOS to perform actions to toggle light
    
    [(WKInterfaceButton *)sender setEnabled:YES];
}

- (IBAction)garageDoorClicked:(id)sender {
    [(WKInterfaceButton *)sender setEnabled:NO];
    
    // Ask iOS to perform actions to toggle garage door
    
    [(WKInterfaceButton *)sender setEnabled:YES];
}

@end



